---
name: pn-authority-and-conflict-guard
description: Use when a Project Nostalgia request may compare, replace, promote, or implement an established SSoT setting, system rule, data contract, revision, or unresolved proposal; identifies authority, status, conflict, and approval scope before implementation, but does not handle general planning or wording-only edits.
---

# Project Nostalgia Authority and Conflict Guard

## 목적

`writing-plans`의 명시적 범위·파일·검증 계획 원칙을 유지하면서, Project Nostalgia의 최상위 권위와 승인 절차를 먼저 확인한다. 이 스킬은 **계획과 차이 보고만 작성**하며 프로젝트 코드, runtime JSON 또는 canonical SSoT 본문을 직접 수정하지 않는다.

## 호출 조건

다음 중 하나면 구현 전에 호출한다.

- 기존 확정 규칙·data contract·미해결 결정에 영향을 주거나 겹칠 수 있는 새 기능·설정·콘텐츠·schema·ID·Godot 버전 변경을 계획할 때
- 기존 정의와 새 요청이 겹치거나 충돌할 가능성이 있을 때
- Google Docs 원본과 저장소 canonical 사본을 비교할 때
- `[작업안]` 또는 `[미정]`을 구현 대상으로 삼으려 할 때
- 기존 `[작업안]`을 `[확정]`으로 승격하거나 승인 범위를 판정할 때

여러 파일에 걸친다는 이유만으로 호출하지 않는다. **설정의 권위·상태·충돌·승인**을 판정해야 할 때만 이 스킬이 primary다.

## 호출하지 말아야 하는 조건

- 설정 의미를 바꾸지 않는 문체·맞춤법·서식 정리
- authority 판정이 필요 없는 일반 계획 작성이나 단순 문서 작성
- 코드 오류만 존재하고 설정·계약 변경 가능성이 없는 조사
- 승인된 계획의 기계적 실행만 남았을 때
- 순수한 Git status/staging/push 확인: `pn-repository-safety`로 넘긴다.
- 버그의 근본 원인 조사: `pn-godot-debug-and-completion`으로 넘긴다.
- 이미 수행한 작업의 완료 주장 검증: `pn-verification-gate`로 넘긴다.

## 필수 입력

- 사용자 요청 원문과 변경 목적
- 현재 branch, 기준 commit, 허용·금지 경로
- `AGENTS.md`
- `docs/context/SSOT_POINTER.md`
- `docs/ssot/PROJECT_NOSTALGIA_SSOT.md`
- `docs/ssot/SOURCE_METADATA.md`
- `docs/context/PROJECT_CONTEXT.md`
- `docs/context/KNOWN_CONFLICTS.md`
- 관련 audit와 `docs/plans/` 문서
- Google Docs 비교가 필요하면 확인 가능한 revision 또는 export hash

필수 문서가 없거나 stale 여부를 판단할 근거가 없으면 구현 계획을 확정하지 않는다.

## 수행 순서

### 1. 권위와 provenance 확인

`AGENTS.md`의 first-read 순서를 먼저 따른다. 그 자료를 판정할 때는 다음 authority precedence를 적용하며, 하위 자료가 상위 자료를 자동으로 대체하지 못하게 한다.

1. `AGENTS.md`의 저장소 운영 규칙
2. `docs/ssot/PROJECT_NOSTALGIA_SSOT.md`와 `docs/ssot/SOURCE_METADATA.md`
3. `docs/context/SSOT_POINTER.md`, `PROJECT_CONTEXT.md`, `KNOWN_CONFLICTS.md`
4. task별 audit, report, plan과 실제 구현 근거

그 뒤 다음을 수행한다.

1. canonical SSoT 경로와 source metadata를 확인한다.
2. 비교 대상의 revision 또는 SHA-256을 기록한다.
3. Google Docs와 저장소 사본의 차이를 발견해도 자동 병합하거나 덮어쓰지 않는다.
4. SSoT 본문과 context/audit/report 같은 파생 문서를 구분한다.

### 2. 상태 판정

각 관련 규칙을 다음과 같이 분류한다.

- `[확정]`: 반드시 준수
- `[작업안]`: 임시 상태로 명시하고 canonical 확정처럼 취급하지 않음
- `[미정]`: 구현자가 임의 결정하지 않음
- 사용자 승인으로 바뀐 항목: 승인 날짜, 승인한 정확한 항목, 변경 기록 확인

승인은 사용자가 명시적으로 선택한 항목과 범위에만 적용한다. 한 항목의 승인을 인접 설정, 다른 파일 또는 후속 변경으로 확장하지 않는다. 승인 범위 밖 항목은 기존 상태를 유지한다.

### 3. 차이와 충돌 보고

겹침이나 충돌마다 다음을 기록한다.

1. 기존 규칙과 상태
2. 새 제안
3. 정확한 차이
4. 영향받는 파일·ID·시스템
5. 수치 balance 변경인지 설정/system 변경인지
6. 승인 없이 가능한 작업과 불가능한 작업

