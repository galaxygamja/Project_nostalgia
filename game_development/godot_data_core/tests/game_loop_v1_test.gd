extends SceneTree

const GameLoopScript = preload("res://scripts/game_loop_v1/game_loop_v1.gd")


func _initialize() -> void:
	var loop = GameLoopScript.new()
	var initial := {
		"resources": {"power": 10.0},
		"resource_rates": {"power": {"per_slot": -1.0, "minimum": 0.0}},
		"fixed_schedules": []
	}
	var actions: Array[Dictionary] = [{
		"id": "inspect",
		"duration_slots": 2,
		"requirements": [{"type": "resource_min", "resource_id": "power", "value": 2.0}],
		"effects": [{"type": "flag_set", "flag_id": "inspected", "value": true}]
	}]
	var initialized := loop.initialize(initial, actions, 100)
	assert(initialized.ok)
	assert(loop.get_available_actions().size() == 1)
	var result := loop.select_action("inspect")
	assert(result.ok)
	assert(loop.phase == GameLoopScript.Phase.AWAITING_ACTION)
	assert(loop.game_state.current_slot == 2)
	assert(loop.game_state.resources.power == 8.0)
	assert(loop.game_state.flags.inspected == true)
	assert(loop.logs.size() == 4)
	print("game_loop_v1_test: PASS")
	quit()
