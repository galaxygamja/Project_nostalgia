# Project Nostalgia 실제 Godot 개발 진입 계획

## 0. 2026-07-24 정제 main 전제

이 계획의 원래 기준에는 `game_development/godot_data_core/`가 있었다. 그러나 정제 main `70913e11bbb98263e7452a0828f7b200f0d924de`에는 의도적으로 skill-preparation allowlist만 통합됐으며, `3138faf20df172263e59335410a349a8cdde4b83`의 게임 기준선·SSoT·runtime JSON은 포함하지 않았다.

따라서 `godot/minimal-data-bootstrap-runtime` branch는 최신 정제 main에서 생성하되 게임 파일을 추가하지 않는다. 실제 D0–D5 구현을 시작하기 전에, 별도 승인된 기준선 통합 Goal가 후보 snapshot의 `game_development/` 및 관련 SSoT 변경을 검토·정제 통합해야 한다. 이 문서는 그 별도 통합 승인 전에는 runtime implementation을 허용하지 않는다.

제외 source skill 6개는 첫 bootstrap blocker가 아니다. 직접 파생/대체 결정은 `EXCLUDED_SKILL_REPLACEMENT_DECISION.md`를 따른다.

- 작성일: 2026-07-21
- 계획 기준 branch: `skills/revise-existing-final-batch`
- 계획 기준 commit: `22ef00a4cb2f3bd4bb32c5e7394e0323f8956a89`
- 다음 개발 branch 제안: `godot/minimal-data-bootstrap-runtime`
- Godot 기준: **4.7.1-stable**
- 상태: 다음 `/goal`에서 실행

## 1. 다음 Goal 목적

정확한 Godot 4.7.1-stable 환경에서 `game_development/godot_data_core/`를 parser로 확인하고, 현재 프로젝트 밖에 있는 20개 candidate runtime JSON을 canonical 경계를 유지한 채 `res://data` 실행 입력으로 연결한다. loader → repository → validator → bootstrap의 최소 실행 경로와 성공/실패를 보여주는 최소 개발 화면을 만든다.

이번 첫 개발 Goal은 누락 참조나 skill schema를 임의 해결하지 않는다. 목표는 “검증 오류 0”이 아니라 **20개 파일 누락 단계에서 벗어나 실제 validator 결과까지 재현 가능하게 도달하는 것**이다.

## 2. 현재 근거

- project root: `game_development/godot_data_core/`
- main scene: `res://main.tscn`
- entry: `res://scripts/main.gd`
- bootstrap default: `res://data`
- required runtime JSON: `data_bootstrap.gd`의 명시적 20개 allowlist
- 현재 `res://data`: 하위 디렉터리와 `README.txt`만 있고 JSON 0개
- candidate JSON 20개: sibling `game_development/game_json_templates/`의 non-`_양식` JSON
- known validator 결과: 과거 정적 감사에서 missing-reference occurrence 17개와 IFBO 의미 문제
- current main: console print만 수행하는 Node
- current viewport: 900×540; canonical PC prototype target은 1920×1080
- 정확한 Godot 4.7.1 binary: PATH·일반 설치 경로에서 `NOT_FOUND` (2026-07-21 재확인)

## 3. 첫 구현 범위

### Checkpoint D0 — binary와 원본 기준선

1. 사용자가 제공한 경로 또는 승인된 설치 방식으로 정확한 4.7.1-stable executable을 확보한다.
2. `<godot> --version` 전체 출력과 SHA-256/파일 경로를 기록한다.
3. source와 project의 시작 SHA manifest를 기록한다.
4. 다른 Godot 버전으로 대체하거나 editor open/save upgrade를 하지 않는다.

성공 조건: version output이 정확한 4.7.1-stable을 식별한다.

### Checkpoint D1 — 수정 전 parser·test 기준선

실행 후보:

```powershell
<godot> --headless --path game_development/godot_data_core --editor --quit
<godot> --headless --path game_development/godot_data_core --script res://tests/runtime_core_test.gd
<godot> --headless --path game_development/godot_data_core --script res://tests/game_loop_v1_test.gd
```

각 command, exit code, stdout/stderr와 최초 실패 경계를 저장한다. 기존 테스트의 `100` 인수는 이번 checkpoint에서 1000 또는 최종 게임 기간으로 자동 변경하지 않는다.

성공 조건: parser/test의 실제 현재 상태가 관측되고 정적 추론과 구분된다.

### Checkpoint D2 — canonical data 연결

1. candidate JSON 20개의 parse, envelope, path와 SHA manifest를 다시 생성한다.
2. `_양식.json`, `_설명.txt`, authoring guideline은 runtime 입력에서 제외한다.
3. `GameDataBootstrap.REQUIRED_DATA_FILES`와 20개 source path를 one-to-one 대조한다.
4. 승인된 deterministic copy/generation 단계로 exact files만 `godot_data_core/data/`에 배치한다.
5. human-authored source와 generated runtime output 경계를 README/manifest에 기록한다.
6. alternate envelope, alternate repository, symlink/network dependency를 만들지 않는다.

