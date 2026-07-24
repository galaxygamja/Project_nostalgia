class_name GameLoopV1
extends RefCounted

signal state_changed(previous_state: String, current_state: String)
signal situation_ready(snapshot: Dictionary, available_actions: Array[Dictionary])
signal log_added(entry: Dictionary)
signal encounter_required(payload: Dictionary)
signal game_ended(result: Dictionary)

enum Phase { UNINITIALIZED, AWAITING_ACTION, ADVANCING_TIME, RESOLVING_ENCOUNTER, GAME_OVER, ERROR }

var phase: Phase = Phase.UNINITIALIZED
var game_state: GameState
var repository: GameDataRepository
var actions: Array[Dictionary] = []
var resource_definitions: Dictionary = {}
var logs: Array[Dictionary] = []
var pending_encounter: Dictionary = {}
var time_manager := TimeManager.new()
var action_resolver := ActionResolverV1.new()
var resource_processor := ResourceTickProcessorV1.new()
var formula_evaluator := FormulaEvaluator.new()
var rng := RandomNumberGenerator.new()


func initialize(initial_data: Dictionary, config: Dictionary, source_repository: GameDataRepository, configured_resource_definitions: Dictionary = {}, configured_fixed_schedules: Array[Dictionary] = []) -> Dictionary:
	repository = source_repository
	game_state = GameState.new()
	game_state.initialize(initial_data, config)
	game_state.fixed_schedules = configured_fixed_schedules.duplicate(true)
	actions = repository.get_all_by_type("action")
	resource_definitions = configured_resource_definitions.duplicate(true)
	rng.seed = 240724
	_change_phase(Phase.AWAITING_ACTION)
	return refresh_situation()


func refresh_situation() -> Dictionary:
	if game_state == null:
		return _fail("game loop is not initialized")
	if game_state.is_prototype_complete():
		return _finish_prototype()
	var due := _start_due_encounter()
	if due.get("ok", false):
		return due
	var available := get_available_actions()
	var result := {"ok": true, "phase": phase, "snapshot": game_state.to_snapshot(), "available_actions": available, "available_tasks": get_available_tasks(), "available_deductions": get_available_deductions()}
	situation_ready.emit(result.snapshot, available)
	return result


func get_available_actions() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if phase != Phase.AWAITING_ACTION:
		return result
	for action in actions:
		result.append(action.duplicate(true))
	return result


func get_available_tasks() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for task_id in game_state.unlocked_task_ids:
		var task := repository.get_data(task_id)
		if not task.is_empty():
			result.append(task)
	return result


func get_available_deductions() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for deduction in repository.get_all_by_type("deduction"):
		if _deduction_available(deduction):
			result.append(deduction)
	return result


func select_action(action_id: String, assignee_id: String = "", requested_duration_slots: int = 0) -> Dictionary:
	var action := _find_by_id(actions, action_id)
	if action.is_empty():
		return {"ok": false, "reason": "unknown action id"}
	var prepared := _prepare_duration(action, requested_duration_slots)
	if not prepared.get("ok", false):
		return prepared
	var performer := _validate_assignee(str(prepared.action.get("required_skill", "")), bool(prepared.action.get("delegate_allowed", false)), assignee_id)
	if not performer.get("ok", false):
		return performer
	var requirements := action_resolver.evaluate(prepared.action.get("requirements", {}), game_state, {"assignee_id": performer.assignee_id})
	if not requirements.available:
		return {"ok": false, "reason": "action requirements are not met", "details": requirements.reasons}
	prepared.action["kind"] = "action"
	prepared.action["assignee_id"] = performer.assignee_id
	return _start_runtime_action(prepared.action)


func select_task(task_id: String, assignee_id: String = "") -> Dictionary:
	if task_id not in game_state.unlocked_task_ids:
		return {"ok": false, "reason": "task is not unlocked"}
	var task := repository.get_data(task_id)
	if task.is_empty():
		return {"ok": false, "reason": "unknown task id"}
	var performer := _validate_assignee(str(task.get("required_skill", "")), bool(task.get("delegate_allowed", false)), assignee_id)
	if not performer.get("ok", false):
		return performer
	var duration_formula := repository.get_data(str(task.get("duration_formula_id", "")))
	var duration_result := formula_evaluator.evaluate(duration_formula, _formula_variables(task, performer.assignee_id))
	if not duration_result.get("ok", false):
		return duration_result
	return _start_runtime_action({"id": task_id, "kind": "task", "task_id": task_id, "assignee_id": performer.assignee_id, "duration_slots": int(duration_result.value), "effects_per_slot": [], "completion_effects": [], "interruptible_by_emergency": true})


