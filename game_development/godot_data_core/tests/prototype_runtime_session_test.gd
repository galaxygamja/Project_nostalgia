extends SceneTree

const BootstrapScript = preload("res://scripts/data/data_bootstrap.gd")
const FactoryScript = preload("res://scripts/runtime/runtime_session_factory.gd")


func _initialize() -> void:
	var bootstrap := BootstrapScript.new()
	bootstrap.data_root = "res://data"
	var boot_result := bootstrap.bootstrap()
	assert(boot_result.ok)
	var session_result := FactoryScript.new().create_session(bootstrap.repository)
	assert(session_result.ok)
	var state: GameState = session_result.loop.game_state
	assert(state.current_slot == 12)
	assert(state.characters.size() == 5)
	assert(state.resources.keys().size() == 4)
	assert(state.resources.has("RXXX_002"))
	assert(state.resources.has("RXXX_003"))
	assert(state.resources.has("RXXX_004"))
	assert(state.resources.has("RXXX_005"))
	bootstrap.free()
	print("prototype_runtime_session_test: PASS")
	quit()
