# 미완성 Godot 프로젝트 산출물 감사

- 조사일: 2026-07-20
- Drive 위치: `https://drive.google.com/drive/folders/1J_2ScCy51xlmiU2O3JF_wwZ3synjHbUM?usp=drive_link`
- 조사 방식: 비인증 공개 listing에 대한 읽기 전용 확인 및 로컬 반입본 정적 감사
- 로컬 반입 확인일: `2026-07-20`
- 로컬 반입 위치: `game_development/`
- 원본 변경·이동·삭제: 없음
- 저장소 자동 병합: 없음
- 상세 호환성 보고서: `docs/reports/UNFINISHED_GODOT_PROJECT_COMPATIBILITY_AUDIT.md`

## 1. 접근 가능 여부

공유 폴더의 **직접 하위 목록은 비로그인 상태에서 확인 가능**했다.

확인된 직접 하위:

- `game_json_templates` — folder
- `godot_data_core` — folder
- `json_authoring_guidelines.json` — JSON file
- `게임 프로젝트 설정 기준서 — Project_Nostalgia` — Google Docs document

그러나 현재 연결 도구에서는 하위 폴더의 child ID/direct link를 얻거나 `godot_data_core` 내부를 재귀 열람할 수 없었다. 인증을 우회하거나 다른 수단으로 강제 접근하지 않았다.

따라서 최초 Drive 감사 상태는 **부분 접근 가능 / 상세 조사는 로컬 반입 필요**였다.

## 1.1 로컬 반입 후 상태

사용자가 `game_development/`에 Drive 산출물을 반입한 뒤 저장소 전체에서 `project.godot`을 다시 검색했다.

- 발견 위치: `game_development/godot_data_core/project.godot`
- 프로젝트 후보 수: 1
- 판정된 프로젝트 루트: `game_development/godot_data_core/`
- 형제 자료: `game_development/game_json_templates/`, `game_development/json_authoring_guidelines.json`
- 최초 권장 위치였던 `external_sources/unfinished_godot_project/`: 존재하지 않음

로컬 반입 차단은 해제되었다. 구조, 설정 및 JSON 정적 검사는 완료했지만 정확한 Godot 4.7.1-stable binary가 없어 parser/runtime 호환성 검증은 계속 차단되어 있다. 상세 결과는 `UNFINISHED_GODOT_PROJECT_COMPATIBILITY_AUDIT.md`를 따른다.

## 2. 발견한 프로젝트 후보

| 후보 | 근거 | Project Nostalgia 소속 확정 여부 |
|---|---|---|
| `godot_data_core` | Godot 이름, 기존 context/audit가 같은 폴더를 canonical runtime data architecture로 설명 | 현재 문서와 이름이 일치하지만 Drive listing만으로 동일 revision/내용임을 확정할 수 없음 |
| `game_json_templates` | Godot용 JSON authoring template 가능성 | 실행 가능한 Godot 프로젝트 후보가 아니라 data authoring 자료 후보 |
| `json_authoring_guidelines.json` | JSON 제작 규칙 | 실행 프로젝트 아님 |
| Google Docs SSoT | canonical source와 제목 일치 | 프로젝트 문서 후보, Godot 실행 프로젝트 아님 |

미완성 UI 프로젝트나 별도의 prototype project로 명확히 보이는 직접 하위 폴더는 발견되지 않았다.

## 3. `project.godot` 및 주요 파일 존재 여부

공유 폴더 직접 하위에서는 다음이 보이지 않았다.

- `project.godot`
- `main.tscn`
- `*.tscn`
- `*.tres`
- `*.gd`
- `*.gd.uid`
- `icon.svg`
- `addons/`
- `.godot/`
- `scripts/`
- `data/`

이는 `godot_data_core` 내부에 없다는 뜻이 아니라, **직접 하위 listing과 현재 도구로는 내부 존재 여부를 확인할 수 없었다**는 뜻이다.

기존 `docs/audits/GODOT_DATA_CORE_AUDIT_v0.1.md`는 과거 다운로드 기반 정적 조사에서 `godot_data_core/project.godot`, `main.tscn`, scripts/data 및 `.godot/`을 확인했다고 기록한다. 이 기록은 현재 Drive 내용을 직접 재검증한 결과가 아니므로 보조 근거로만 사용한다.

