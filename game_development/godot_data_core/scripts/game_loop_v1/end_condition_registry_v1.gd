class_name EndConditionRegistryV1
extends RefCounted

var _conditions: Array[Callable] = []


func register_condition(condition: Callable) -> void:
	if condition.is_valid():
		_conditions.append(condition)


func clear() -> void:
	_conditions.clear()


func evaluate(state: GameState) -> Dictionary:
	for condition in _conditions:
		var result: Variant = condition.call(state)
		if result is Dictionary and bool(result.get("ended", false)):
			return result.duplicate(true)
	return {"ended": false}