func start_deduction(deduction_id: String) -> Dictionary:
	var deduction := repository.get_data(deduction_id)
	if deduction.is_empty() or not _deduction_available(deduction):
		return {"ok": false, "reason": "deduction is unavailable"}
	return _start_runtime_action({"id": deduction_id, "kind": "deduction", "deduction_id": deduction_id, "assignee_id": game_state.commander_id, "duration_slots": int(deduction.get("time_cost_slots", 0)), "effects_per_slot": [], "completion_effects": [], "interruptible_by_emergency": true})


func assign_schedule_delegate(schedule_id: String, assignee_id: String) -> Dictionary:
	var performer := _validate_assignee("administration", true, assignee_id)
	if not performer.get("ok", false):
		return performer
	for schedule in game_state.fixed_schedules:
		if str(schedule.get("id", "")) == schedule_id and bool(schedule.get("delegate_allowed", false)):
			game_state.schedule_delegates[schedule_id] = performer.assignee_id
			return {"ok": true, "assignee_id": performer.assignee_id}
	return {"ok": false, "reason": "schedule cannot be delegated"}


func resolve_encounter(choice_id: String = "") -> Dictionary:
	if phase != Phase.RESOLVING_ENCOUNTER or pending_encounter.is_empty():
		return {"ok": false, "reason": "there is no pending encounter"}
	var encounter: Dictionary = pending_encounter.encounter
	var choices: Array = encounter.get("choices", [])
	if not choices.is_empty():
		var choice := {}
		for entry in choices:
			if str(entry.get("choice_id", "")) == choice_id:
				choice = entry
		if choice.is_empty():
			return {"ok": false, "reason": "a valid encounter choice is required"}
		var allowed := action_resolver.evaluate(choice.get("requirements", {}), game_state)
		if not allowed.available:
			return {"ok": false, "reason": "choice requirements are not met", "details": allowed.reasons}
		var choice_effects := action_resolver.apply_effects(choice.get("effects", []), game_state)
		if not choice_effects.ok:
			return _fail(str(choice_effects.reason))
		_append_log("encounter_choice", {"encounter_id": encounter.id, "choice_id": choice_id, "effects": choice_effects.applied})
	_mark_encounter_resolved()
	if not game_state.current_action.is_empty():
		_change_phase(Phase.ADVANCING_TIME)
		return _advance_until_interruption()
	_change_phase(Phase.AWAITING_ACTION)
	return refresh_situation()


func _start_runtime_action(action: Dictionary) -> Dictionary:
	if phase != Phase.AWAITING_ACTION:
		return {"ok": false, "reason": "game loop is not awaiting an action"}
	var time_check := time_manager.start_action(game_state, action)
	if not time_check.get("ok", false):
		return time_check
	_append_log("action_started", {"action_id": action.id, "kind": action.kind, "assignee_id": action.assignee_id})
	_change_phase(Phase.ADVANCING_TIME)
	return _advance_until_interruption()


func _advance_until_interruption() -> Dictionary:
	while phase == Phase.ADVANCING_TIME:
		if game_state.is_prototype_complete():
			return _finish_prototype()
		var active := game_state.current_action.duplicate(true)
		var advanced := time_manager.advance_slots(game_state, 1)
		if not advanced.get("ok", false):
			return _fail(str(advanced.get("reason", "time advance failed")))
		var effect_result := action_resolver.apply_effects(active.get("effects_per_slot", []), game_state, {"assignee_id": active.get("assignee_id", game_state.commander_id)})
		if not effect_result.ok:
			return _fail(str(effect_result.reason))
		_append_log("slot_advanced", {"slot": game_state.current_slot, "resource_changes": resource_processor.process_slot(game_state, resource_definitions)})
		if not advanced.completed_actions.is_empty():
			var completed: Dictionary = advanced.completed_actions[0]
			var completion := _complete_runtime_action(completed)
			if not completion.get("ok", false):
				return completion
			var pool_event := _queue_action_pool_encounter(completed)
			if pool_event.get("ok", false):
				return pool_event
		var due := _start_due_encounter()
		if due.get("ok", false):
			return due
		if not game_state.current_action.is_empty():
			continue
		if game_state.is_prototype_complete():
			return _finish_prototype()
		_change_phase(Phase.AWAITING_ACTION)
		return refresh_situation()
	return {"ok": true, "phase": phase}


