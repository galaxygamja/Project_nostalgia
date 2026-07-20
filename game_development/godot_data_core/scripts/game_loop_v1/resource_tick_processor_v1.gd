class_name ResourceTickProcessorV1
extends RefCounted


func process_slot(state: GameState, rates: Dictionary) -> Array[Dictionary]:
	var changes: Array[Dictionary] = []
	for resource_id_variant in rates.keys():
		var resource_id := str(resource_id_variant)
		var rate: Variant = rates[resource_id_variant]
		var delta := float(rate.get("per_slot", 0.0)) if rate is Dictionary else float(rate)
		var previous := float(state.resources.get(resource_id, 0.0))
		var current := previous + delta
		if rate is Dictionary:
			if rate.has("minimum"):
				current = maxf(current, float(rate["minimum"]))
			if rate.has("maximum"):
				current = minf(current, float(rate["maximum"]))
		state.resources[resource_id] = current
		changes.append({"resource_id": resource_id, "previous": previous, "delta": current - previous, "current": current})
	return changes
