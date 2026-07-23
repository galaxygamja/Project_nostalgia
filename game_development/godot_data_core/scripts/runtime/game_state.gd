class_name GameState
extends RefCounted

const SLOTS_PER_DAY := 48
const MINUTES_PER_SLOT := 30

var max_days: int = 100
var current_slot: int = 0
var current_action: Dictionary = {}
var fixed_schedules: Array[Dictionary] = []
var free_schedules: Array[Dictionary] = []
var resources: Dictionary = {}
var characters: Dictionary = {}
var facilities: Dictionary = {}
var flags: Dictionary = {}


func initialize(initial_data: Dictionary, configured_max_days: int = 100) -> void:
	max_days = maxi(1, configured_max_days)
	current_slot = clampi(int(initial_data.get("current_slot", 0)), 0, get_last_slot())
	current_action = _copy_dictionary(initial_data.get("current_action", {}))
	fixed_schedules = _copy_dictionary_array(initial_data.get("fixed_schedules", []))
	free_schedules = _copy_dictionary_array(initial_data.get("free_schedules", []))
	resources = _copy_dictionary(initial_data.get("resources", {}))
	characters = _copy_dictionary(initial_data.get("characters", {}))
	facilities = _copy_dictionary(initial_data.get("facilities", {}))
	flags = _copy_dictionary(initial_data.get("flags", {}))


func get_day() -> int:
	return current_slot / SLOTS_PER_DAY + 1


func get_slot_of_day() -> int:
	return current_slot % SLOTS_PER_DAY


func get_hour() -> int:
	return get_slot_of_day() / 2


func get_minute() -> int:
	return 30 if get_slot_of_day() % 2 == 1 else 0


func get_last_slot() -> int:
	return max_days * SLOTS_PER_DAY - 1


func is_time_limit_reached() -> bool:
	return current_slot >= get_last_slot()


func to_snapshot() -> Dictionary:
	return {
		"max_days": max_days,
		"current_slot": current_slot,
		"current_action": current_action.duplicate(true),
		"fixed_schedules": fixed_schedules.duplicate(true),
		"free_schedules": free_schedules.duplicate(true),
		"resources": resources.duplicate(true),
		"characters": characters.duplicate(true),
		"facilities": facilities.duplicate(true),
		"flags": flags.duplicate(true)
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
