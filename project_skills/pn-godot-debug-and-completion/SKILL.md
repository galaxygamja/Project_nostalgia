---
name: pn-godot-debug-and-completion
description: Use when Project Nostalgia shows a Godot 4.7.1 GDScript parser, project-load, scene/resource, data-bootstrap, test, or runtime failure or unexpected behavior; reproduces and isolates root cause and defines the minimum fix and required rechecks, but does not perform general Godot Q&A or final completion approval.
---

# Project Nostalgia Godot Debugging and Completion Preparation

## 목적

`systematic-debugging`의 핵심인 재현 → 증거 → pattern 비교 → 단일 가설 → 최소 검증 순서를 Godot 4.7.1-stable과 Project Nostalgia data core에 적용한다. 근본 원인을 확인하기 전에는 수정하지 않는다.

이 스킬은 오류 조사와 수정 준비를 담당한다. 완료 선언은 `pn-verification-gate`, Git 기록은 `pn-repository-safety`로 넘긴다.

## 호출 조건

- GDScript parser 오류, project load 실패, runtime 오류
- scene/resource/UID/dependency 오류
- test 실패, bootstrap 실패, missing resource/reference
- 예상과 다른 game loop·시간·schedule 동작
- 정적 audit 결과와 실제 Godot 결과가 다를 때
- 미완성 `game_development/godot_data_core/`와 canonical 설계의 차이가 실제 실패 또는 예상 밖 동작의 원인 후보일 때

## 호출하지 말아야 하는 조건

- Godot API나 문서에 관한 일반 질문처럼 프로젝트 오류·예상 밖 동작이 없는 요청
- 새 설정이나 `[미정]` 설계 선택: `pn-authority-and-conflict-guard`로 넘긴다.
- 오류 없이 새 기능을 구현하는 작업
- 완료 증거만 확인하는 작업: `pn-verification-gate`
- Git branch/staging/push만 확인하는 작업: `pn-repository-safety`

## 필수 입력

- 증상과 기대 동작
- 정확한 재현 단계와 관측 시각
- 현재 branch/commit 및 관련 diff
- Godot executable의 실제 경로와 `--version` 출력, 또는 binary 부재 증거
- project root와 `project.godot`
- 전체 오류·경고·stack trace
- 관련 scene/resource/script/test/data paths
- `AGENTS.md`, canonical SSoT, `KNOWN_CONFLICTS.md`
- 관련 Godot version/compatibility audit

공식 기준은 **Godot 4.7.1-stable**이다. 다른 버전으로 대체하거나 자동 upgrade하지 않는다.

## 수행 순서

### 1. 검증 계층 분류

먼저 현재 증거를 분리한다.

1. 문서·설정 검토
2. 정적 텍스트/JSON 검사
3. Godot 4.7.1 parser/headless project load
4. Godot 4.7.1 runtime/test 실행
5. 필요한 경우 1920×1080 visual capture

낮은 계층 결과를 높은 계층 성공으로 표현하지 않는다. binary가 없거나 `--version`이 정확히 4.7.1-stable이 아니면 3–5단계를 실행 완료로 표시하지 않는다.

### 2. 재현과 증거 수집

1. 오류를 생략하지 않고 처음부터 끝까지 읽는다.
2. project root, main scene, user args, data root를 기록한다.
3. 동일 명령과 입력으로 재현되는지 확인한다.
4. 재현되지 않으면 더 많은 증거를 수집하고 추측하지 않는다.
5. 최근 diff, project settings, 환경 차이를 확인한다.
6. 원본 미완성 프로젝트는 open/save 자동 변환 위험이 있으므로 격리 사본과 승인 없이 editor로 변환하지 않는다.

### 3. data flow 경계 추적

canonical 순서를 바꾸지 않고 어느 경계가 실패하는지 찾는다.

```text
GameJsonLoader
→ GameDataRepository
→ GameDataValidator
→ GameDataBootstrap
→ runtime/game loop
```

각 경계에서 확인한다.

- 입력 파일/경로와 출력 record
- JSON parse와 envelope
- `data_type`, ID 중복, reference/type
- validation error/warning
- bootstrap stop 조건
- runtime state 구성과 config 전달

누락 파일이나 reference ID를 임의 생성하여 통과시키지 않는다. alternate repository, envelope 또는 ID 체계를 디버깅 편의로 만들지 않는다.

### 4. working pattern과 비교

- 같은 저장소의 작동하는 유사 경로를 찾는다.
- Godot 4.7.1 문서나 실제 4.7.1 결과를 기준으로 비교한다.
- `stable` alias나 4.8+ 동작을 4.7.1 사실로 가정하지 않는다.
- working/broken 사이의 모든 차이를 기록하고 영향 없다고 미리 제외하지 않는다.

미완성 프로젝트에서 특히 확인할 차이:

