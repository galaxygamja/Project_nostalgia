class_name GameState
extends RefCounted

var max_days := 1000
var slots_per_day := 48
var minutes_per_slot := 30
var prototype_end_slot := -1
var current_slot := 0
var commander_id := ""
var current_action: Dictionary = {}
var fixed_schedules: Array[Dictionary] = []
var free_schedules: Array[Dictionary] = []
var scheduled_events: Array[Dictionary] = []
var resources: Dictionary = {}
var characters: Dictionary = {}
var facilities: Dictionary = {}
var flags: Dictionary = {}
var clue_ids: Array[String] = []
var deduction_ids: Array[String] = []
var unlocked_task_ids: Array[String] = []
var encounter_state: Dictionary = {}
var schedule_delegates: Dictionary = {}
var operation_log: Array[Dictionary] = []


func initialize(initial_data: Dictionary, config: Dictionary = {}) -> void:
	max_days = maxi(1, int(config.get("max_days", 1000)))
	slots_per_day = maxi(1, int(config.get("slots_per_day", 48)))
	minutes_per_slot = maxi(1, int(config.get("minutes_per_slot", 30)))
	prototype_end_slot = int(config.get("prototype_end_slot", -1))
	current_slot = clampi(int(initial_data.get("current_slot", 0)), 0, get_last_slot())
	commander_id = str(initial_data.get("commander_id", ""))
	current_action = _copy_dictionary(initial_data.get("current_action", {}))
	fixed_schedules = _copy_dictionary_array(initial_data.get("fixed_schedules", []))
	free_schedules = _copy_dictionary_array(initial_data.get("free_schedules", []))
	scheduled_events = _copy_dictionary_array(initial_data.get("scheduled_events", []))
	resources = _copy_dictionary(initial_data.get("resources", {}))
	characters = _copy_dictionary(initial_data.get("characters", {}))
	facilities = _copy_dictionary(initial_data.get("facilities", {}))
	flags = _copy_dictionary(initial_data.get("flags", {}))
	clue_ids.assign(_copy_string_array(initial_data.get("clue_ids", [])))
	deduction_ids.assign(_copy_string_array(initial_data.get("deduction_ids", [])))
	unlocked_task_ids.assign(_copy_string_array(initial_data.get("initial_task_ids", [])))


func get_day_index() -> int:
	return current_slot / slots_per_day


func get_day() -> int:
	return get_day_index() + 1


func get_slot_of_day() -> int:
	return current_slot % slots_per_day


func get_hour() -> int:
	return get_slot_of_day() * minutes_per_slot / 60


func get_minute() -> int:
	return get_slot_of_day() * minutes_per_slot % 60


func get_last_slot() -> int:
	return max_days * slots_per_day - 1


func is_time_limit_reached() -> bool:
	return current_slot >= get_last_slot()


func is_prototype_complete() -> bool:
	return prototype_end_slot >= 0 and current_slot >= prototype_end_slot


func add_clue(id: String) -> void:
	if not id.is_empty() and id not in clue_ids:
		clue_ids.append(id)


func add_deduction(id: String) -> void:
	if not id.is_empty() and id not in deduction_ids:
		deduction_ids.append(id)


func unlock_task(id: String) -> void:
	if not id.is_empty() and id not in unlocked_task_ids:
		unlocked_task_ids.append(id)


func to_snapshot() -> Dictionary:
	return {
		"max_days": max_days, "slots_per_day": slots_per_day, "minutes_per_slot": minutes_per_slot,
		"prototype_end_slot": prototype_end_slot, "current_slot": current_slot, "commander_id": commander_id,
		"current_action": current_action.duplicate(true), "fixed_schedules": fixed_schedules.duplicate(true),
		"free_schedules": free_schedules.duplicate(true), "resources": resources.duplicate(true),
		"characters": characters.duplicate(true), "facilities": facilities.duplicate(true), "flags": flags.duplicate(true),
		"clue_ids": clue_ids.duplicate(), "deduction_ids": deduction_ids.duplicate(),
		"unlocked_task_ids": unlocked_task_ids.duplicate(), "operation_log": operation_log.duplicate(true)
	}


func _copy_dictionary(value: Variant) -> Dictionary:
	return value.duplicate(true) if value is Dictionary else {}


func _copy_dictionary_array(value: Variant) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if value is Array:
		for item in value:
			if item is Dictionary:
				result.append(item.duplicate(true))
	return result


func _copy_string_array(value: Variant) -> Array[String]:
	var result: Array[String] = []
	if value is Array:
		for item in value:
			if item is String:
				result.append(item)
	return result
