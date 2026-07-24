extends SceneTree

const BootstrapScript = preload("res://scripts/data/data_bootstrap.gd")
const FactoryScript = preload("res://scripts/runtime/runtime_session_factory.gd")


func _initialize() -> void:
	var bootstrap := BootstrapScript.new()
	bootstrap.data_root = "res://data"
	assert(bootstrap.bootstrap().ok)
	var session := FactoryScript.new().create_session(bootstrap.repository)
	assert(session.ok)
	var loop: GameLoopV1 = session.loop
	assert(loop.pending_encounter.get("encounter", {}).get("id", "") == "IFBD_001")
	assert(loop.resolve_encounter().ok)

	# The management action reaches the day-one report and contributes the first clue.
	assert(loop.select_action("AXXX_001", "CMAB_001").ok)
	assert(loop.phase == GameLoopV1.Phase.RESOLVING_ENCOUNTER)
	assert(loop.pending_encounter.get("encounter", {}).get("id", "") == "IRBC_001")
	assert(loop.resolve_encounter().ok)
	assert(loop.phase == GameLoopV1.Phase.RESOLVING_ENCOUNTER)
	assert(loop.pending_encounter.get("encounter", {}).get("id", "") == "ISBO_001")
	assert("LXXX_001" in loop.game_state.clue_ids)
	assert(loop.resolve_encounter().ok)

	# Arrange the second evidence item through the deterministic day-two scheduled encounter.
	loop.game_state.current_slot = 76
	assert(loop.refresh_situation().ok)
	assert(loop.pending_encounter.get("encounter", {}).get("id", "") == "ISBO_002")
	assert("LXXX_002" in loop.game_state.clue_ids)
	assert(loop.resolve_encounter().ok)
	assert(loop.start_deduction("DXXX_001").ok)
	while loop.phase == GameLoopV1.Phase.RESOLVING_ENCOUNTER:
		assert(loop.resolve_encounter().ok)
	assert("DXXX_001" in loop.game_state.deduction_ids)
	assert("TCUO_001" in loop.game_state.unlocked_task_ids)

	var condition_before := float(loop.game_state.facilities["FXXX_002"].get("condition", 0.0))
	assert(loop.select_task("TCUO_001", "CMEB_001").ok)
	while loop.phase == GameLoopV1.Phase.RESOLVING_ENCOUNTER:
		assert(loop.resolve_encounter().ok)
	assert(float(loop.game_state.facilities["FXXX_002"].get("condition", 0.0)) > condition_before)

	loop.game_state.current_slot = loop.game_state.prototype_end_slot - 1
	assert(loop.select_action("AXXX_002", loop.game_state.commander_id, 1).ok)
	assert(loop.phase == GameLoopV1.Phase.GAME_OVER)
	bootstrap.free()
	print("prototype_vertical_slice_test: PASS")
	quit()