## 4. 판정 가능한 Godot 버전 정보

### 앞으로 사용할 공식 기준

사용자가 2026-07-20 승인한 공식 개발 및 검증 기준은 **Godot 4.7.1-stable**이다.

### 과거 미완성 산출물의 실제 버전

**확인 불가.** `project.godot`, scene/resource header, GDScript와 실행 로그를 직접 읽지 못했다.

### 구분

| 근거 종류 | 현재 결과 |
|---|---|
| 실제 Godot 버전을 직접 입증 | 없음 |
| Godot 4 계열 추정 | 과거 audit의 구조·GDScript 명칭만으로는 정확한 minor version 입증 불가 |
| 목표 호환 문서 | `prompts/UI_REVISION_PROMPT_v0.2.md`의 4.7.1 표기 |
| 외부 예제 | `source_skills`의 GDScript는 Project Nostalgia 산출물 아님 |

과거 산출물에서 다른 버전 흔적이 추후 발견되어도 공식 기준 4.7.1-stable을 자동 변경하지 않는다. 먼저 호환성 차이를 보고한다.

## 5. 주요 scene, script, resource 목록

현재 Drive 직접 조사로는 목록을 얻지 못했다.

과거 audit가 보고한 보조 목록:

- `project.godot`
- `main.tscn`
- `scripts/main.gd`
- `scripts/data/json_loader.gd`
- `scripts/data/data_repository.gd`
- `scripts/data/data_validator.gd`
- `scripts/data/data_bootstrap.gd`
- `data/` 아래 20개 JSON

이 목록은 로컬 반입 후 hash와 실제 tree로 다시 검증해야 한다.

## 6. 프로젝트 완성도

현재 직접 접근 범위만으로 완성도를 새로 판정할 수 없다.

기존 audit를 참고한 잠정 판정:

- loader/repository/validator/bootstrap의 기초 구조 존재
- JSON 문법·ID shape 등 일부 static check 통과
- missing reference 17건으로 bootstrap 차단 예상
- 실제 Godot runtime/GDScript compile 검증 없음
- skill/book schema 부재
- 기존 item/story/companion/UI draft와 runtime schema 불일치

잠정 활용 등급: **일부 파일 재사용 가능 / 전체 프로젝트 그대로 복구 가능하다고 볼 수 없음**.

## 7. 현재 저장소와의 중복

현재 공개 Git 저장소에는 실제 `godot_data_core` 코드/JSON이 없다. canonical docs와 audit만 있다.

- Drive 후보와 현재 저장소 코드의 byte-level 중복: 비교 불가
- handoff/source_skills: 외부 스킬 묶음이며 Drive Godot 프로젝트와 구분
- 현재 canonical SSoT: Drive Google Docs source에서 migration한 문서 사본이나, Drive runtime project와는 다른 artifact

## 8. SSoT 및 현재 설계와의 충돌 가능성

기존 audit에 따라 다음 충돌/차단이 예상된다.

1. 누락 reference 17건
2. `IFBO_001/002`의 ID 반복 의미와 `daily_once` 불일치
3. continuous 0–100 skills와 확정된 discrete condition-based leveling 충돌
4. item editor/story/companion/UI JSON의 alternate envelope와 lowercase ID
5. `.godot/` 생성 cache 포함
6. validator가 검사하지 않는 flag/effect/formula/type/config 영역
7. 실제 Godot 4.7.1-stable 호환성 미검증

자동 수정·병합하지 않는다.

## 9. 재사용 가능 항목

로컬 반입 후 검증을 전제로 한 후보:

- `project.godot` — 버전/feature/settings 조사 및 migration 기준 자료
- `main.tscn`, `scripts/main.gd` — bootstrap wiring 참고
- loader/repository/validator/bootstrap scripts — canonical architecture 후보
- `id_code_rules.json`, authoring guideline/templates — 규칙 비교 후보
- runtime JSON 20개 — reference/schema 감사 입력
- `.gd.uid` — source 대응 UID라면 보존 후보

## 10. 반입 금지 또는 보류 항목

