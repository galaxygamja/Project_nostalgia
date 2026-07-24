extends SceneTree

const RepositoryScript = preload("res://scripts/data/data_repository.gd")
const FactoryScript = preload("res://scripts/runtime/runtime_session_factory.gd")


func _initialize() -> void:
	var repository := RepositoryScript.new()
	_register(repository, {"schema_version": 1, "data_type": "game_config", "game": {"max_days": 1000, "slots_per_day": 48, "minutes_per_slot": 30}})
	_register(repository, {"schema_version": 1, "data_type": "initial_game_state", "initial_state": {
		"current_time": {"day_index": 0, "slot_index": 12}, "commander_id": "CMCB_001", "active_character_ids": ["CMCB_001"],
		"resource_values": {"RXXX_004": 2.0}, "facility_states": {}, "character_overrides": {}, "flags": {}}})
	_register(repository, {"schema_version": 1, "data_type": "timetable", "repeating_schedules": [{"schedule_id": "SXXX_001", "start_day_index": 0, "end_day_index": 0, "slot_index": 15, "interval_days": 1}]})
	_register(repository, {"schema_version": 1, "data_type": "character", "entries": [{"id": "CMCB_001", "default_state": {"alive": true, "available": true, "health": 20.0, "fatigue": 10.0}}]})
	_register(repository, {"schema_version": 1, "data_type": "resource", "entries": [{"id": "RXXX_004", "production_per_slot": 1.0, "consumption_per_slot": 0.8, "minimum": 0.0, "maximum": 100.0}]})
	_register(repository, {"schema_version": 1, "data_type": "action", "entries": [{"id": "AXXX_001", "duration_slots": 2, "duration_range": null, "requirements": {"minimum_values": {"commander.health": 10.0}}, "effects_per_slot": [], "completion_effects": []}]})
	_register(repository, {"schema_version": 1, "data_type": "fixed_schedule", "entries": [{"id": "SXXX_001", "duration_slots": 1}]})

	var result := FactoryScript.new().create_session(repository)
	assert(result.ok)
	assert(result.loop.game_state.current_slot == 12)
	assert(result.loop.game_state.fixed_schedules.size() == 1)
	var action_result: Dictionary = result.loop.select_action("AXXX_001")
	assert(action_result.ok)
	assert(result.loop.game_state.current_slot == 14)
	print("runtime_session_factory_test: PASS")
	quit()


func _register(repository: GameDataRepository, document: Dictionary) -> void:
	assert(repository.register_document(document, "fixture://%s.json" % document.data_type))
