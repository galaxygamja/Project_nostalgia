extends SceneTree

const GameStateScript = preload("res://scripts/runtime/game_state.gd")
const ScheduleManagerScript = preload("res://scripts/runtime/schedule_manager.gd")
const TimeManagerScript = preload("res://scripts/runtime/time_manager.gd")


func _initialize() -> void:
	var state := GameStateScript.new()
	state.initialize({}, {"max_days": 100, "slots_per_day": 48, "minutes_per_slot": 30})
	var schedules := ScheduleManagerScript.new()
	assert(schedules.add_fixed_schedule(state, {"id": "sleep", "start_slot": 2, "end_slot": 4}).ok)
	var time := TimeManagerScript.new()
	assert(not time.can_start_action(state, {"id": "repair", "duration_slots": 3}).ok)
	assert(time.start_action(state, {"id": "inspect", "duration_slots": 2}).ok)
	var result := time.advance_slots(state, 2)
	assert(result.ok)
	assert(result.completed_actions.size() == 1)
	assert(result.schedules.size() == 1)
	assert(state.current_action.is_empty())
	assert(state.get_day() == 1)
	assert(state.get_hour() == 1)
	print("runtime_core_test: PASS")
	quit()
