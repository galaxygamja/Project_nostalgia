class_name GameDataRepository
extends RefCounted

## ID로 모든 정의를 찾는 주 저장소다.
var _definitions_by_id: Dictionary = {}

## data_type별로 정의 Dictionary를 묶어 보관한다.
var _definitions_by_type: Dictionary = {}

## game_config, timetable처럼 entries 배열이 없는 문서를 data_type별 배열로 보관한다.
var _documents_by_type: Dictionary = {}

## 오류 메시지에서 원본 파일을 표시하기 위한 ID별 출처 경로다.
var _source_by_id: Dictionary = {}

## 등록 중 발견된 치명적 오류다.
var errors: Array[Dictionary] = []

## 실행을 막지는 않지만 확인해야 하는 경고다.
var warnings: Array[Dictionary] = []


## 저장소의 모든 정의, 문서, 오류를 초기화한다.
func clear() -> void:
	_definitions_by_id.clear()
	_definitions_by_type.clear()
	_documents_by_type.clear()
	_source_by_id.clear()
	errors.clear()
	warnings.clear()


## 로더가 읽은 JSON 문서 하나를 저장소에 등록한다.
## entries가 있으면 각 항목을 ID 저장소에 넣고, 문서 자체도 data_type별로 보관한다.
func register_document(document: Dictionary, source_path: String) -> bool:
	if not document.has("data_type") or typeof(document["data_type"]) != TYPE_STRING:
		_add_error(source_path, "최상위 data_type 문자열이 없습니다.")
		return false

	var data_type: String = document["data_type"]
	if data_type.is_empty():
		_add_error(source_path, "data_type은 빈 문자열일 수 없습니다.")
		return false

	if not _documents_by_type.has(data_type):
		_documents_by_type[data_type] = []
	_documents_by_type[data_type].append({
		"path": source_path,
		"data": document
	})

	if not document.has("entries"):
		return true

	if typeof(document["entries"]) != TYPE_ARRAY:
		_add_error(source_path, "entries는 Array여야 합니다.")
		return false

	var succeeded := true
	for index in document["entries"].size():
		var entry_variant: Variant = document["entries"][index]
		if typeof(entry_variant) != TYPE_DICTIONARY:
			_add_error(source_path, "entries[%d]는 Object(Dictionary)여야 합니다." % index)
			succeeded = false
			continue

		var entry: Dictionary = entry_variant
		if not _register_entry(entry, data_type, source_path, index):
			succeeded = false

	return succeeded


## 여러 로딩 문서를 한 번에 등록한다.
## 각 원소는 JsonLoader가 반환하는 {path, data} 형식이어야 한다.
func register_loaded_documents(loaded_documents: Array[Dictionary]) -> bool:
	var succeeded := true
	for loaded in loaded_documents:
		var path: String = loaded.get("path", "<unknown>")
		var data: Dictionary = loaded.get("data", {})
		if not register_document(data, path):
			succeeded = false
	return succeeded


## ID로 정의를 조회한다.
## 호출자가 원본을 수정하지 못하도록 기본적으로 깊은 복사본을 반환한다.
func get_data(id: String, duplicate_result: bool = true) -> Dictionary:
	if not _definitions_by_id.has(id):
		return {}
	var data: Dictionary = _definitions_by_id[id]
	return data.duplicate(true) if duplicate_result else data


## 지정한 ID가 등록되어 있는지 확인한다.
func has_data(id: String) -> bool:
	return _definitions_by_id.has(id)


## 지정 data_type에 속한 모든 정의를 배열로 반환한다.
## 기본적으로 각 정의를 깊은 복사해 원본 데이터의 훼손을 막는다.
func get_all_by_type(data_type: String, duplicate_results: bool = true) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if not _definitions_by_type.has(data_type):
		return result

	for entry in _definitions_by_type[data_type]:
		result.append(entry.duplicate(true) if duplicate_results else entry)
	return result


## entries 유무와 관계없이 지정 data_type의 원본 문서 목록을 반환한다.
func get_documents(data_type: String, duplicate_results: bool = true) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if not _documents_by_type.has(data_type):
		return result

	for document_record in _documents_by_type[data_type]:
		result.append(
			document_record.duplicate(true) if duplicate_results else document_record
		)
	return result


## 저장소에 등록된 모든 data_type 문자열을 정렬해 반환한다.
func get_registered_types() -> Array[String]:
	var result: Array[String] = []
	for key in _documents_by_type.keys():
		result.append(str(key))
	result.sort()
	return result


## 저장소에 등록된 모든 ID를 정렬해 반환한다.
func get_all_ids() -> Array[String]:
	var result: Array[String] = []
	for key in _definitions_by_id.keys():
		result.append(str(key))
	result.sort()
	return result


## ID가 정의된 원본 JSON 경로를 반환한다.
func get_source_path(id: String) -> String:
	return str(_source_by_id.get(id, ""))


## ID가 속한 data_type을 반환한다. 등록되지 않은 ID면 빈 문자열을 반환한다.
func get_type_for_id(id: String) -> String:
	if not _definitions_by_id.has(id):
		return ""
	for data_type in _definitions_by_type.keys():
		for entry in _definitions_by_type[data_type]:
			if entry.get("id", "") == id:
				return str(data_type)
	return ""


## 현재 등록된 ID 정의의 총 개수를 반환한다.
func get_definition_count() -> int:
	return _definitions_by_id.size()


## 특정 data_type 문서가 하나 이상 등록되었는지 확인한다.
func has_document_type(data_type: String) -> bool:
	return _documents_by_type.has(data_type) and not _documents_by_type[data_type].is_empty()


## 개별 entries 항목의 ID와 중복을 검사한 뒤 색인에 등록한다.
func _register_entry(
	entry: Dictionary,
	data_type: String,
	source_path: String,
	index: int
) -> bool:
	if not entry.has("id") or typeof(entry["id"]) != TYPE_STRING:
		_add_error(source_path, "entries[%d]에 문자열 id가 없습니다." % index)
		return false

	var id: String = entry["id"]
	if id.is_empty():
		_add_error(source_path, "entries[%d]의 id가 비어 있습니다." % index)
		return false

	if _definitions_by_id.has(id):
		_add_error(
			source_path,
			"중복 ID %s. 최초 선언 파일: %s" % [id, _source_by_id[id]]
		)
		return false

	_definitions_by_id[id] = entry
	_source_by_id[id] = source_path

	if not _definitions_by_type.has(data_type):
		_definitions_by_type[data_type] = []
	_definitions_by_type[data_type].append(entry)
	return true


## 저장소 등록 오류를 표준 형식으로 추가한다.
func _add_error(path: String, message: String) -> void:
	errors.append({
		"severity": "error",
		"path": path,
		"data_id": "",
		"field": "",
		"message": message
	})
