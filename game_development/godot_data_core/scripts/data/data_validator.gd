class_name GameDataValidator
extends RefCounted

## entries 기반 데이터 종류별 필수 필드다.
const REQUIRED_ENTRY_FIELDS := {
	"resource": ["id", "name", "unit", "value_type", "minimum", "maximum", "default_value", "production_per_slot", "consumption_per_slot", "critical_threshold", "display_as_percentage"],
	"facility": ["id", "name", "facility_type", "default_state", "produces", "consumes", "related_task_ids", "tags"],
	"character": ["id", "name", "role", "specialty", "default_state", "skills", "trait_ids", "starting_task_ids"],
	"character_trait": ["id", "name", "description", "requirements", "modifiers", "granted_encounter_ids"],
	"status_effect": ["id", "name", "description", "duration_slots", "stack_policy", "maximum_stacks", "effects_on_apply", "effects_per_slot", "effects_on_remove"],
	"action": ["id", "name", "category", "duration_slots", "duration_range", "encounter_pool_ids", "requirements", "effects_per_slot", "completion_effects", "interruptible_by_emergency"],
	"fixed_schedule": ["id", "name", "duration_slots", "delegate_allowed", "required_skill", "encounter_id", "default_delegate_id", "requirements", "absence_effects"],
	"task": ["id", "name", "category", "description", "target_id", "required_skill", "difficulty", "base_duration_slots", "priority", "delegate_allowed", "commander_can_perform", "deadline_slots", "requirements", "success_formula_id", "duration_formula_id", "outcome_table"],
	"formula": ["id", "name", "result_type", "expression"],
	"encounter": ["id", "name", "category", "importance", "repeat_policy", "requirements", "pages", "choices", "automatic_effects"],
	"encounter_pool": ["id", "name", "category", "draw_mode", "reset_policy", "encounters"],
	"item": ["id", "name", "category", "stackable", "maximum_stack", "consumable", "requirements", "passive_effects", "use_effects", "unlock_flags"],
	"location": ["id", "name", "category", "description", "connected_location_ids", "requirements", "encounter_pool_ids", "tags"],
	"flag_definition": ["id", "key", "name", "description", "value_type", "default_value"],
	"clue": ["id", "name", "description", "source_encounter_ids", "tags"],
	"deduction": ["id", "name", "required_clue_ids", "excluded_flags", "time_cost_slots", "success_formula_id", "success_effects", "unlocked_task_ids", "unlocked_encounter_ids"]
}

## 단일 ID 참조 필드와 기대 data_type이다. 빈 문자열은 아무 정의 종류나 허용한다.
const SINGLE_REFERENCE_FIELDS := {
	"target_id": "",
	"success_formula_id": "formula",
	"duration_formula_id": "formula",
	"condition_formula_id": "formula",
	"value_formula_id": "formula",
	"encounter_id": "encounter",
	"next_encounter_id": "encounter",
	"default_delegate_id": "character",
	"speaker_id": "character",
	"location_id": "location",
	"resource_id": "resource",
	"schedule_id": "fixed_schedule",
	"commander_id": "character"
}

## ID 배열 참조 필드와 기대 data_type이다.
const ARRAY_REFERENCE_FIELDS := {
	"active_character_ids": "character",
	"initial_task_ids": "task",
	"active_pool_ids": "encounter_pool",
	"clue_ids": "clue",
	"deduction_ids": "deduction",
	"fixed_schedule_ids": "fixed_schedule",
	"scheduled_encounter_ids": "encounter",
	"related_task_ids": "task",
	"trait_ids": "character_trait",
	"starting_task_ids": "task",
	"encounter_pool_ids": "encounter_pool",
	"granted_encounter_ids": "encounter",
	"add_encounter_ids": "encounter",
	"source_encounter_ids": "encounter",
	"required_clue_ids": "clue",
	"unlocked_task_ids": "task",
	"unlocked_encounter_ids": "encounter",
	"required_item_ids": "item",
	"required_character_ids": "character",
	"required_facility_ids": "facility",
	"connected_location_ids": "location"
}

const ALLOWED_FORMULA_OPERATORS := [
	"add", "subtract", "multiply", "divide", "minimum", "maximum", "clamp",
	"floor", "ceil", "round", "equal", "not_equal", "greater",
	"greater_or_equal", "less", "less_or_equal", "and", "or", "not"
]

