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
	assert(loop.phase == GameLoopV1.Phase.RESOLVING_ENCOUNTER)
	assert(loop.pending_encounter.get("encounter", {}).get("id", "") == "IFBD_001")
	assert(loop.resolve_encounter().ok)
	assert(loop.phase == GameLoopV1.Phase.AWAITING_ACTION)
	assert(not loop.select_action("AXXX_002").ok)
	var fatigue_before := float(loop.game_state.characters["CMAB_001"].get("fatigue", 0.0))
	var result := loop.select_action("AXXX_001", "CMAB_001")
	assert(result.ok)
	assert(loop.game_state.current_slot == 14)
	assert(loop.phase == GameLoopV1.Phase.RESOLVING_ENCOUNTER)
	assert(loop.pending_encounter.get("encounter", {}).get("id", "") == "IRBC_001")
	assert(loop.resolve_encounter().ok)
	assert(loop.phase == GameLoopV1.Phase.RESOLVING_ENCOUNTER)
	assert(loop.pending_encounter.get("encounter", {}).get("id", "") == "ISBO_001")
	assert(loop.resolve_encounter().ok)
	assert(float(loop.game_state.characters["CMAB_001"].get("fatigue", 0.0)) > fatigue_before)
	assert(loop.logs.size() >= 4)
	assert(loop.action_resolver.apply_effects([{"target": "flag.water_records_cross_checked", "operation": "set", "value": true}], loop.game_state).ok)
	assert(bool(loop.game_state.flags.get("water_records_cross_checked", false)))
	bootstrap.free()
	print("game_loop_v1_test: PASS")
	quit()
