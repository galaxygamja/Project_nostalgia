class_name ScheduleManager
extends RefCounted


func add_fixed_schedule(state: GameState, schedule: Dictionary) -> Dictionary:
	return _add_schedule(state.fixed_schedules, schedule, true)


func add_free_schedule(state: GameState, schedule: Dictionary) -> Dictionary:
	return _add_schedule(state.free_schedules, schedule, false)


func find_conflicts(state: GameState, start_slot: int, end_slot: int, ignore_id: String = "") -> Array[Dictionary]:
	var conflicts: Array[Dictionary] = []
	for schedule in state.fixed_schedules + state.free_schedules:
		if str(schedule.get("id", "")) == ignore_id:
			continue
		if _overlaps(start_slot, end_slot, int(schedule.get("start_slot", -1)), int(schedule.get("end_slot", -1))):
			conflicts.append(schedule.duplicate(true))
	return conflicts


func get_due_schedules(state: GameState, slot: int) -> Array[Dictionary]:
	var due: Array[Dictionary] = []
	for schedule in state.fixed_schedules + state.free_schedules:
		if int(schedule.get("start_slot", -1)) == slot and not bool(schedule.get("completed", false)):
			due.append(schedule.duplicate(true))
	return due


func mark_completed(state: GameState, schedule_id: String) -> bool:
	for schedules in [state.fixed_schedules, state.free_schedules]:
		for schedule in schedules:
			if str(schedule.get("id", "")) == schedule_id:
				schedule["completed"] = true
				return true
	return false


func _add_schedule(target: Array[Dictionary], schedule: Dictionary, fixed: bool) -> Dictionary:
	var normalized := schedule.duplicate(true)
	var error := _validate(normalized)
	if not error.is_empty():
		return {"ok": false, "error": error}
	normalized["fixed"] = fixed
	normalized["completed"] = bool(normalized.get("completed", false))
	target.append(normalized)
	target.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return int(a["start_slot"]) < int(b["start_slot"]))
	return {"ok": true, "schedule": normalized.duplicate(true)}


func _validate(schedule: Dictionary) -> String:
	if str(schedule.get("id", "")).is_empty():
		return "schedule id is required"
	var start_slot := int(schedule.get("start_slot", -1))
	var end_slot := int(schedule.get("end_slot", -1))
	if start_slot < 0 or end_slot <= start_slot:
		return "schedule slot range is invalid"
	return ""


func _overlaps(a_start: int, a_end: int, b_start: int, b_end: int) -> bool:
	return a_start < b_end and b_start < a_end