- `res://data`에 필수 20개 runtime JSON이 없음
- `game_loop_v1`과 canonical repository가 연결되지 않음
- 900×540과 canonical 1920×1080
- 연속 수치형 skills와 단계제 기술
- 100일 runtime 기본값과 현재 반입 data contract의 1000일 기술 지원 상한
- IFBO 계열 의미와 missing references

1000일은 예상 엔딩 시점이나 최종 게임 기간이 아니며 최종 총 일수는 SSoT에서 `[미정]`이다. 현재 반입 data contract가 1000일 기술 지원 상한을 사용하므로, 100일과의 차이는 엔딩 기간 충돌로 고치지 말고 config 전달/runtime 기본값 문제 후보로 조사한다. 상한 자체를 영구 canonical 요구사항으로 바꾸지는 않는다.

### 5. 단일 가설 검증

다음 형식으로 하나만 세운다.

```text
가설: X가 근본 원인이다.
근거: 관측 Y가 component boundary Z에서 처음 달라진다.
최소 검증: 한 변수만 바꾸거나 read-only probe P를 실행한다.
예상 결과: 가설이 맞으면 A, 틀리면 B.
```

한 번에 하나의 변수만 검증한다. 실패한 가설 위에 추가 수정을 쌓지 않는다. 이해하지 못한 부분은 `미해결`로 보고한다.

### 6. 수정 제안 gate

근본 원인이 증거로 확인된 뒤에만 최소 수정안을 제안한다.

- 관련 테스트 또는 최소 reproduction을 먼저 정한다.
- root cause만 고치고 unrelated refactor를 섞지 않는다.
- SSoT `[미정]`을 코드로 확정하지 않는다.
- 기존 architecture 전면 교체는 별도 계획과 승인 없이 제안하지 않는다.
- 3개 이상의 수정 시도가 실패하면 추가 patch를 중단하고 architecture 문제를 사용자에게 보고한다.

## 수정 가능한 범위

근본 원인이 확인된 뒤 **별도로 승인된 구현 단계에서 이 스킬이 검증된 최소 수정을 적용하는 경우에만** 다음 범위를 수정한다.

- 사용자 승인으로 지정된 격리 작업본의 Godot 코드·scene/resource·test
- 승인된 diagnostic instrumentation
- task-specific debug report

조사 단계에서는 가능한 한 읽기 전용으로 유지한다.

## 수정 금지 범위

- canonical SSoT와 미승인 설정
- `game_development/` 원본 snapshot
- source/project skills
- 누락 reference를 채우기 위한 임의 JSON/ID
- Godot 4.8+ 자동 변환 결과
- 문제와 무관한 refactor

## 중단 조건

- 정확한 재현이나 오류 원문을 확보할 수 없음: 재현 불가 상태와 추가로 필요한 로그·환경 증거를 보고하고 수정 추측을 중단
- 필요한 Godot 4.7.1 binary가 없음: runtime 계층만 중단하고 정적 조사 범위를 명시
- 수정하려면 `[미정]` 또는 known conflict를 선택해야 함
- 원본 snapshot을 변환해야만 조사 가능함
- 3회 이상 root-cause 수정 시도가 실패함

## 검증 절차

- `--version`과 실행 명령·exit code·failure count 기록
- parser/project load/runtime/test를 별도 결과로 기록
- 원래 증상이 재현되었는지 확인
- 가설 검증에서 한 변수만 바뀌었는지 diff 확인
- 수정 후 원래 reproduction과 관련 regression을 다시 실행
- 실제 실행하지 못한 계층을 `미검증`으로 표시
- 완료 판단은 `pn-verification-gate`로 넘김

## 결과 보고 형식

```text
상태: 조사 중 | 원인 확인 | 수정 승인 대기 | 부분 검증 | 차단됨
branch/commit/project root:
Godot binary/version:
증상과 기대 동작:
재현 명령과 결과:
검증 계층:
최초 실패 component boundary:
working/broken 차이:
단일 가설과 최소 검증:
확인된 근본 원인:
제안된 최소 수정:
실행한 검증과 exit 결과:
미검증·보류:
SSoT/schema/ID 영향:
다음 담당 스킬:
```

## 다음 스킬로 넘기는 조건

- 충돌 또는 설정 승인 필요 → `pn-authority-and-conflict-guard`. 반환 이유, 영향 규칙, 필요한 사용자 결정과 재조사 조건을 함께 기록한다.
- 수정·검증 작업의 완료 판정 → `pn-verification-gate`. 실패로 되돌아오면 실패 명령, 최초 실패 경계와 추가 증거를 새 가설의 입력으로 사용하며 같은 검증을 반복 호출하지 않는다.
- diff/staging/commit/push → `pn-repository-safety`
- JSON authoring/schema migration 자체 → 배치 1 범위 밖이므로 보류