func _complete_runtime_action(completed: Dictionary) -> Dictionary:
	var kind := str(completed.get("kind", "action"))
	if kind == "task":
		var task := repository.get_data(str(completed.get("task_id", "")))
		var score_formula := repository.get_data(str(task.get("success_formula_id", "")))
		var score_result := formula_evaluator.evaluate(score_formula, _formula_variables(task, str(completed.get("assignee_id", ""))))
		if not score_result.ok:
			return _fail(str(score_result.reason))
		var outcome := _task_outcome(task, float(score_result.value))
		var outcome_effects := action_resolver.apply_effects(outcome.get("effects", []), game_state, {"assignee_id": completed.get("assignee_id", "")})
		if not outcome_effects.ok:
			return _fail(str(outcome_effects.reason))
		for encounter_id in outcome.get("add_encounter_ids", []):
			_queue_encounter(str(encounter_id), "task_outcome")
		_append_log("task_completed", {"task_id": task.id, "assignee_id": completed.assignee_id, "score": score_result.value, "outcome": outcome.get("result", ""), "effects": outcome_effects.applied})
	elif kind == "deduction":
		var deduction := repository.get_data(str(completed.get("deduction_id", "")))
		var effects := action_resolver.apply_effects(deduction.get("success_effects", []), game_state)
		if not effects.ok:
			return _fail(str(effects.reason))
		game_state.add_deduction(str(deduction.id))
		for task_id in deduction.get("unlocked_task_ids", []): game_state.unlock_task(str(task_id))
		for encounter_id in deduction.get("unlocked_encounter_ids", []): _queue_encounter(str(encounter_id), "deduction")
		_append_log("deduction_completed", {"deduction_id": deduction.id, "effects": effects.applied})
	else:
		var effects := action_resolver.apply_effects(completed.get("completion_effects", []), game_state, {"assignee_id": completed.get("assignee_id", game_state.commander_id)})
		if not effects.ok:
			return _fail(str(effects.reason))
		_append_log("action_completed", {"action_id": completed.id, "assignee_id": completed.get("assignee_id", ""), "effects": effects.applied})
	return {"ok": true}


func _start_due_encounter() -> Dictionary:
	if not pending_encounter.is_empty():
		return _present_pending_encounter()
	for schedule in game_state.fixed_schedules:
		if int(schedule.get("start_slot", -1)) == game_state.current_slot and not bool(schedule.get("completed", false)):
			_queue_encounter(str(schedule.get("encounter_id", "")), "fixed_schedule", str(schedule.get("id", "")))
			return _present_pending_encounter()
	for event in game_state.scheduled_events:
		if int(event.get("start_slot", -1)) == game_state.current_slot and not bool(event.get("completed", false)):
			_queue_encounter(str(event.get("encounter_id", "")), "timetable", str(event.get("id", "")))
			return _present_pending_encounter()
	return {"ok": false}


func _queue_action_pool_encounter(action: Dictionary) -> Dictionary:
	for pool_id in action.get("encounter_pool_ids", []):
		var pool := repository.get_data(str(pool_id))
		var eligible: Array[Dictionary] = []
		var total_weight := 0.0
		for record_variant in pool.get("encounters", []):
			if not record_variant is Dictionary:
				continue
			var record: Dictionary = record_variant
			if bool(record.get("enabled", true)) and _encounter_eligible(str(record.get("encounter_id", ""))):
				eligible.append(record)
				total_weight += maxf(0.0, float(record.get("weight", 0.0)))
		if total_weight <= 0.0:
			continue
		var roll := rng.randf() * total_weight
		var cumulative := 0.0
		for record in eligible:
			cumulative += maxf(0.0, float(record.get("weight", 0.0)))
			if roll < cumulative:
				_queue_encounter(str(record.get("encounter_id", "")), "action_pool", str(pool_id))
				return _present_pending_encounter()
	return {"ok": false}


func _queue_encounter(encounter_id: String, source: String, source_id: String = "") -> void:
	if encounter_id.is_empty() or not pending_encounter.is_empty():
		return
	var encounter := repository.get_data(encounter_id)
	if not encounter.is_empty():
		pending_encounter = {"encounter": encounter, "source": source, "source_id": source_id}


func _present_pending_encounter() -> Dictionary:
	if pending_encounter.is_empty(): return {"ok": false}
	var encounter: Dictionary = pending_encounter.encounter
	var effects := action_resolver.apply_effects(encounter.get("automatic_effects", []), game_state)
	if not effects.ok: return _fail(str(effects.reason))
	var encounter_state: Dictionary = game_state.encounter_state.get(str(encounter.id), {})
	encounter_state["seen"] = true
	encounter_state["last_slot"] = game_state.current_slot
	encounter_state["day"] = game_state.get_day_index()
	game_state.encounter_state[encounter.id] = encounter_state
	_change_phase(Phase.RESOLVING_ENCOUNTER)
	var payload := {"ok": true, "phase": phase, "encounter": encounter.duplicate(true), "source": pending_encounter.source, "source_id": pending_encounter.source_id, "snapshot": game_state.to_snapshot()}
	encounter_required.emit(payload)
	return payload


func _mark_encounter_resolved() -> void:
	var source := str(pending_encounter.get("source", ""))
	var source_id := str(pending_encounter.get("source_id", ""))
	if source == "fixed_schedule":
		time_manager.schedule_manager.mark_completed(game_state, source_id)
	elif source == "timetable":
		for event in game_state.scheduled_events:
			if str(event.get("id", "")) == source_id: event["completed"] = true
	pending_encounter.clear()


