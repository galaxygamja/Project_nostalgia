class_name GameLoopV1
extends RefCounted

signal state_changed(previous_state: String, current_state: String)
signal situation_ready(snapshot: Dictionary, available_actions: Array[Dictionary])
signal log_added(entry: Dictionary)
signal choice_required(payload: Dictionary)
signal game_ended(result: Dictionary)

enum Phase { UNINITIALIZED, AWAITING_ACTION, ADVANCING_TIME, RESOLVING_CHOICE, GAME_OVER, ERROR }

var phase: Phase = Phase.UNINITIALIZED
var game_state: GameState
var actions: Array[Dictionary] = []
var resource_rates: Dictionary = {}
var logs: Array[Dictionary] = []
var time_manager := TimeManager.new()
var action_resolver := ActionResolverV1.new()
var resource_processor := ResourceTickProcessorV1.new()
var end_conditions := EndConditionRegistryV1.new()


func initialize(initial_data: Dictionary, action_definitions: Array[Dictionary], configured_max_days: int = 100) -> Dictionary:
	game_state = GameState.new()
	game_state.initialize(initial_data, configured_max_days)
	actions = action_definitions.duplicate(true)
	resource_rates = initial_data.get("resource_rates", {}).duplicate(true)
	_change_phase(Phase.AWAITING_ACTION)
	return refresh_situation()


func refresh_situation() -> Dictionary:
	if game_state == null:
		return _fail("game loop is not initialized")
	var available := get_available_actions()
	var result := {"ok": true, "phase": phase, "snapshot": game_state.to_snapshot(), "available_actions": available}
	situation_ready.emit(result.snapshot, available)
	return result


func get_available_actions() -> Array[Dictionary]:
	var available: Array[Dictionary] = []
	if phase != Phase.AWAITING_ACTION:
		return available
	for action in actions:
		var condition_result := action_resolver.evaluate(action, game_state)
		var time_result := time_manager.can_start_action(game_state, action)
		if condition_result.available and time_result.ok:
			available.append(action.duplicate(true))
	return available


func select_action(action_id: String) -> Dictionary:
	if phase != Phase.AWAITING_ACTION:
		return {"ok": false, "reason": "game loop is not awaiting an action"}
	var action := _find_action(action_id)
	if action.is_empty():
		return {"ok": false, "reason": "unknown action id"}
	var conditions := action_resolver.evaluate(action, game_state)
	if not conditions.available:
		return {"ok": false, "reason": "action requirements are not met", "details": conditions.reasons}
	var started := time_manager.start_action(game_state, action)
	if not started.ok:
		return started
	_append_log("action_started", {"action_id": action_id, "slot": game_state.current_slot})
	_change_phase(Phase.ADVANCING_TIME)
	return _advance_until_interruption()


func resolve_choice(effects: Array, choice_id: String = "") -> Dictionary:
	if phase != Phase.RESOLVING_CHOICE:
		return {"ok": false, "reason": "there is no pending choice"}
	var applied := action_resolver.apply_effects(effects, game_state)
	_append_log("choice_resolved", {"choice_id": choice_id, "effects": applied})
	_change_phase(Phase.ADVANCING_TIME if not game_state.current_action.is_empty() else Phase.AWAITING_ACTION)
	return _advance_until_interruption() if phase == Phase.ADVANCING_TIME else refresh_situation()


func request_choice(payload: Dictionary) -> void:
	_change_phase(Phase.RESOLVING_CHOICE)
	choice_required.emit(payload.duplicate(true))


func _advance_until_interruption() -> Dictionary:
	while phase == Phase.ADVANCING_TIME:
		var advanced := time_manager.advance_slots(game_state, 1)
		if not advanced.ok:
			return _fail(str(advanced.get("reason", "time advance failed")))
		var resource_changes := resource_processor.process_slot(game_state, resource_rates)
		_append_log("slot_advanced", {"slot": game_state.current_slot, "resource_changes": resource_changes})
		for schedule in advanced.schedules:
			_append_log("schedule_due", schedule)
		if not advanced.completed_actions.is_empty():
			for completed_action in advanced.completed_actions:
				var effects := action_resolver.apply_effects(completed_action.get("effects", []), game_state)
				_append_log("action_completed", {"action_id": completed_action.get("id", ""), "effects": effects})
			var end_result := end_conditions.evaluate(game_state)
			if end_result.ended:
				_change_phase(Phase.GAME_OVER)
				game_ended.emit(end_result)
				return {"ok": true, "ended": true, "result": end_result}
			_change_phase(Phase.AWAITING_ACTION)
			return refresh_situation()
	return {"ok": true, "phase": phase}


func _find_action(action_id: String) -> Dictionary:
	for action in actions:
		if str(action.get("id", "")) == action_id:
			return action.duplicate(true)
	return {}


func _append_log(type: String, payload: Dictionary) -> void:
	var entry := {"type": type, "slot": game_state.current_slot, "payload": payload.duplicate(true)}
	logs.append(entry)
	log_added.emit(entry.duplicate(true))


func _change_phase(next_phase: Phase) -> void:
	var previous := Phase.keys()[phase]
	phase = next_phase
	state_changed.emit(previous, Phase.keys()[phase])


func _fail(reason: String) -> Dictionary:
	_change_phase(Phase.ERROR)
	_append_log("error", {"reason": reason})
	return {"ok": false, "reason": reason}
