class_name GameJsonLoader
extends RefCounted

## 마지막 로딩 과정에서 수집된 오류 목록이다.
var errors: Array[Dictionary] = []


## 단일 JSON 파일을 안전하게 읽는다.
## 반환값은 {ok, path, data, error} 형식이며 실패해도 예외 대신 오류 정보를 돌려준다.
func load_json_file(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return _failure(path, "파일을 찾을 수 없습니다.")

	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return _failure(path, "파일을 열 수 없습니다. 오류 코드: %s" % FileAccess.get_open_error())

	var source_text := file.get_as_text()
	file.close()

	var parser := JSON.new()
	var parse_error := parser.parse(source_text)
	if parse_error != OK:
		var message := "JSON 문법 오류 (줄 %d): %s" % [
			parser.get_error_line(),
			parser.get_error_message()
		]
		return _failure(path, message)

	if typeof(parser.data) != TYPE_DICTIONARY:
		return _failure(path, "JSON 최상위 값은 Object(Dictionary)여야 합니다.")

	return {
		"ok": true,
		"path": path,
		"data": parser.data,
		"error": ""
	}


## 지정한 폴더 아래의 모든 JSON 경로를 재귀적으로 찾는다.
## 파일명에 따른 예외 규칙은 적용하지 않는다. 실제 데이터 폴더에는 실제 파일만 둔다.
func find_json_files(root_path: String) -> Array[String]:
	errors.clear()
	var found_files: Array[String] = []
	_scan_directory(root_path, found_files)
	found_files.sort()
	return found_files


## 폴더의 모든 JSON을 읽고 성공한 문서와 오류를 함께 반환한다.
## 한 파일이 실패해도 나머지 파일은 계속 읽어 전체 오류를 한 번에 확인할 수 있다.
func load_json_tree(root_path: String) -> Dictionary:
	errors.clear()
	var documents: Array[Dictionary] = []
	var paths := find_json_files(root_path)
	return load_json_files(paths)


## 명시적으로 전달된 실제 데이터 파일 경로만 읽는다.
## 확정된 파일 목록을 검증할 때 사용하며 누락 파일도 각각 오류로 보고한다.
func load_json_files(paths: Array[String]) -> Dictionary:
	errors.clear()
	var documents: Array[Dictionary] = []

	for path in paths:
		var result := load_json_file(path)
		if result.get("ok", false):
			documents.append({
				"path": path,
				"data": result["data"]
			})
		else:
			# load_json_file()의 _failure()가 이미 errors에 같은 내용을 기록한다.
			pass

	return {
		"ok": errors.is_empty(),
		"documents": documents,
		"errors": errors.duplicate(true),
		"file_count": paths.size()
	}


## 내부 재귀 함수. 현재 폴더의 파일과 하위 폴더를 순회한다.
func _scan_directory(
	root_path: String,
	found_files: Array[String]
) -> void:
	var directory := DirAccess.open(root_path)
	if directory == null:
		errors.append({
			"path": root_path,
			"message": "데이터 폴더를 열 수 없습니다. 오류 코드: %s" % DirAccess.get_open_error()
		})
		return

	directory.list_dir_begin()
	var entry_name := directory.get_next()
	while entry_name != "":
		if entry_name != "." and entry_name != "..":
			var full_path := root_path.path_join(entry_name)
			if directory.current_is_dir():
				_scan_directory(full_path, found_files)
			elif entry_name.to_lower().ends_with(".json"):
				found_files.append(full_path)
		entry_name = directory.get_next()
	directory.list_dir_end()


## 실패 반환값을 만들고 오류 목록에도 동일한 정보를 남긴다.
func _failure(path: String, message: String) -> Dictionary:
	var error_data := {
		"path": path,
		"message": message
	}
	errors.append(error_data)
	return {
		"ok": false,
		"path": path,
		"data": {},
		"error": message
	}