- `.godot/` — repository 반입 금지, 검사 후 제외
- unknown binary/cache/import outputs — archive 또는 제외
- 현재 저장소 파일에 대한 자동 overwrite
- canonical SSoT에 대한 Drive 자동 merge
- 미검증 `project.godot`를 공식 4.7.1 project로 간주
- alternate JSON schema를 runtime에 직접 복사
- unknown credentials/environment files

## 11. 파일별 처리 제안

| 항목 | 제안 |
|---|---|
| 원본 Drive 폴더 전체 export | 별도 archive 보존 |
| `project.godot` | 저장소 반입 후보, 먼저 read-only audit |
| `.tscn`, `.gd`, `.gd.uid`, `.tres` | 저장소 반입 후보, 4.7.1 compatibility audit 후 선택 |
| runtime JSON | 별도 inspection tree에서 schema/reference 검사 후 선택 |
| authoring templates/guideline | 참고 전용 또는 검증 후 docs/tools 후보 |
| `.godot/` | 제외 |
| unknown binaries | archive, staging 제외 |
| Google Docs export | canonical과 hash/content diff만 수행, 자동 merge 금지 |

## 12. 권장 로컬 반입 구조

이번 작업에서는 폴더를 생성하지 않았다. 사용자가 반입할 때 권장 위치:

```text
external_sources/unfinished_godot_project/
├─ README_SOURCE.md              # Drive URL, 다운로드 시각, 방식
├─ original/                     # 원본 그대로, read-only 취급
│  ├─ godot_data_core/
│  ├─ game_json_templates/
│  └─ json_authoring_guidelines.json
├─ checksums.sha256
└─ inspection/                   # 생성 검사 보고서; 원본 수정 금지
```

### ZIP 대 원본 폴더

**원본 폴더를 ZIP으로 한 번 묶어 보존하고, 별도의 풀린 사본으로 검사하는 방식을 권장한다.**

- ZIP: 원본 snapshot과 전송 무결성 보존
- 풀린 사본: 파일 tree, hash, content 검사
- Drive export가 Google Docs 형식을 변환하므로 export format과 다운로드 시각을 기록
- `.godot/`도 원본 ZIP에는 보존할 수 있지만 Git staging에서는 제외

## 13. 반입 후 검사 절차

1. ZIP SHA-256 기록
2. 풀린 모든 파일의 relative path/size/hash manifest 생성
3. secret filename/content scan
4. nested `.git`, `.godot`, cache, binary, 10 MiB 이상 파일 분류
5. `project.godot`의 `config_version`, name, main_scene, rendering, plugins, autoload, features 읽기
6. `.tscn`/`.tres` header format 조사
7. GDScript 4.7.1 parser 호환성 정적 검사
8. JSON envelope/ID/duplicate/reference 검사
9. 현재 repository와 path/hash/content diff
10. SSoT/KNOWN_CONFLICTS와 semantic conflict report
11. 보존/반입/archive/참고/제외 목록 승인
12. 승인 후 별도 migration branch에서 선택 반입

## 14. 다음 사용자 승인 사항

1. Drive의 `godot_data_core`, `game_json_templates`, guideline을 로컬로 다운로드할지
2. 원본 ZIP과 풀린 검사 사본을 모두 제공할지
3. `external_sources/unfinished_godot_project/`를 다음 작업에서 생성할지
4. 반입 후 전체 tree/hash audit를 수행할지
5. 검증된 일부 파일을 canonical project로 이관할 별도 migration을 승인할지

## 15. 결론

- Drive 직접 하위 listing: 접근 성공
- 로컬 반입: `game_development/`에서 확인
- Godot 프로젝트 루트: `game_development/godot_data_core/`
- `project.godot`: 1개 직접 확인
- 프로젝트 설정 근거: `config_version=5`, feature `4.7`, main scene `res://main.tscn`, GL compatibility
- 과거 산출물의 목표 표기: README에서 Godot 4.7.1 확인
- 실제 JSON: 20개 parse 성공, ID 28개, 중복/형식 위반 0개
- Godot 4.7.1 parser/runtime 검증: 정확한 binary 부재로 미실행
- 공식 미래 기준: Godot 4.7.1-stable
- 현재 차단: **정확한 Godot 4.7.1-stable binary 및 headless/runtime 검증**

최초의 “로컬 반입 필요” 차단은 해제되었다. 원본은 수정하지 않았으며 선택적 이관·수정·병합은 별도 승인 대상이다.