func _encounter_eligible(encounter_id: String) -> bool:
	var encounter := repository.get_data(encounter_id)
	if encounter.is_empty(): return false
	var requirements := action_resolver.evaluate(encounter.get("requirements", {}), game_state)
	if not requirements.available: return false
	var state: Dictionary = game_state.encounter_state.get(encounter_id, {})
	var policy: Dictionary = encounter.get("repeat_policy", {})
	match str(policy.get("type", "")):
		"one_time": return not bool(state.get("seen", false))
		"daily_once": return int(state.get("day", -1)) != game_state.get_day_index()
		"cooldown": return game_state.current_slot - int(state.get("last_slot", -999999)) >= int(policy.get("cooldown_slots", 0))
	return true


func _deduction_available(deduction: Dictionary) -> bool:
	if str(deduction.get("id", "")) in game_state.deduction_ids: return false
	for clue_id in deduction.get("required_clue_ids", []):
		if str(clue_id) not in game_state.clue_ids: return false
	for flag in deduction.get("excluded_flags", []):
		if bool(game_state.flags.get(str(flag), false)): return false
	return true


func _validate_assignee(required_skill: String, delegate_allowed: bool, requested_id: String) -> Dictionary:
	var assignee_id := requested_id if not requested_id.is_empty() else game_state.commander_id
	if assignee_id != game_state.commander_id and not delegate_allowed:
		return {"ok": false, "reason": "this work cannot be delegated"}
	var character: Dictionary = game_state.characters.get(assignee_id, {})
	if character.is_empty() or not bool(character.get("alive", false)) or not bool(character.get("available", false)):
		return {"ok": false, "reason": "assignee is unavailable"}
	if not required_skill.is_empty():
		var definition := repository.get_data(assignee_id)
		if float(definition.get("skills", {}).get(required_skill, 0.0)) <= 0.0:
			return {"ok": false, "reason": "assignee lacks required skill"}
	return {"ok": true, "assignee_id": assignee_id}


func _prepare_duration(action: Dictionary, requested: int) -> Dictionary:
	var prepared := action.duplicate(true)
	if prepared.get("duration_slots") != null:
		if requested > 0 and requested != int(prepared.duration_slots): return {"ok": false, "reason": "fixed-duration action does not accept a requested duration"}
		return {"ok": true, "action": prepared}
	var range: Dictionary = prepared.get("duration_range", {})
	if requested < int(range.get("minimum_slots", 0)) or requested > int(range.get("maximum_slots", -1)):
		return {"ok": false, "reason": "requested duration is outside the action duration range"}
	prepared["duration_slots"] = requested
	return {"ok": true, "action": prepared}


func _formula_variables(task: Dictionary, assignee_id: String) -> Dictionary:
	var definition := repository.get_data(assignee_id)
	var state: Dictionary = game_state.characters.get(assignee_id, {})
	var facility: Dictionary = game_state.facilities.get(str(task.get("target_id", "")), {})
	return {"assignee.skill": definition.get("skills", {}).get(task.get("required_skill", ""), 0.0), "assignee.trust": state.get("trust", 0.0), "assignee.fatigue": state.get("fatigue", 0.0), "assignee.stress": state.get("stress", 0.0), "facility.bonus": facility.get("efficiency", 0.0), "task.difficulty": task.get("difficulty", 0.0), "task.base_duration_slots": task.get("base_duration_slots", 1)}


func _task_outcome(task: Dictionary, score: float) -> Dictionary:
	for outcome in task.get("outcome_table", []):
		if score >= float(outcome.get("minimum_score", 0.0)): return outcome
	return {}


func _find_by_id(entries: Array[Dictionary], id: String) -> Dictionary:
	for entry in entries:
		if str(entry.get("id", "")) == id: return entry.duplicate(true)
	return {}


func _finish_prototype() -> Dictionary:
	_change_phase(Phase.GAME_OVER)
	var result := {"ok": true, "ended": true, "result": {"type": "prototype_operation_record", "snapshot": game_state.to_snapshot(), "logs": logs.duplicate(true)}}
	game_ended.emit(result.result)
	return result


func _append_log(type: String, payload: Dictionary) -> void:
	var entry := {"type": type, "slot": game_state.current_slot, "payload": payload.duplicate(true)}
	logs.append(entry)
	game_state.operation_log.append(entry)
	log_added.emit(entry.duplicate(true))


func _change_phase(next_phase: Phase) -> void:
	var previous: String = str(Phase.keys()[phase])
	phase = next_phase
	state_changed.emit(previous, Phase.keys()[phase])


func _fail(reason: String) -> Dictionary:
	_change_phase(Phase.ERROR)
	_append_log("error", {"reason": reason})
	return {"ok": false, "reason": reason}