다음 알려진 차이를 자동 해결하지 않는다.

- 100일 runtime 기본값과 현재 반입 data contract의 1000일 기술 지원 상한
- 연속 수치형 character skills와 조건 충족형 단계제 기술
- 900×540 프로젝트 설정과 canonical 1920×1080 기준
- item knowledge 5단계 `[작업안]`과 후기 3단계 설계
- `game_loop_v1`과 canonical repository의 미연결
- `res://data` runtime data 누락
- IFBO 계열 ID 의미 문제와 기존 누락 참조

1000일은 예상 엔딩 시점이나 최종 게임 기간이 아니다. 엔딩은 그 이전에 발생할 수 있고 최종 총 일수는 SSoT에서 `[미정]`으로 남아 있다. 현재 반입 data contract는 1000일을 기술 지원 상한으로 사용한다. 코드의 100일 runtime 기본값은 엔딩 기간 충돌이 아니라 기본 설정 전달과 기술 상한 불일치 후보로 보고하며, 이 상한을 영구 canonical 요구사항으로 승격하는 변경은 별도 authority 승인을 따른다.

### 4. 계획 작성

승인된 범위만 작은 검토 단위로 분해한다.

각 task에 다음을 넣는다.

- exact create/modify/read-only paths
- 책임과 인터페이스
- 선행 승인 및 차단 조건
- schema/ID/SSoT 영향
- 검증 계층과 정확한 명령 후보
- 예상 성공·실패 증거
- staging 후보와 금지 경로

`TBD`, 임의 placeholder, 존재하지 않는 도구나 스킬 참조를 만들지 않는다. 계획 위치는 저장소의 `docs/plans/`를 사용한다.

### 5. 승인 gate

다음 중 하나면 계획 상태를 `차단됨`으로 끝낸다.

- `[미정]`을 선택해야 구현할 수 있음
- 기존 `[확정]`을 대체해야 함
- revision/SHA가 불명확하거나 canonical 문서가 누락됨
- alternate JSON envelope/ID/repository가 필요함
- 누락 참조를 임의 생성해야 함
- Godot 4.7.1 이외 버전 변경이 필요함

사용자의 명시적 승인 전에는 변경을 실행하지 않는다. 승인 후에도 본 스킬은 계획과 변경 전후 기록 범위만 담당한다.

## 수정 가능한 범위

- 사용자가 허용한 `docs/plans/`
- 사용자가 요청한 conflict/diff 보고서
- 명시적으로 요청된 metadata 또는 change record 초안

## 수정 금지 범위

- canonical SSoT 본문
- 프로젝트 코드와 Godot scene/resource
- runtime JSON
- source skills와 외부 원본
- Google Docs/Drive 원본
- 승인되지 않은 기존 정의

SSoT 편집을 사용자가 별도로 명시 승인했다면 본 스킬은 diff와 change-log 요구사항을 작성하고, 실제 편집은 승인된 작업 단계로 넘긴다.

## 중단 조건

- authority 순서가 서로 모순되거나 canonical 자료가 없음
- source revision/hash를 확인할 수 없음
- 충돌 해결 선택이 사용자에게 속함
- 요구 범위가 여러 독립 시스템을 묶지만 승인 단위가 불명확함
- 허용·금지 경로가 충돌함

## 검증 절차

- 필수 읽기 자료와 실제 경로 확인
- 관련 문장에 상태 표기와 line reference 기록
- 기존/제안/차이/영향/변경 종류가 모두 있는지 확인
- 자동 병합·덮어쓰기·미정 확정이 계획에 없는지 검사
- exact paths와 검증 명령이 실제로 존재하거나 명시적으로 미검증인지 확인
- 실행 단계 전에 사용자 승인 증거 확인

계획을 작성했다는 사실은 구현 또는 runtime 성공 증거가 아니다.

## 결과 보고 형식

```text
상태: 계획 완료 | 승인 대기 | 차단됨
기준 branch/commit:
canonical SSoT/revision/SHA:
기존 규칙과 상태:
새 제안:
정확한 차이:
영향 파일·ID·시스템:
변경 종류:
승인된 범위:
금지 범위:
검증 계획:
미해결 결정:
다음 담당 스킬:
```

## 다음 스킬로 넘기는 조건

- Godot 오류 재현·원인 조사 → `pn-godot-debug-and-completion`
- 작업 완료 증거 판정 → `pn-verification-gate`
- branch/diff/staging/commit/push 안전 확인 → `pn-repository-safety`
- 승인된 구현 실행 → 사용자 요청에 지정된 구현 절차 또는 향후 담당 스킬. 이 스킬로 되돌아오는 조건은 **새 충돌·새 SHA·승인 범위 밖 변경**을 발견했을 때뿐이다.
- JSON 작성·검증 → 이번 배치에는 담당 스킬이 없으므로 보류하고 사용자 승인 대기