const ALLOWED_DRAW_MODES := [
	"weighted_with_replacement", "weighted_without_replacement", "sequential", "shuffle_bag"
]

const ALLOWED_RESET_POLICIES := ["never", "daily", "when_empty", "on_action_start", "manual"]

const ALLOWED_REPEAT_TYPES := ["one_time", "repeatable", "daily_once", "cooldown", "until_result"]

## 치명적 데이터 오류 목록이다.
var errors: Array[Dictionary] = []

## 실행은 가능하지만 개발자가 확인해야 하는 경고 목록이다.
var warnings: Array[Dictionary] = []

var _repository: GameDataRepository
var _id_rules: Dictionary = {}
var _id_regex := RegEx.new()


## 저장소 전체를 검사한다.
## 구조, ID, 시간, 수치, 계산식, 참조 관계를 검사한 요약 Dictionary를 반환한다.
func validate_repository(repository: GameDataRepository) -> Dictionary:
	errors.clear()
	warnings.clear()
	_repository = repository
	_load_id_rules()

	_validate_required_documents()
	_validate_all_documents()
	_validate_all_entries()
	_validate_all_references()

	return {
		"ok": errors.is_empty(),
		"errors": errors.duplicate(true),
		"warnings": warnings.duplicate(true),
		"error_count": errors.size(),
		"warning_count": warnings.size()
	}


## 오류와 경고를 Godot 출력창에 사람이 읽기 쉬운 형식으로 표시한다.
func print_report() -> void:
	for error in errors:
		push_error(_format_issue(error))
	for warning in warnings:
		push_warning(_format_issue(warning))
	print("[DataValidator] 오류 %d개, 경고 %d개" % [errors.size(), warnings.size()])


## ID 규칙 문서를 읽고 정규식을 준비한다.
func _load_id_rules() -> void:
	var records := _repository.get_documents("id_code_rules", false)
	if records.is_empty():
		_add_error("", "", "id_code_rules", "id_code_rules 문서가 없습니다.")
		return

	_id_rules = records[0].get("data", {})
	var pattern: String = _id_rules.get("id_pattern", "^[A-Z]{4}_[0-9]{3}$")
	var compile_result := _id_regex.compile(pattern)
	if compile_result != OK:
		_add_error(records[0].get("path", ""), "", "id_pattern", "ID 정규식을 컴파일할 수 없습니다.")


## 시스템 시작에 필수인 단일 문서가 존재하는지 확인한다.
func _validate_required_documents() -> void:
	for required_type in ["game_config", "id_code_rules", "initial_game_state", "timetable"]:
		if not _repository.has_document_type(required_type):
			_add_error("", "", required_type, "필수 문서가 없습니다.")


## 모든 문서의 schema_version과 data_type 기본 구조를 검사한다.
func _validate_all_documents() -> void:
	for data_type in _repository.get_registered_types():
		for record in _repository.get_documents(data_type, false):
			var path: String = record.get("path", "")
			var document: Dictionary = record.get("data", {})
			if not document.has("schema_version") or not _is_number(document["schema_version"]):
				_add_error(path, "", "schema_version", "schema_version 숫자가 필요합니다.")
			elif int(document["schema_version"]) != 1:
				_add_warning(path, "", "schema_version", "현재 검사기는 schema_version 1을 기준으로 합니다.")

			if document.get("data_type", "") != data_type:
				_add_error(path, "", "data_type", "저장소 분류와 문서 data_type이 일치하지 않습니다.")

			_validate_singleton_document(data_type, document, path)


