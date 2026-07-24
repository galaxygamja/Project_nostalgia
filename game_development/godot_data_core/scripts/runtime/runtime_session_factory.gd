class_name RuntimeSessionFactory
extends RefCounted


## Canonical repository documents are translated into mutable runtime state here.
## This boundary deliberately refuses invalid bootstrap output; it does not repair data.
func create_session(repository: GameDataRepository) -> Dictionary:
	var config := _singleton_document(repository, "game_config")
	var initial_document := _singleton_document(repository, "initial_game_state")
	var timetable := _singleton_document(repository, "timetable")
	if config.is_empty() or initial_document.is_empty() or timetable.is_empty():
		return {"ok": false, "reason": "required runtime documents are missing"}

	var game: Dictionary = config.get("game", {})
	var initial_state: Dictionary = initial_document.get("initial_state", {})
	if game.is_empty() or initial_state.is_empty():
		return {"ok": false, "reason": "runtime documents have no usable game or initial_state data"}

	var slots_per_day := int(game.get("slots_per_day", 0))
	var minutes_per_slot := int(game.get("minutes_per_slot", 0))
	var max_days := int(game.get("max_days", 0))
	if slots_per_day < 1 or minutes_per_slot < 1 or max_days < 1:
		return {"ok": false, "reason": "game time configuration is invalid"}

	var runtime_initial := _build_initial_state(repository, initial_state, slots_per_day)
	if not runtime_initial.get("ok", false):
		return runtime_initial

	var prototype: Dictionary = config.get("prototype", {})
	var duration_days := int(prototype.get("duration_days", 0))
	var prototype_end_slot := duration_days * slots_per_day if duration_days > 0 else -1
	runtime_initial.initial_data["scheduled_events"] = _build_scheduled_events(timetable, slots_per_day)
	var loop := GameLoopV1.new()
	var initialized := loop.initialize(
		runtime_initial.initial_data,
		{"max_days": max_days, "slots_per_day": slots_per_day, "minutes_per_slot": minutes_per_slot, "prototype_end_slot": prototype_end_slot},
		repository,
		_build_resource_definitions(repository),
		_build_fixed_schedules(repository, timetable, runtime_initial.initial_data.current_slot, max_days, slots_per_day)
	)
	if not initialized.get("ok", false):
		return initialized
	return {"ok": true, "loop": loop, "initialization": initialized}


func _singleton_document(repository: GameDataRepository, data_type: String) -> Dictionary:
	var documents := repository.get_documents(data_type)
	if documents.size() != 1:
		return {}
	return documents[0].get("data", {})


func _build_initial_state(repository: GameDataRepository, source: Dictionary, slots_per_day: int) -> Dictionary:
	var time: Dictionary = source.get("current_time", {})
	var commander_id := str(source.get("commander_id", ""))
	if commander_id.is_empty() or not repository.has_data(commander_id):
		return {"ok": false, "reason": "commander definition is unavailable"}
	var runtime_characters: Dictionary = {}
	var character_ids: Array = source.get("active_character_ids", []).duplicate()
	if commander_id not in character_ids:
		character_ids.append(commander_id)
	for id_variant in character_ids:
		var character_id := str(id_variant)
		var definition := repository.get_data(character_id)
		if definition.is_empty():
			return {"ok": false, "reason": "active character definition is unavailable: %s" % character_id}
		var state: Dictionary = definition.get("default_state", {}).duplicate(true)
		var override: Dictionary = source.get("character_overrides", {}).get(character_id, {})
		for key in override:
			state[key] = override[key]
		runtime_characters[character_id] = state

	var day_index := int(time.get("day_index", 0))
	var slot_index := int(time.get("slot_index", 0))
	return {
		"ok": true,
		"initial_data": {
			"current_slot": day_index * slots_per_day + slot_index,
			"commander_id": commander_id,
			"resources": source.get("resource_values", {}).duplicate(true),
			"characters": runtime_characters,
			"facilities": source.get("facility_states", {}).duplicate(true),
			"flags": source.get("flags", {}).duplicate(true),
			"clue_ids": source.get("clue_ids", []).duplicate(true),
			"deduction_ids": source.get("deduction_ids", []).duplicate(true),
			"initial_task_ids": source.get("initial_task_ids", []).duplicate(true)
		}
	}


func _build_resource_definitions(repository: GameDataRepository) -> Dictionary:
	var definitions: Dictionary = {}
	for resource in repository.get_all_by_type("resource"):
		definitions[str(resource.get("id", ""))] = resource.duplicate(true)
	return definitions


func _build_fixed_schedules(
	repository: GameDataRepository,
	timetable: Dictionary,
	current_slot: int,
	max_days: int,
	slots_per_day: int
) -> Array[Dictionary]:
	var schedules_by_id: Dictionary = {}
	for schedule in repository.get_all_by_type("fixed_schedule"):
		schedules_by_id[str(schedule.get("id", ""))] = schedule
	var result: Array[Dictionary] = []
	for recurrence_variant in timetable.get("repeating_schedules", []):
		if not recurrence_variant is Dictionary:
			continue
		var recurrence: Dictionary = recurrence_variant
		var definition: Dictionary = schedules_by_id.get(str(recurrence.get("schedule_id", "")), {})
		if definition.is_empty():
			continue
		var start_day := maxi(0, int(recurrence.get("start_day_index", 0)))
		var end_day := mini(max_days - 1, int(recurrence.get("end_day_index", -1)))
		var interval := maxi(1, int(recurrence.get("interval_days", 1)))
		var slot_index := int(recurrence.get("slot_index", 0))
		for day_index in range(start_day, end_day + 1, interval):
			var start_slot := day_index * slots_per_day + slot_index
			if start_slot < current_slot:
				continue
			result.append({
				"id": "%s@%d" % [definition.id, day_index],
				"source_schedule_id": definition.id,
				"start_slot": start_slot,
				"end_slot": start_slot + int(definition.get("duration_slots", 0)),
				"fixed": true,
				"encounter_id": definition.get("encounter_id", ""),
				"delegate_allowed": definition.get("delegate_allowed", false)
			})
	return result


func _build_scheduled_events(timetable: Dictionary, slots_per_day: int) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for day_variant in timetable.get("days", []):
		if not day_variant is Dictionary:
			continue
		var day: Dictionary = day_variant
		for slot_key in day.get("slots", {}):
			var slot_data: Dictionary = day.slots[slot_key]
			for encounter_id in slot_data.get("scheduled_encounter_ids", []):
				result.append({"id": "story:%s@%s" % [encounter_id, slot_key], "encounter_id": encounter_id, "start_slot": int(day.get("day_index", 0)) * slots_per_day + int(slot_key), "completed": false})
	return result
