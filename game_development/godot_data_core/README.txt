Godot Data Core
대상: Godot 4.7.1

구성
- scripts/data/json_loader.gd
  JSON 파일 검색, _양식.json 제외, 문법 분석, 오류 수집을 담당한다.

- scripts/data/data_repository.gd
  entries 데이터를 ID 및 data_type별로 등록하고 안전하게 조회한다.

- scripts/data/data_validator.gd
  필수 필드, 조합형 ID, 시간, 수치, 계산식, ID 참조를 검사한다.

- scripts/data/data_bootstrap.gd
  로드 -> 등록 -> 검사 순서를 한 번에 실행한다.

- scripts/main.gd, main.tscn
  데이터 코어를 실행하는 최소 예제다.

데이터 배치
1. 실제 게임 JSON 20개를 res://data 아래에 확정된 하위 폴더 구조로 배치한다.
2. *_양식.json, *_설명.txt, 예시 JSON은 res://data에 넣지 않는다.
3. DataBootstrap은 REQUIRED_DATA_FILES에 명시된 20개 파일만 읽는다.
4. 양식이나 예시는 자동 제외하는 것이 아니라 실제 데이터와 물리적으로 분리한다.

폴더 구분
- res://data: 실제 게임 데이터 전용.
- res://sample_data: 형식 확인 및 검사기 테스트용 예시 데이터.

실행
1. project.godot을 Godot 4.7.1에서 연다.
2. 프로젝트를 실행한다.
3. 출력창에서 로딩, 등록, 검사 결과를 확인한다.

다른 실제 데이터 폴더 검사
- 사용자 인수로 데이터 루트를 바꿀 수 있다.
- 예: -- --data-root=res://sample_data

주요 API

var loader := GameJsonLoader.new()
var result := loader.load_json_file("res://data/tasks/tasks.json")

var repository := GameDataRepository.new()
repository.register_document(result.data, result.path)
var task := repository.get_data("TFNO_001")

var validator := GameDataValidator.new()
var report := validator.validate_repository(repository)

주의
- get_data()는 기본적으로 깊은 복사본을 반환한다.
- 원본 데이터가 필요한 내부 검사 코드만 get_data(id, false)를 사용한다.
- 현재 폴더 재귀 검색 방식은 에디터와 개발 빌드에 적합하다. Godot 공식 문서에 따르면
  내보낸 프로젝트에서는 res:// 폴더의 실제 파일 목록이 달라질 수 있으므로, 출시 단계에는
  데이터 파일 경로를 명시한 manifest JSON을 사용하거나 export 포함 설정을 검증해야 한다.
- sample_data에는 아직 제작되지 않은 ID 참조가 일부 포함되어 있으므로 검사 시 누락 참조
  오류가 보고된다. 실제 data 폴더의 검증 결과와 혼동하지 않는다.
