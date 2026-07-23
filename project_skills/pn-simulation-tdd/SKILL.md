---
name: pn-simulation-tdd
description: Use when implementing or changing Project Nostalgia simulation behavior whose correctness depends on time, conditions, delayed effects, cooldowns, schedules, save/load, deterministic distortion, or reference validation; drives one behavior at a time through a witnessed failing test, minimal implementation, and regression checks, but does not apply to prose-only documents, visual styling, or unresolved design decisions.
---

# Project Nostalgia Simulation TDD

## 목적

Project Nostalgia의 고위험 simulation 동작을 작은 행동 계약으로 나누고, 실패하는 테스트를 먼저 확인한 뒤 최소 구현과 회귀 검증을 수행한다. 30분 시간 격자는 하루 행동 횟수가 아니며, Godot 기준은 4.7.1-stable이다.

## 호출 조건

- absolute slot, day boundary, variable duration 또는 이동 시간 계산을 구현·변경할 때
- requirements, effects, delayed effects, cooldown 또는 schedule conflict 동작을 바꿀 때
- save/load round-trip, migration, 중복 적용 방지 또는 deterministic roll 저장을 바꿀 때
- data reference validator나 bootstrap 차단 조건에 새 동작을 추가할 때
- simulation 버그의 근본 원인이 확인되어 회귀 테스트와 최소 수정 단계로 넘어갈 때

## 호출하지 말아야 하는 조건

- SSoT·설정·schema 선택이 아직 미정인 경우: `pn-authority-and-conflict-guard`
- 오류 원인과 재현이 아직 확인되지 않은 경우: `pn-godot-debug-and-completion`
- prose-only 문서, 라이선스 감사, UI 문구·시각 스타일만 바꾸는 작업
- runtime behavior를 바꾸지 않는 generated JSON 재생성
- 완료 증거만 판정하는 작업: `pn-verification-gate`

## 필수 입력

1. `AGENTS.md`와 task별 승인 계획
2. canonical SSoT 및 `KNOWN_CONFLICTS.md`
3. 관련 Godot 4.7.1 코드와 기존 테스트
4. 관련 canonical data contract와 실제 fixture
5. 변경할 행동을 한 문장으로 표현한 기대 결과
6. 실행할 정확한 test command와 현재 Godot binary 상태

## 수행 순서

### 1. 행동 계약 고정

- 입력, 관측 가능한 결과, 불변 조건, 오류 조건을 적는다.
- `[미정]`, known conflict 또는 새 schema 선택이 필요하면 구현하지 않고 authority로 넘긴다.
- 30분 단위를 `48 actions/day`로 해석하지 않는다. 행동은 여러 slot을 소비할 수 있다.

### 2. RED 작성

- 하나의 행동만 보여주는 가장 작은 테스트를 먼저 작성한다.
- production API를 희망 형태로 호출하고 내부 구현 세부보다 관측 결과를 검증한다.
- 실제 코드와 fixture를 우선하고, 불가피한 boundary 외에는 mock을 사용하지 않는다.

필수 후보 중 관련 항목을 고른다.

- `absolute_slot = day_index * 48 + slot_index`
- day boundary를 넘는 duration
- 서로 다른 duration의 action과 movement
- fixed schedule과 알려진 충돌
- cooldown의 absolute-slot 비교
- requirements 미충족 시 effects 미적용
- delayed effect가 save/load 후 한 번만 적용
- 심각한 인식 붕괴 결과가 reload로 reroll되지 않음
- missing/duplicate ID가 bootstrap 전에 차단됨

### 3. RED 확인

- 정확한 단일 테스트 명령을 실행한다.
- 테스트가 **기대 이유로 실패**하는지 확인한다.
- syntax, fixture path, test discovery 오류라면 행동 실패로 인정하지 않고 테스트 환경부터 고친다.
- 처음부터 통과하면 기존 동작을 검사한 것이므로 기대 계약과 테스트를 다시 확인한다.

### 4. GREEN 최소 구현

- 실패 원인을 통과시키는 최소 production change만 적용한다.
- 병렬 repository, 새 envelope, 새 ID 체계 또는 executable formula string을 만들지 않는다.
- `requirements`와 `effects`, internal mechanics와 player-visible display를 섞지 않는다.
- unrelated cleanup과 미정 설계 확장을 하지 않는다.

### 5. GREEN 확인

- RED와 같은 단일 테스트를 다시 실행한다.
- 관련 suite와 전체 가능한 regression suite를 실행한다.
- failure, error, unexpected warning, skipped test를 기록한다.

### 6. REFACTOR

- green 상태에서만 이름·중복·fixture를 정리한다.
- 동작이 추가되면 다음 RED로 별도 cycle을 시작한다.
- refactor 뒤 관련 suite를 다시 실행한다.

### 7. 증거 전달

- RED 명령·실패 이유, GREEN 명령·결과, 전체 regression 결과를 `pn-verification-gate`에 넘긴다.
- runtime을 실행하지 못했다면 정적/테스트 범위만 적고 runtime 성공을 주장하지 않는다.

## 수정 가능한 범위

- 사용자 승인 계획에 지정된 simulation code와 직접 관련 test
- 승인된 test fixture와 deterministic seed/save fixture
- task-specific TDD 기록 또는 계획 문서

## 수정 금지 범위

- canonical SSoT와 Google Docs
- 승인되지 않은 runtime JSON, schema 또는 ID
- source skill과 handoff 원본
- `.godot/`, import cache, generated build output
- 테스트 통과를 위한 validation 비활성화나 `stop_on_validation_error=false`
- unrelated UI, story, character 또는 balance 값

## 중단 조건

- 기대 행동이 `[미정]`이거나 기존 확정 규칙과 충돌함
- 실제 실패를 재현하지 못하거나 필요한 Godot 4.7.1 환경이 없음
- 테스트하려면 누락 ID나 fixture 의미를 임의로 결정해야 함
- production change가 승인 범위를 벗어남
- 같은 접근이 반복 실패해 근본 원인 가설 재검토가 필요함

## 검증 절차

1. RED 명령과 non-zero 결과, 기대 failure message 확인
2. GREEN 단일 테스트 exit 0 확인
3. 관련 regression suite exit 0과 failure count 0 확인
4. save/load 또는 delayed effect면 round-trip과 duplicate-application 검사
5. 시간 로직이면 day boundary와 absolute-slot 검사
6. `git diff --check`와 변경 범위 확인
7. Godot parser/headless/runtime을 실제 수행한 계층만 보고

## 결과 보고 형식

```text
behavior contract:
RED command/result/expected failure:
GREEN minimal change:
GREEN command/result:
regression command/result:
day/slot/save/reference coverage:
SSoT/schema/ID impact:
runtime verification level:
remaining failures/risks:
```

## 다음 스킬로 넘기는 조건

- 새 설정·schema·balance 결정 필요 → `pn-authority-and-conflict-guard`
- RED가 예상과 다르거나 근본 원인 재조사 필요 → `pn-godot-debug-and-completion`
- GREEN과 regression 후 완료 판정 → `pn-verification-gate`
- 기능 검증 통과 후 staging/commit/push → `pn-repository-safety`