## game_config, initial_game_state, timetable의 전용 필드를 검사한다.
func _validate_singleton_document(data_type: String, document: Dictionary, path: String) -> void:
	match data_type:
		"game_config":
			_require_fields(document, ["game", "paths"], path, "")
			if document.has("game") and typeof(document["game"]) == TYPE_DICTIONARY:
				var game: Dictionary = document["game"]
				_require_fields(game, ["max_days", "slots_per_day", "minutes_per_slot", "start_day_index", "start_slot_index", "id_pattern"], path, "game")
				if int(game.get("max_days", -1)) != 1000:
					_add_error(path, "", "game.max_days", "max_days는 1000이어야 합니다.")
				if int(game.get("slots_per_day", -1)) != 48:
					_add_error(path, "", "game.slots_per_day", "slots_per_day는 48이어야 합니다.")
				if int(game.get("minutes_per_slot", -1)) != 30:
					_add_error(path, "", "game.minutes_per_slot", "minutes_per_slot은 30이어야 합니다.")
				_validate_time_position(game, path, "game.start", "start_day_index", "start_slot_index")
		"initial_game_state":
			_require_fields(document, ["initial_state"], path, "")
			if document.has("initial_state") and typeof(document["initial_state"]) == TYPE_DICTIONARY:
				var state: Dictionary = document["initial_state"]
				_require_fields(state, ["current_time", "commander_id", "active_character_ids", "resource_values", "facility_states", "character_overrides", "initial_task_ids", "active_pool_ids", "inventory", "clue_ids", "deduction_ids", "flags"], path, "initial_state")
				if state.has("current_time") and typeof(state["current_time"]) == TYPE_DICTIONARY:
					_validate_time_position(state["current_time"], path, "initial_state.current_time")
				_validate_id_keyed_map(state.get("resource_values"), "resource", path, "initial_state.resource_values")
				_validate_id_keyed_map(state.get("facility_states"), "facility", path, "initial_state.facility_states")
				_validate_id_keyed_map(state.get("character_overrides"), "character", path, "initial_state.character_overrides")
				_validate_id_keyed_map(state.get("inventory"), "item", path, "initial_state.inventory")
		"timetable":
			_require_fields(document, ["max_days", "slots_per_day", "days", "repeating_schedules"], path, "")
			if int(document.get("max_days", -1)) != 1000:
				_add_error(path, "", "max_days", "시간표 max_days는 1000이어야 합니다.")
			if int(document.get("slots_per_day", -1)) != 48:
				_add_error(path, "", "slots_per_day", "시간표 slots_per_day는 48이어야 합니다.")
			_validate_timetable(document, path)


## entries 기반 모든 정의의 필수 필드와 종류별 규칙을 검사한다.
func _validate_all_entries() -> void:
	for data_type in _repository.get_registered_types():
		for entry in _repository.get_all_by_type(data_type, false):
			var id: String = entry.get("id", "")
			var path := _repository.get_source_path(id)
			_validate_id(id, data_type, path)

			if REQUIRED_ENTRY_FIELDS.has(data_type):
				_require_fields(entry, REQUIRED_ENTRY_FIELDS[data_type], path, id)
			else:
				_add_warning(path, id, "data_type", "등록된 필수 필드 규칙이 없는 data_type입니다: %s" % data_type)

			match data_type:
				"resource": _validate_resource(entry, path)
				"action": _validate_action(entry, path)
				"fixed_schedule": _require_positive_int(entry, "duration_slots", path, id)
				"task": _validate_task(entry, path)
				"formula": _validate_formula(entry, path)
				"encounter": _validate_encounter(entry, path)
				"encounter_pool": _validate_pool(entry, path)
				"item": _validate_item(entry, path)
				"status_effect": _require_positive_int(entry, "duration_slots", path, id)
				"deduction": _require_positive_int(entry, "time_cost_slots", path, id)


## ABCD_001 정규식과 id_code_rules의 위치별 문자표를 검사한다.
func _validate_id(id: String, data_type: String, path: String) -> void:
	if id.is_empty() or _id_regex.search(id) == null:
		_add_error(path, id, "id", "ID가 ABCD_001 형식과 일치하지 않습니다.")
		return

	if id.ends_with("_000"):
		_add_error(path, id, "id", "000은 예약 번호이므로 일반 데이터에 사용할 수 없습니다.")

	var code_tables: Dictionary = _id_rules.get("data_types", {})
	var prefix := id.substr(0, 1)
	if not code_tables.has(prefix):
		_add_error(path, id, "id", "첫 번째 분류 문자 %s가 ID 규칙에 없습니다." % prefix)
		return

	var type_rule: Dictionary = code_tables[prefix]
	if type_rule.get("name", "") != data_type:
		_add_error(path, id, "id", "ID 첫 문자 분류 %s와 data_type %s가 일치하지 않습니다." % [type_rule.get("name", ""), data_type])

	var positions: Dictionary = type_rule.get("positions", {})
	for position in range(2, 5):
		var position_key := str(position)
		var code := id.substr(position - 1, 1)
		if not positions.has(position_key) or not positions[position_key].has(code):
			_add_error(path, id, "id", "%d번째 문자 %s가 해당 데이터 종류의 문자표에 없습니다." % [position, code])