성공 조건: loader가 missing-file 단계가 아니라 20개 문서를 읽고 repository 등록·validator 호출까지 도달한다.

### Checkpoint D3 — test-first bootstrap smoke path

먼저 실패하는 smoke test를 작성한다.

- required file count 20
- repository definition count가 관측 가능함
- bootstrap result가 load/repository/validation stage를 분리함
- known validation errors가 숨겨지지 않음
- `stop_on_validation_error`를 끄지 않음

그 뒤 최소 코드만 수정한다. 누락 ID 생성, IFBO rename, item knowledge, skill model, 100/1000일 문제는 해결하지 않고 별도 issue/계획으로 남긴다.

성공 조건: RED 이유와 GREEN 결과가 기록되고 실제 validator report가 재현된다.

### Checkpoint D4 — 최소 개발 화면

main scene에 data bootstrap 증거만 보여주는 작은 Godot Control 화면을 만든다.

- 실제 data root
- load file count
- registered definition count
- validation success/failure count
- 최초 오류 몇 건과 전체 log 위치

결론형 “기지 정상/위험” dashboard를 만들지 않는다. 이 화면은 개발 smoke surface이며 게임의 최종 UI가 아니다. viewport는 확정 PC prototype 기준 1920×1080으로 맞추되 기존 900×540 차이를 변경 기록에 명시한다.

성공 조건: console output과 화면 값이 동일한 bootstrap result에서 나온다.

### Checkpoint D5 — runtime 검증과 원격 보존

```powershell
<godot> --headless --path game_development/godot_data_core --editor --quit
<godot> --headless --path game_development/godot_data_core --script res://tests/data_bootstrap_smoke_test.gd
<godot> --path game_development/godot_data_core
```

- parser exit 0
- smoke test가 정의한 범위 통과
- main runtime에서 loader/repository/validator/bootstrap 결과 관측
- 1920×1080 실제 runtime capture와 pixel metadata 확인
- known validation errors와 미해결 설계를 명시
- 전용 development branch checkpoint commit·push와 local/remote SHA 일치

## 4. 수정 대상

- `game_development/godot_data_core/project.godot`
- `main.tscn`, `scripts/main.gd`
- 필요한 최소 bootstrap result presentation script/scene
- `tests/data_bootstrap_smoke_test.gd`와 직접 fixture/manifest
- 승인된 generated runtime JSON under `godot_data_core/data/`
- 관련 README와 task plan/report

## 5. 수정 금지 대상

- canonical SSoT와 Google Docs
- `game_json_templates/*_양식.json`, 설명서와 human-authored source 원본
- source skill/handoff 원본과 project skill 정의
- alternate repository/envelope/ID system
- known missing ID, IFBO, item knowledge, skill model, 100/1000일을 승인 없이 해결하는 변경
- `.godot/`, cache, imported build output
- main merge, PR, force push

## 6. 차단 조건

- 정확한 Godot 4.7.1-stable binary 없음
- candidate JSON 20개가 canonical runtime input인지 근거가 불충분함
- data 배치가 기존 정의를 변경하거나 missing ID를 새로 결정해야 함
- parser가 source format을 자동 upgrade하려 함
- 예상 밖 tracked/staged 변경 또는 source SHA 차이
- secret, 대용량 binary 또는 라이선스 불명 파일이 staging 후보에 들어옴

## 7. 후속 통합 순서

첫 Goal 완료 뒤에만 다음을 별도 계획한다.

1. missing reference와 IFBO semantic decision
2. config-derived max-days wiring과 100/1000일 구분
3. `game_loop_v1`을 canonical repository/state와 연결
4. absolute-slot 시간·일정·variable action duration 통합
5. 실제 사건 문서 UI와 qualitative display

## 8. 다음 `/goal` 명령 초안

```text
docs/plans/REAL_DEVELOPMENT_ENTRY_PLAN.md를 처음부터 끝까지 읽고 Checkpoint D0부터 D5까지 실행하라. 정확한 Godot 4.7.1-stable binary를 먼저 확인하고 다른 버전을 사용하지 마라. godot/minimal-data-bootstrap-runtime 브랜치를 skills/revise-existing-final-batch의 최신 원격 HEAD에서 생성하라. candidate JSON 20개의 SHA와 REQUIRED_DATA_FILES mapping을 검증한 뒤 승인된 deterministic runtime copy만 res://data에 배치하라. 누락 ID, IFBO, item knowledge, skill model, 100/1000일을 임의 해결하지 말고 loader→repository→validator→bootstrap smoke path와 1920×1080 최소 개발 화면을 test-first로 구현하라. 각 checkpoint를 commit·push하고 local/remote SHA를 확인하라.
```
