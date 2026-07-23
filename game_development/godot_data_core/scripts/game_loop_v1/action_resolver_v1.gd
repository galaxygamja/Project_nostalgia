class_name ActionResolverV1
extends RefCounted


func evaluate(action: Dictionary, state: GameState) -> Dictionary:
	var reasons: Array[String] = []
	for requirement_variant in action.get("requirements", []):
		if requirement_variant is Dictionary:
			var failure := _evaluate_requirement(requirement_variant, state)
			if not failure.is_empty():
				reasons.append(failure)
	return {"available": reasons.is_empty(), "reasons": reasons}


func apply_effects(effects: Array, state: GameState) -> Array[Dictionary]:
	var applied: Array[Dictionary] = []
	for effect_variant in effects:
		if not effect_variant is Dictionary:
			continue
		var effect: Dictionary = effect_variant
		var effect_type := str(effect.get("type", ""))
		match effect_type:
			"resource_delta":
				var id := str(effect.get("resource_id", ""))
				var previous := float(state.resources.get(id, 0.0))
				var current := previous + float(effect.get("amount", 0.0))
				state.resources[id] = current
				applied.append({"type": effect_type, "id": id, "previous": previous, "current": current})
			"flag_set":
				var id := str(effect.get("flag_id", ""))
				var value: Variant = effect.get("value", true)
				state.flags[id] = value
				applied.append({"type": effect_type, "id": id, "value": value})
			_:
				applied.append({"type": effect_type, "skipped": true})
	return applied


func _evaluate_requirement(requirement: Dictionary, state: GameState) -> String:
	var requirement_type := str(requirement.get("type", ""))
	match requirement_type:
		"resource_min":
			var id := str(requirement.get("resource_id", ""))
			if float(state.resources.get(id, 0.0)) < float(requirement.get("value", 0.0)):
				return "resource minimum not met: %s" % id
		"flag_equals":
			var id := str(requirement.get("flag_id", ""))
			if state.flags.get(id) != requirement.get("value"):
				return "flag requirement not met: %s" % id
	return ""
