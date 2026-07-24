class_name GameDataBootstrap
extends Node

const JsonLoaderScript = preload("res://scripts/data/json_loader.gd")
const DataRepositoryScript = preload("res://scripts/data/data_repository.gd")
const DataValidatorScript = preload("res://scripts/data/data_validator.gd")

## 확정된 실제 데이터 파일 20종이다.
## 부트스트랩은 폴더의 임의 JSON을 훑지 않고 이 파일들만 명시적으로 읽는다.
const REQUIRED_DATA_FILES: Array[String] = [
	"config/id_code_rules.json",
	"config/game_config.json",
	"initial/initial_game_state.json",
	"timeline/timetable.json",
	"base/resources.json",
	"base/facilities.json",
	"characters/characters.json",
	"characters/traits.json",
	"characters/status_effects.json",
	"actions/actions.json",
	"schedules/fixed_schedules.json",
	"tasks/tasks.json",
	"formulas/formulas.json",
	"encounters/encounters.json",
	"encounters/encounter_pools.json",
	"items/items.json",
	"locations/locations.json",
	"flags/flags.json",
	"information/clues.json",
	"information/deductions.json"
]

## 실제 게임 데이터가 들어 있는 res:// 폴더다.
@export_dir var data_root: String = "res://data"

## true이면 검증 오류가 하나라도 있을 때 bootstrap을 실패 처리한다.
@export var stop_on_validation_error: bool = true

## JSON 파일 읽기를 담당한다.
var loader: GameJsonLoader

## ID별 정의 조회를 담당한다.
var repository: GameDataRepository

## 구조, ID, 참조, 수치 검사를 담당한다.
var validator: GameDataValidator


## 로더, 저장소, 검사기를 준비한다.
func _init() -> void:
	loader = JsonLoaderScript.new()
	repository = DataRepositoryScript.new()
	validator = DataValidatorScript.new()


## 데이터 폴더 검색부터 유효성 검사까지 전체 초기화 과정을 실행한다.
## 반환값은 {ok, load, repository_errors, validation} 형식이다.
func bootstrap() -> Dictionary:
	repository.clear()

	var required_paths: Array[String] = []
	for relative_path in REQUIRED_DATA_FILES:
		required_paths.append(data_root.path_join(relative_path))

	var load_result := loader.load_json_files(required_paths)
	if not load_result.get("ok", false):
		_print_loader_errors(load_result.get("errors", []))
		return {
			"ok": false,
			"stage": "load",
			"load": load_result,
			"repository_errors": [],
			"validation": {}
		}

	var loaded_documents: Array[Dictionary] = []
	for record in load_result.get("documents", []):
		loaded_documents.append(record)

	var registered := repository.register_loaded_documents(loaded_documents)
	if not registered or not repository.errors.is_empty():
		_print_repository_errors()
		return {
			"ok": false,
			"stage": "repository",
			"load": load_result,
			"repository_errors": repository.errors.duplicate(true),
			"validation": {}
		}

	var validation_result := validator.validate_repository(repository)
	validator.print_report()

	var succeeded: bool = validation_result.get("ok", false) or not stop_on_validation_error
	print("[DataBootstrap] JSON 파일 %d개 로드" % int(load_result.get("file_count", 0)))
	print("[DataBootstrap] 정의 %d개 등록" % repository.get_definition_count())

	return {
		"ok": succeeded,
		"stage": "validation",
		"load": load_result,
		"repository_errors": repository.errors.duplicate(true),
		"validation": validation_result
	}


## 로더 오류를 Godot 오류 출력으로 표시한다.
func _print_loader_errors(loader_errors: Array) -> void:
	for issue_variant in loader_errors:
		var issue: Dictionary = issue_variant
		push_error("[JsonLoader] 파일=%s 원인=%s" % [
			issue.get("path", ""),
			issue.get("message", "")
		])


## 저장소 등록 오류를 Godot 오류 출력으로 표시한다.
func _print_repository_errors() -> void:
	for issue in repository.errors:
		push_error("[DataRepository] 파일=%s 원인=%s" % [
			issue.get("path", ""),
			issue.get("message", "")
		])