## 자원 최솟값, 기본값, 최댓값, 임계값의 범위를 검사한다.
func _validate_resource(entry: Dictionary, path: String) -> void:
	var id: String = entry.get("id", "")
	var minimum := float(entry.get("minimum", 0.0))
	var maximum := float(entry.get("maximum", 0.0))
	var default_value := float(entry.get("default_value", 0.0))
	var threshold := float(entry.get("critical_threshold", 0.0))
	if minimum > maximum:
		_add_error(path, id, "minimum", "minimum은 maximum보다 클 수 없습니다.")
	if default_value < minimum or default_value > maximum:
		_add_error(path, id, "default_value", "default_value가 허용 범위를 벗어났습니다.")
	if threshold < minimum or threshold > maximum:
		_add_error(path, id, "critical_threshold", "critical_threshold가 허용 범위를 벗어났습니다.")


## 행동의 고정 시간 또는 선택 시간 범위를 검사한다.
func _validate_action(entry: Dictionary, path: String) -> void:
	var id: String = entry.get("id", "")
	var duration: Variant = entry.get("duration_slots")
	var duration_range: Variant = entry.get("duration_range")
	if duration == null and duration_range == null:
		_add_error(path, id, "duration_slots", "duration_slots와 duration_range 중 하나는 필요합니다.")
	elif duration != null and duration_range != null:
		_add_error(path, id, "duration_range", "duration_slots와 duration_range를 동시에 사용할 수 없습니다.")
	elif duration != null and int(duration) < 1:
		_add_error(path, id, "duration_slots", "duration_slots는 1 이상이어야 합니다.")
	elif typeof(duration_range) == TYPE_DICTIONARY:
		var minimum := int(duration_range.get("minimum_slots", 0))
		var maximum := int(duration_range.get("maximum_slots", 0))
		if minimum < 1 or maximum < minimum:
			_add_error(path, id, "duration_range", "시간 범위는 1 <= minimum_slots <= maximum_slots여야 합니다.")


## 업무 시간, 마감, 결과표 정렬을 검사한다.
func _validate_task(entry: Dictionary, path: String) -> void:
	var id: String = entry.get("id", "")
	_require_positive_int(entry, "base_duration_slots", path, id)
	_require_positive_int(entry, "deadline_slots", path, id)
	if typeof(entry.get("outcome_table")) != TYPE_ARRAY or entry["outcome_table"].is_empty():
		_add_error(path, id, "outcome_table", "outcome_table은 하나 이상의 결과가 필요합니다.")
		return

	var previous_score := INF
	for index in entry["outcome_table"].size():
		var outcome: Variant = entry["outcome_table"][index]
		if typeof(outcome) != TYPE_DICTIONARY:
			_add_error(path, id, "outcome_table[%d]" % index, "결과 항목은 Dictionary여야 합니다.")
			continue
		_require_fields(outcome, ["minimum_score", "result", "effects", "add_encounter_ids"], path, "%s.outcome_table[%d]" % [id, index])
		var score := float(outcome.get("minimum_score", 0.0))
		if score > previous_score:
			_add_error(path, id, "outcome_table", "minimum_score는 내림차순이어야 합니다.")
		previous_score = score


## 계산식 표현식 트리와 허용 연산자를 검사한다.
func _validate_formula(entry: Dictionary, path: String) -> void:
	_validate_expression_node(entry.get("expression"), path, entry.get("id", ""), "expression", 0)


## 표현식 트리를 재귀적으로 검사한다. 최대 깊이는 32다.
func _validate_expression_node(node: Variant, path: String, id: String, field: String, depth: int) -> void:
	if depth > 32:
		_add_error(path, id, field, "계산식 표현식 깊이가 32를 초과했습니다.")
		return
	if typeof(node) != TYPE_DICTIONARY:
		_add_error(path, id, field, "표현식 노드는 Dictionary여야 합니다.")
		return

	if node.has("constant") or node.has("variable"):
		return
	if not node.has("operator") or not node.has("values"):
		_add_error(path, id, field, "연산 노드에는 operator와 values가 필요합니다.")
		return

	var operator_name: String = node.get("operator", "")
	if operator_name not in ALLOWED_FORMULA_OPERATORS:
		_add_error(path, id, field + ".operator", "허용되지 않은 연산자입니다: %s" % operator_name)
	if typeof(node["values"]) != TYPE_ARRAY:
		_add_error(path, id, field + ".values", "values는 Array여야 합니다.")
		return
	for index in node["values"].size():
		_validate_expression_node(node["values"][index], path, id, "%s.values[%d]" % [field, index], depth + 1)


