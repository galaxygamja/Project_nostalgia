extends SceneTree

const BootstrapScript = preload("res://scripts/data/data_bootstrap.gd")


func _initialize() -> void:
	var bootstrap := BootstrapScript.new()
	bootstrap.data_root = "res://data"
	var result := bootstrap.bootstrap()
	assert(result.ok)
	assert(result.stage == "validation")
	assert(result.load.file_count == 20)
	assert(bootstrap.repository.get_definition_count() == 43)
	assert(result.validation.error_count == 0)
	assert(result.validation.warning_count == 0)
	bootstrap.free()
	print("data_bootstrap_smoke_test: PASS")
	quit()
