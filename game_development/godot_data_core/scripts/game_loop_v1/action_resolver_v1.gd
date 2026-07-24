class_name ActionResolverV1
extends RefCounted


func evaluate(requirements: Dictionary, state: GameState, context: Dictionary = {}) -> Dictionary:
	var reasons: Array[String] = []
	var minimum_values: Variant = requirements.get("minimum_values", {})
	if not minimum_values is Dictionary:
		return {"available": false, "reasons": ["minimum_values must be a dictionary"]}
	for target_variant in minimum_values:
		var target := str(target_variant)
		var read_result := read_target(target, state, context)
		if not read_result.get("ok", false):
			reasons.append(str(read_result.get("reason", "invalid requirement")))
		elif float(read_result.get("value", 0.0)) < float(minimum_values[target_variant]):
			reasons.append("minimum value not met: %s" % target)
	return {"available": reasons.is_empty(), "reasons": reasons}


func apply_effects(effects: Array, state: GameState, context: Dictionary = {}) -> Dictionary:
	var applied: Array[Dictionary] = []
	for effect_variant in effects:
		if not effect_variant is Dictionary:
			return {"ok": false, "reason": "effect must be a dictionary", "applied": applied}
		var effect: Dictionary = effect_variant
		var target := str(effect.get("target", ""))
		var operation := str(effect.get("operation", ""))
		if target.begins_with("clue:") and operation == "add":
			state.add_clue(target.trim_prefix("clue:"))
			applied.append({"target": target, "operation": operation})
			continue
		var read_result := read_target(target, state, context)
		if not read_result.get("ok", false):
			return {"ok": false, "reason": read_result.get("reason", "unsupported target"), "applied": applied}
		var previous: Variant = read_result.value
		var current: Variant
		match operation:
			"add": current = float(previous) + float(effect.get("value", 0.0))
			"set": current = effect.get("value")
			_:
				return {"ok": false, "reason": "unsupported effect operation: %s" % operation, "applied": applied}
		var write_result := write_target(target, current, state, context)
		if not write_result.get("ok", false):
			return {"ok": false, "reason": write_result.get("reason", "effect write failed"), "applied": applied}
		applied.append({"target": target, "operation": operation, "previous": previous, "current": current})
	return {"ok": true, "applied": applied}


func read_target(target: String, state: GameState, context: Dictionary = {}) -> Dictionary:
	if target.begins_with("flag."):
		var flag_key := target.trim_prefix("flag.")
		return {"ok": state.flags.has(flag_key), "value": state.flags.get(flag_key), "reason": "unknown flag: %s" % flag_key}
	if target.begins_with("facility:"):
		var facility_parts := target.trim_prefix("facility:").split(".", false, 1)
		if facility_parts.size() != 2 or not state.facilities.has(facility_parts[0]):
			return {"ok": false, "reason": "unknown facility target: %s" % target}
		var facility: Dictionary = state.facilities[facility_parts[0]]
		return {"ok": facility.has(facility_parts[1]), "value": facility.get(facility_parts[1]), "reason": "unknown facility field"}
	var character_result := _character_target(target, state, context)
	if not character_result.is_empty():
		return character_result
	return {"ok": false, "reason": "unsupported runtime target: %s" % target}


func write_target(target: String, value: Variant, state: GameState, context: Dictionary = {}) -> Dictionary:
	if target.begins_with("flag."):
		state.flags[target.trim_prefix("flag.")] = value
		return {"ok": true}
	if target.begins_with("facility:"):
		var facility_parts := target.trim_prefix("facility:").split(".", false, 1)
		if facility_parts.size() != 2 or not state.facilities.has(facility_parts[0]):
			return {"ok": false, "reason": "unknown facility target: %s" % target}
		var facility: Dictionary = state.facilities[facility_parts[0]]
		facility[facility_parts[1]] = value
		state.facilities[facility_parts[0]] = facility
		return {"ok": true}
	var character_id := _character_id_for_target(target, state, context)
	if character_id.is_empty():
		return {"ok": false, "reason": "unsupported runtime target: %s" % target}
	var field := target.split(".", false, 1)[1]
	var character: Dictionary = state.characters[character_id]
	character[field] = value
	state.characters[character_id] = character
	return {"ok": true}


func _character_target(target: String, state: GameState, context: Dictionary) -> Dictionary:
	var character_id := _character_id_for_target(target, state, context)
	if character_id.is_empty():
		return {}
	var field := target.split(".", false, 1)[1]
	var character: Dictionary = state.characters.get(character_id, {})
	if not character.has(field):
		return {"ok": false, "reason": "unknown character state field: %s" % field}
	return {"ok": true, "value": character[field]}


func _character_id_for_target(target: String, state: GameState, context: Dictionary) -> String:
	if target.begins_with("commander."):
		return state.commander_id
	if target.begins_with("assignee."):
		return str(context.get("assignee_id", state.commander_id))
	return ""