## 인카운터 반복 정책과 페이지 및 선택지 형식을 검사한다.
func _validate_encounter(entry: Dictionary, path: String) -> void:
	var id: String = entry.get("id", "")
	if typeof(entry.get("repeat_policy")) != TYPE_DICTIONARY:
		_add_error(path, id, "repeat_policy", "repeat_policy는 Dictionary여야 합니다.")
	else:
		var policy: Dictionary = entry["repeat_policy"]
		if policy.get("type", "") not in ALLOWED_REPEAT_TYPES:
			_add_error(path, id, "repeat_policy.type", "허용되지 않은 반복 정책입니다.")
		if policy.get("type", "") == "cooldown" and int(policy.get("cooldown_slots", 0)) < 1:
			_add_error(path, id, "repeat_policy.cooldown_slots", "cooldown 정책은 1 이상의 cooldown_slots가 필요합니다.")
	if typeof(entry.get("pages")) != TYPE_ARRAY or entry["pages"].is_empty():
		_add_error(path, id, "pages", "인카운터에는 하나 이상의 페이지가 필요합니다.")


## 인카운터 풀의 추출 정책과 가중치를 검사한다.
func _validate_pool(entry: Dictionary, path: String) -> void:
	var id: String = entry.get("id", "")
	if entry.get("draw_mode", "") not in ALLOWED_DRAW_MODES:
		_add_error(path, id, "draw_mode", "허용되지 않은 draw_mode입니다.")
	if entry.get("reset_policy", "") not in ALLOWED_RESET_POLICIES:
		_add_error(path, id, "reset_policy", "허용되지 않은 reset_policy입니다.")
	if typeof(entry.get("encounters")) != TYPE_ARRAY:
		_add_error(path, id, "encounters", "encounters는 Array여야 합니다.")
		return

	var enabled_weight := 0.0
	for index in entry["encounters"].size():
		var pool_entry: Variant = entry["encounters"][index]
		if typeof(pool_entry) != TYPE_DICTIONARY:
			_add_error(path, id, "encounters[%d]" % index, "풀 항목은 Dictionary여야 합니다.")
			continue
		_require_fields(pool_entry, ["encounter_id", "weight", "enabled"], path, "%s.encounters[%d]" % [id, index])
		var weight := float(pool_entry.get("weight", -1.0))
		if weight < 0.0:
			_add_error(path, id, "encounters[%d].weight" % index, "가중치는 0 이상이어야 합니다.")
		if bool(pool_entry.get("enabled", true)):
			enabled_weight += maxf(weight, 0.0)
	if enabled_weight <= 0.0:
		_add_warning(path, id, "encounters", "현재 활성 항목의 가중치 합이 0입니다.")


## 아이템 중첩 규칙을 검사한다.
func _validate_item(entry: Dictionary, path: String) -> void:
	var id: String = entry.get("id", "")
	var maximum_stack := int(entry.get("maximum_stack", 0))
	if maximum_stack < 1:
		_add_error(path, id, "maximum_stack", "maximum_stack은 1 이상이어야 합니다.")
	if not bool(entry.get("stackable", false)) and maximum_stack != 1:
		_add_error(path, id, "maximum_stack", "stackable이 false이면 maximum_stack은 1이어야 합니다.")


## 정의와 단일 문서 내부를 재귀 순회해 모든 명시적 ID 참조를 검사한다.
func _validate_all_references() -> void:
	for data_type in _repository.get_registered_types():
		for entry in _repository.get_all_by_type(data_type, false):
			var id: String = entry.get("id", "")
			_validate_references_recursive(entry, _repository.get_source_path(id), id, id)

		for record in _repository.get_documents(data_type, false):
			var document: Dictionary = record.get("data", {})
			if not document.has("entries"):
				_validate_references_recursive(document, record.get("path", ""), "", data_type)


