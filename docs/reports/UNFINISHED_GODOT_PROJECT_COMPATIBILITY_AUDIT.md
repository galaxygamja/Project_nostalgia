# 미완성 Godot 프로젝트 4.7.1 호환성 감사

- 감사일: 2026-07-20
- 감사 브랜치: `audit/unfinished-godot-4.7.1`
- 공식 기준: **Godot 4.7.1-stable**
- 반입 위치: `game_development/`
- 판정된 프로젝트 루트: `game_development/godot_data_core/`
- 원본 프로젝트 변경: 없음
- 검증 수준: 파일 구조·텍스트·JSON 정적 검사 완료, Godot parser/runtime 검증 미실행

## 1. 결론

`project.godot`은 한 개만 발견되었으며 실제 프로젝트 루트는 `game_development/godot_data_core/`다. 설정과 README는 Godot 4.7 계열 및 4.7.1을 명시하고, scene/resource 형식도 Godot 4 형식이다. 그러나 실행 환경에서 정확한 Godot 4.7.1-stable binary를 찾지 못했으므로 `--version`, headless parser/load, runtime test는 실행하지 않았다. 따라서 **4.7.1 호환 의도가 확인되었지만 실행 호환성은 미검증**이다.

데이터 코어의 `GameJsonLoader` → `GameDataRepository` → `GameDataValidator` → `GameDataBootstrap` 구조와 20개 JSON의 기본 envelope/ID 형식은 canonical architecture와 잘 맞는다. 반면 실제 JSON은 프로젝트의 `data/`에 배치되어 있지 않고 형제 폴더 `game_json_templates/`에 있으므로 기본 실행은 20개 파일 누락으로 bootstrap에 실패할 것으로 예상된다. 이는 정적 추론이며 runtime 관측 결과가 아니다.

## 2. 프로젝트 루트 판정

검색된 `project.godot`:

- `game_development/godot_data_core/project.godot` — 유일한 후보

요청에서 최초 지정한 `external_sources/unfinished_godot_project/`는 존재하지 않았고, 사용자가 추가로 알린 `game_development/` 아래에서 프로젝트를 확인했다. 여러 후보를 임의 선택하는 상황은 발생하지 않았다.

## 3. `project.godot` 설정

| 항목 | 값 | 근거 |
|---|---|---|
| `config_version` | `5` | `game_development/godot_data_core/project.godot:8` |
| 프로젝트 이름 | `Game Data Core` | `project.godot:12` |
| main scene | `res://main.tscn` | `project.godot:13` |
| feature tag | `4.7` | `project.godot:14` |
| viewport | `900×540` | `project.godot:18-19` |
| rendering method | `gl_compatibility` | `project.godot:23-24` |
| autoload | 없음 | 관련 section 없음 |
| enabled plugins | 없음 | 관련 section 및 `addons/` 없음 |

README는 대상을 `Godot 4.7.1`로 명시한다(`game_development/godot_data_core/README.txt:1`). 이는 제작 의도에 대한 직접 근거지만 실제 binary 실행 증거는 아니다.

## 4. 파일 인벤토리

프로젝트 루트 총 23개 파일, 65,101 bytes:

| 종류 | 수량 | 비고 |
|---|---:|---|
| `.gd` | 14 | data 4, runtime 3, game loop v1 4, entry 1, tests 2 |
| `.gd.uid` | 5 | entry/data scripts에만 존재 |
| `.tscn` | 1 | `main.tscn` |
| `.tres` | 0 | 없음 |
| `.res` | 0 | 없음 |
| `addons/` | 0 | 없음 |
| `.godot/` | 0 | cache 미반입 |

주요 구성:

- 진입점: `main.tscn`, `scripts/main.gd`
- data core: `scripts/data/json_loader.gd`, `data_repository.gd`, `data_validator.gd`, `data_bootstrap.gd`
- runtime: `scripts/runtime/game_state.gd`, `time_manager.gd`, `schedule_manager.gd`
- loop prototype: `scripts/game_loop_v1/*.gd`
- tests: `tests/runtime_core_test.gd`, `tests/game_loop_v1_test.gd`

