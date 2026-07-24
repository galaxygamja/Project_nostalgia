class_name ResourceTickProcessorV1
extends RefCounted


func process_slot(state: GameState, resource_definitions: Dictionary) -> Array[Dictionary]:
	var changes: Array[Dictionary] = []
	for resource_id_variant in state.resources.keys():
		var resource_id := str(resource_id_variant)
		var definition: Dictionary = resource_definitions.get(resource_id, {})
		if definition.is_empty():
			continue
		var previous := float(state.resources[resource_id_variant])
		var delta := float(definition.get("production_per_slot", 0.0)) - float(definition.get("consumption_per_slot", 0.0))
		var current := clampf(previous + delta, float(definition.get("minimum", -INF)), float(definition.get("maximum", INF)))
		state.resources[resource_id_variant] = current
		changes.append({"resource_id": resource_id, "previous": previous, "delta": current - previous, "current": current})
	return changes