## Dictionary와 Array 안의 참조 필드를 재귀적으로 찾는다.
func _validate_references_recursive(value: Variant, path: String, owner_id: String, field_path: String) -> void:
	if typeof(value) == TYPE_DICTIONARY:
		for key_variant in value.keys():
			var key := str(key_variant)
			var child: Variant = value[key_variant]
			var child_path := field_path + "." + key if not field_path.is_empty() else key
			if SINGLE_REFERENCE_FIELDS.has(key):
				_validate_single_reference(child, SINGLE_REFERENCE_FIELDS[key], path, owner_id, child_path)
			elif ARRAY_REFERENCE_FIELDS.has(key):
				_validate_reference_array(child, ARRAY_REFERENCE_FIELDS[key], path, owner_id, child_path)
			else:
				_validate_references_recursive(child, path, owner_id, child_path)
	elif typeof(value) == TYPE_ARRAY:
		for index in value.size():
			_validate_references_recursive(value[index], path, owner_id, "%s[%d]" % [field_path, index])


## 단일 ID 참조의 존재 여부와 data_type을 검사한다. null과 빈 문자열은 선택 필드로 허용한다.
func _validate_single_reference(value: Variant, expected_type: String, path: String, owner_id: String, field: String) -> void:
	if value == null or str(value).is_empty():
		return
	if typeof(value) != TYPE_STRING:
		_add_error(path, owner_id, field, "ID 참조는 문자열 또는 null이어야 합니다.")
		return
	_validate_reference_id(str(value), expected_type, path, owner_id, field)


## ID 배열 참조의 각 원소를 검사한다.
func _validate_reference_array(value: Variant, expected_type: String, path: String, owner_id: String, field: String) -> void:
	if typeof(value) != TYPE_ARRAY:
		_add_error(path, owner_id, field, "ID 목록은 Array여야 합니다.")
		return
	for index in value.size():
		if typeof(value[index]) != TYPE_STRING:
			_add_error(path, owner_id, "%s[%d]" % [field, index], "ID는 문자열이어야 합니다.")
			continue
		_validate_reference_id(value[index], expected_type, path, owner_id, "%s[%d]" % [field, index])


## 실제 참조 ID가 저장소에 존재하고 기대 data_type과 일치하는지 검사한다.
func _validate_reference_id(reference_id: String, expected_type: String, path: String, owner_id: String, field: String) -> void:
	if not _repository.has_data(reference_id):
		_add_error(path, owner_id, field, "참조 ID를 찾을 수 없습니다: %s" % reference_id)
		return
	if not expected_type.is_empty():
		var actual_type := _repository.get_type_for_id(reference_id)
		if actual_type != expected_type:
			_add_error(path, owner_id, field, "참조 ID %s의 종류는 %s이며 %s가 필요합니다." % [reference_id, actual_type, expected_type])


## ID를 키로 사용하는 초기 상태 Dictionary의 모든 키 참조를 검사한다.
func _validate_id_keyed_map(value: Variant, expected_type: String, path: String, field: String) -> void:
	if typeof(value) != TYPE_DICTIONARY:
		_add_error(path, "", field, "ID-key 데이터는 Dictionary여야 합니다.")
		return
	for id_variant in value.keys():
		_validate_reference_id(str(id_variant), expected_type, path, "", "%s.%s" % [field, id_variant])