Scene은 `res://scripts/main.gd`만 참조하는 최소 Node 장면이다(`main.tscn:0-5`). UID 기반 ext_resource가 아니라 path 기반 참조이므로 현재 UID 누락 자체가 이 장면의 직접 차단 증거는 아니다.

## 5. JSON 정적 검사

형제 폴더 `game_development/game_json_templates/`의 실제 데이터 파일(`*_양식.json` 제외)을 검사했다.

- 실제 JSON: 20개
- JSON parse 성공: 20개
- parse 오류: 0개
- 수집된 entry ID: 28개
- 중복 ID: 0개
- `ABCD_001` 형식 위반: 0개
- `schema_version` 또는 `data_type` 누락: 0개
- `entries` 없는 singleton 문서: 4개

`entries` 없는 4개는 repository가 명시적으로 지원하는 `game_config`, `id_code_rules`, `initial_game_state`, `timetable` 유형과 일치하는 설계다(`data_repository.gd:9-10`, `data_repository.gd:51-52`).

중요한 배치 차이:

- bootstrap 기본값: `res://data` (`data_bootstrap.gd:32-36`)
- 필수 파일: 20개를 명시적으로 요구 (`data_bootstrap.gd:7-30`)
- 현재 프로젝트 `data/`: `README.txt`만 존재
- 실제 20개 JSON: 프로젝트 바깥의 형제 `game_json_templates/`

원본을 옮기거나 복사하지 않았으며 `--data-root` 실행도 binary 부재로 수행하지 않았다.

## 6. Godot 4.7.1 실행 검증

확인한 명령 이름:

- `godot`
- `godot4`
- `Godot_v4.7.1-stable_win64.exe`
- `Godot_v4.7.1-stable_mono_win64.exe`

모두 찾지 못했다. 사용자 프로필 Downloads/Desktop, LocalAppData Programs, Program Files 계열에서도 정확한 4.7.1 executable 후보를 찾지 못했다. 검색 명령은 일부 접근 불가 경로 때문에 exit code 1을 반환했지만 명령/PATH 후보는 모두 `NOT_FOUND`였다.

따라서 다음은 **미실행**이다.

- `godot --version`
- `--headless --path ... --editor --quit`
- main scene parse/load
- `runtime_core_test.gd`
- `game_loop_v1_test.gd`
- 실제 bootstrap 실행

다른 Godot 버전을 대체 사용하지 않았다.

## 7. 오류 분류

| 분류 | 결과 |
|---|---|
| parser error | 미검증 — 4.7.1 binary 없음 |
| missing dependency | 정적 확인상 scene/script 외부 addon 의존 없음; parser 기준 미검증 |
| missing resource | **예상됨** — 기본 `res://data`에 필수 JSON 20개가 없음 |
| invalid UID | 확인된 오류 없음; `.gd.uid` 5개만 존재하나 scene은 path 참조 사용 |
| deprecated API | 텍스트 검토에서 확정된 항목 없음; 4.7.1 parser로 확인 필요 |
| plugin incompatibility | addon/plugin 없음 |
| project setting incompatibility | `config_version=5`, feature `4.7`, GL compatibility로 정적 충돌 없음 |
| runtime-only error | 미검증 |

## 8. 코드·설계 관찰

### Canonical architecture와 일치

- `GameJsonLoader`는 FileAccess/JSON으로 오류를 구조화한다 (`json_loader.gd:9-37`).
- `GameDataRepository`는 ID 및 data_type 색인과 중복 검사를 제공한다 (`data_repository.gd:32-70`, `168-197`).
- `GameDataValidator`는 schema version, `ABCD_001`, reference, formula tree를 검사한다 (`data_validator.gd:142-155`, `220-245`, `302-329`, `384-445`).
- `GameDataBootstrap`은 loader → repository → validator 순서를 구현한다 (`data_bootstrap.gd:55-100`).
- formula는 실행 문자열이 아니라 구조화된 expression tree로 다뤄진다.

### 충돌·보완 필요

