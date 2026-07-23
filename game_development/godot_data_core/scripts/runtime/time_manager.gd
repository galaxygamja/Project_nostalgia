class_name TimeManager
extends RefCounted

signal slot_advanced(previous_slot: int, current_slot: int)
signal day_changed(day: int)
signal action_completed(action: Dictionary)
signal schedules_due(schedules: Array[Dictionary])
signal time_limit_reached()

var schedule_manager := ScheduleManager.new()


func can_start_action(state: GameState, action: Dictionary) -> Dictionary:
	if not state.current_action.is_empty():
		return {"ok": false, "reason": "another action is already active"}
	var duration_slots := int(action.get("duration_slots", 0))
	if duration_slots <= 0:
		return {"ok": false, "reason": "duration_slots must be positive"}
	var end_slot := state.current_slot + duration_slots
	if end_slot > state.max_days * GameState.SLOTS_PER_DAY:
		return {"ok": false, "reason": "action exceeds the game time limit"}
	var conflicts := schedule_manager.find_conflicts(state, state.current_slot, end_slot)
	for conflict in conflicts:
		if bool(conflict.get("fixed", false)):
			return {"ok": false, "reason": "action conflicts with a fixed schedule", "conflicts": conflicts}
	return {"ok": true, "end_slot": end_slot, "conflicts": conflicts}


func start_action(state: GameState, action: Dictionary) -> Dictionary:
	var check := can_start_action(state, action)
	if not check.get("ok", false):
		return check
	state.current_action = action.duplicate(true)
	state.current_action["started_at_slot"] = state.current_slot
	state.current_action["ends_at_slot"] = int(check["end_slot"])
	return {"ok": true, "action": state.current_action.duplicate(true)}


func advance_slots(state: GameState, amount: int = 1) -> Dictionary:
	if amount <= 0:
		return {"ok": false, "reason": "amount must be positive"}
	var completed_actions: Array[Dictionary] = []
	var triggered_schedules: Array[Dictionary] = []
	for _step in amount:
		if state.is_time_limit_reached():
			time_limit_reached.emit()
			return {"ok": false, "reason": "time limit reached", "completed_actions": completed_actions, "schedules": triggered_schedules}
		var previous_slot := state.current_slot
		var previous_day := state.get_day()
		state.current_slot += 1
		slot_advanced.emit(previous_slot, state.current_slot)
		if state.get_day() != previous_day:
			day_changed.emit(state.get_day())
		if not state.current_action.is_empty() and state.current_slot >= int(state.current_action.get("ends_at_slot", -1)):
			var completed := state.current_action.duplicate(true)
			state.current_action.clear()
			completed_actions.append(completed)
			action_completed.emit(completed)
		var due := schedule_manager.get_due_schedules(state, state.current_slot)
		if not due.is_empty():
			triggered_schedules.append_array(due)
			schedules_due.emit(due)
	return {"ok": true, "completed_actions": completed_actions, "schedules": triggered_schedules}