## 희소 시간표의 날짜, 슬롯 키, 반복 일정 범위를 검사한다.
func _validate_timetable(document: Dictionary, path: String) -> void:
	var days: Variant = document.get("days", [])
	if typeof(days) != TYPE_ARRAY:
		_add_error(path, "", "days", "days는 Array여야 합니다.")
	else:
		for day_index_in_array in days.size():
			var day_entry: Variant = days[day_index_in_array]
			if typeof(day_entry) != TYPE_DICTIONARY:
				_add_error(path, "", "days[%d]" % day_index_in_array, "날짜 항목은 Dictionary여야 합니다.")
				continue
			var day := int(day_entry.get("day_index", -1))
			if day < 0 or day > 999:
				_add_error(path, "", "days[%d].day_index" % day_index_in_array, "day_index는 0~999 범위여야 합니다.")
			var slots: Variant = day_entry.get("slots", {})
			if typeof(slots) != TYPE_DICTIONARY:
				_add_error(path, "", "days[%d].slots" % day_index_in_array, "slots는 Dictionary여야 합니다.")
				continue
			for slot_key_variant in slots.keys():
				var slot_text := str(slot_key_variant)
				if not slot_text.is_valid_int():
					_add_error(path, "", "days[%d].slots.%s" % [day_index_in_array, slot_text], "슬롯 키는 0~47 정수 문자열이어야 합니다.")
					continue
				var slot := int(slot_text)
				if slot < 0 or slot > 47:
					_add_error(path, "", "days[%d].slots.%s" % [day_index_in_array, slot_text], "슬롯 키는 0~47 범위여야 합니다.")

	var repeating: Variant = document.get("repeating_schedules", [])
	if typeof(repeating) != TYPE_ARRAY:
		_add_error(path, "", "repeating_schedules", "repeating_schedules는 Array여야 합니다.")
		return
	for index in repeating.size():
		var schedule: Variant = repeating[index]
		if typeof(schedule) != TYPE_DICTIONARY:
			_add_error(path, "", "repeating_schedules[%d]" % index, "반복 일정은 Dictionary여야 합니다.")
			continue
		_require_fields(schedule, ["schedule_id", "start_day_index", "end_day_index", "slot_index", "interval_days"], path, "repeating_schedules[%d]" % index)
		var start_day := int(schedule.get("start_day_index", -1))
		var end_day := int(schedule.get("end_day_index", -1))
		var slot := int(schedule.get("slot_index", -1))
		var interval := int(schedule.get("interval_days", 0))
		if start_day < 0 or end_day > 999 or end_day < start_day:
			_add_error(path, "", "repeating_schedules[%d]" % index, "반복 날짜 범위가 올바르지 않습니다.")
		if slot < 0 or slot > 47:
			_add_error(path, "", "repeating_schedules[%d].slot_index" % index, "slot_index는 0~47 범위여야 합니다.")
		if interval < 1:
			_add_error(path, "", "repeating_schedules[%d].interval_days" % index, "interval_days는 1 이상이어야 합니다.")


## Dictionary에 필수 필드가 모두 있는지 검사한다.
func _require_fields(data: Dictionary, fields: Array, path: String, owner: String) -> void:
	for field_variant in fields:
		var field := str(field_variant)
		if not data.has(field):
			_add_error(path, owner, field, "필수 필드가 없습니다.")


## Variant가 JSON 숫자로 사용할 수 있는 int 또는 float인지 확인한다.
func _is_number(value: Variant) -> bool:
	return typeof(value) == TYPE_INT or typeof(value) == TYPE_FLOAT


## 지정 필드가 1 이상의 정수인지 검사한다.
func _require_positive_int(data: Dictionary, field: String, path: String, id: String) -> void:
	if not data.has(field) or int(data.get(field, 0)) < 1:
		_add_error(path, id, field, "%s는 1 이상의 정수여야 합니다." % field)


## day_index와 slot_index 또는 별도 필드명을 사용하는 시간 좌표의 범위를 검사한다.
func _validate_time_position(
	data: Dictionary,
	path: String,
	field_prefix: String,
	day_field: String = "day_index",
	slot_field: String = "slot_index"
) -> void:
	var day := int(data.get(day_field, -1))
	var slot := int(data.get(slot_field, -1))
	if day < 0 or day > 999:
		_add_error(path, "", field_prefix + "." + day_field, "day_index는 0~999 범위여야 합니다.")
	if slot < 0 or slot > 47:
		_add_error(path, "", field_prefix + "." + slot_field, "slot_index는 0~47 범위여야 합니다.")


## 표준 오류 레코드를 추가한다.
func _add_error(path: String, data_id: String, field: String, message: String) -> void:
	errors.append({
		"severity": "error",
		"path": path,
		"data_id": data_id,
		"field": field,
		"message": message
	})


## 표준 경고 레코드를 추가한다.
func _add_warning(path: String, data_id: String, field: String, message: String) -> void:
	warnings.append({
		"severity": "warning",
		"path": path,
		"data_id": data_id,
		"field": field,
		"message": message
	})


## 오류 또는 경고 레코드를 한 줄의 읽기 쉬운 문자열로 변환한다.
func _format_issue(issue: Dictionary) -> String:
	return "[%s] 파일=%s 데이터=%s 필드=%s 원인=%s" % [
		str(issue.get("severity", "issue")).to_upper(),
		issue.get("path", ""),
		issue.get("data_id", ""),
		issue.get("field", ""),
		issue.get("message", "")
	]
