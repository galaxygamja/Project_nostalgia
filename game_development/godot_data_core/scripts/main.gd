extends Node

const DataBootstrapScript = preload("res://scripts/data/data_bootstrap.gd")


## 프로젝트 시작 시 데이터 부트스트랩을 실행하는 최소 진입점이다.
## 실제 게임에서는 이 코드를 기존 시작 장면이나 전역 관리자에 옮겨도 된다.
func _ready() -> void:
	var bootstrap := DataBootstrapScript.new()
	bootstrap.name = "RuntimeDataBootstrap"
	bootstrap.data_root = _get_data_root_from_arguments()
	add_child(bootstrap)

	print("[Main] 실제 데이터 경로: %s" % bootstrap.data_root)
	var result := bootstrap.bootstrap()
	if not result.get("ok", false):
		push_error("데이터 초기화에 실패했습니다. Godot 출력창의 오류를 확인하세요.")
		return

	print("[Main] 데이터 코어 준비 완료")
	print("[Main] 등록된 정의 수: %d" % bootstrap.repository.get_definition_count())


## --data-root=res://경로 사용자 인수를 읽는다.
## 인수가 없으면 실제 데이터 기본 폴더인 res://data를 사용한다.
func _get_data_root_from_arguments() -> String:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--data-root="):
			return argument.trim_prefix("--data-root=")
	return "res://data"