1. `GameState`와 `GameLoopV1`의 기본 `max_days`는 100이다 (`game_state.gd:6`, `17`; `game_loop_v1.gd:22`). JSON validator와 data는 1000일을 강제한다 (`data_validator.gd:167-172`, `187-190`). 호출자가 config 값을 전달하지 않으면 권위 자료와 불일치한다.
2. character JSON의 `skills`는 수치형 연속 능력값이다. canonical SSoT의 discrete condition-based skill 성장 체계와 의미 충돌하므로 그대로 canonical skill system으로 채택할 수 없다.
3. viewport 900×540은 16:9이나 canonical 1920×1080 실제 실행·캡처 기준이 아니다. 별도 UI project setting 및 실제 캡처 검증이 필요하다.
4. main scene은 data bootstrap 예제일 뿐, 문서형 한국어 UI·정보 비대칭·시각 언어를 구현하지 않는다.
5. `game_loop_v1`은 canonical JSON repository에서 상태를 구성하는 wiring이 아직 없고 자체 `initial_data`/action dictionary 계약을 사용한다.
6. 테스트 스크립트는 존재하지만 실행 기록이 없으며, `runtime_core_test.gd`도 100일을 명시한다 (`tests/runtime_core_test.gd:7-10`).

과거 audit의 missing reference 17건과 `IFBO_001/002` 의미 충돌은 이번에 Godot validator로 재실행하지 못했다. 단순 JSON parse/ID shape 검사는 이를 해소하지 않는다.

## 9. 재사용 등급

| 구성 | 등급 | 이유 |
|---|---|---|
| `json_loader.gd` | 그대로 재사용 가능(정적) | canonical envelope 입력을 안전하게 읽는 독립 구조; 4.7.1 parser 확인은 남음 |
| `data_repository.gd` | 그대로 재사용 가능(정적) | ID/data_type 색인과 중복 방지 구조가 canonical architecture와 일치 |
| `data_validator.gd` | Godot 4.7.1 수정 후 재사용 가능 | 핵심 구조는 유효하나 SSoT 의미 규칙·누락 영역 보강 및 runtime 검증 필요 |
| `data_bootstrap.gd` | Godot 4.7.1 수정 후 재사용 가능 | architecture는 일치하나 실제 data 배치/manifest/export 처리 필요 |
| `main.tscn`, `main.gd` | 설계 참고만 가능 | data-core smoke entry이며 실제 게임/UI 진입점 아님 |
| `game_state.gd`, runtime managers | Godot 4.7.1 수정 후 재사용 가능 | 시간 슬롯 기초는 유효하나 100/1000일 config wiring과 SSoT 계약 보정 필요 |
| `game_loop_v1/*.gd` | 설계 참고만 가능 | prototype phase/action loop로 유용하나 repository 및 canonical semantics 통합 전 |
| tests | Godot 4.7.1 수정 후 재사용 가능 | 기초 회귀 테스트 후보이나 4.7.1 실행 및 1000일/config 사례 보강 필요 |
| 실제 JSON 20개 | Godot 4.7.1 수정 후 재사용 가능 | parse/envelope/ID shape 통과; reference·semantic conflict 및 skill 모델 수정 필요 |
| `*_양식.json`, 설명서, guideline | 설계 참고만 가능 | authoring 자료이며 runtime data에 직접 포함하면 안 됨 |
| `.godot/`/addons/resources | 해당 없음 | 반입되지 않음 |

전체 폐기 권장 구성은 현재 정적 근거만으로 식별하지 않았다. 단, alternate/continuous skill schema를 canonical 규칙처럼 채택하는 것은 폐기해야 한다.

## 10. 후속 검증 절차

1. 정확한 Godot 4.7.1-stable executable 위치를 제공하거나 설치한다.
2. 먼저 `--version` 출력이 정확히 4.7.1-stable인지 확인한다.
3. 원본을 open/save하지 않는 격리 사본에서 headless editor parse/load를 실행한다.
4. 두 test script를 각각 실행하고 exit code와 전체 출력을 보존한다.
5. `--data-root`로 20개 실제 JSON을 지정해 validator 결과를 기록한다.
6. missing references와 `IFBO_001/002`를 재검증한다.
7. 선택적 이관은 별도 migration branch와 사용자 승인 후 수행한다.

이번 감사에서는 원본 프로젝트, runtime JSON, source/project skills를 수정하지 않았다.
