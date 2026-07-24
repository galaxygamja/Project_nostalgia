class_name FormulaEvaluator
extends RefCounted


func evaluate(formula: Dictionary, variables: Dictionary) -> Dictionary:
	var result := _evaluate_node(formula.get("expression"), variables)
	if not result.get("ok", false):
		return {"ok": false, "reason": result.get("reason", "formula failed"), "value": formula.get("fallback_value", 0.0)}
	var value: Variant = result.value
	var clamp_data: Dictionary = formula.get("clamp", {})
	if value is int or value is float:
		value = clampf(float(value), float(clamp_data.get("minimum", -INF)), float(clamp_data.get("maximum", INF)))
	if str(formula.get("result_type", "")) == "int":
		value = int(value)
	return {"ok": true, "value": value}


func _evaluate_node(node: Variant, variables: Dictionary) -> Dictionary:
	if not node is Dictionary:
		return {"ok": false, "reason": "formula node must be a dictionary"}
	if node.has("constant"):
		return {"ok": true, "value": node.constant}
	if node.has("variable"):
		var key := str(node.variable)
		return {"ok": variables.has(key), "value": variables.get(key), "reason": "missing formula variable: %s" % key}
	var operator := str(node.get("operator", ""))
	var values: Variant = node.get("values", [])
	if not values is Array:
		return {"ok": false, "reason": "formula values must be an array"}
	var resolved: Array = []
	for child in values:
		var child_result := _evaluate_node(child, variables)
		if not child_result.get("ok", false):
			return child_result
		resolved.append(child_result.value)
	match operator:
		"add": return {"ok": true, "value": resolved.reduce(func(a, b): return float(a) + float(b), 0.0)}
		"subtract": return {"ok": true, "value": float(resolved[0]) - float(resolved[1])}
		"multiply": return {"ok": true, "value": resolved.reduce(func(a, b): return float(a) * float(b), 1.0)}
		"divide": return {"ok": false, "reason": "division by zero"} if float(resolved[1]) == 0.0 else {"ok": true, "value": float(resolved[0]) / float(resolved[1])}
		"ceil": return {"ok": true, "value": ceili(float(resolved[0]))}
		"floor": return {"ok": true, "value": floori(float(resolved[0]))}
		"minimum": return {"ok": true, "value": resolved.min()}
		"maximum": return {"ok": true, "value": resolved.max()}
	return {"ok": false, "reason": "unsupported formula operator: %s" % operator}
