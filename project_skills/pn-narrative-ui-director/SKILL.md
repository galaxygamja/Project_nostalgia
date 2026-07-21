---
name: pn-narrative-ui-director
description: Use when planning, implementing, revising, or reviewing Project Nostalgia's Godot narrative UI, Korean interface copy, evidence/document layout, qualitative information disclosure, subjective distortion, electronic tampering, or 1920×1080 visual proof; derives deliberate visual choices from the game's in-world records and never substitutes a generic web dashboard or static mockup for Godot runtime evidence.
---

# Project Nostalgia Narrative UI Director

## 목적

Project Nostalgia의 화면을 오래 운영된 생존 기지의 기록·증거·업무 표면으로 설계한다. 플레이어 대신 결론을 말하지 않고, 정보 출처와 주인공의 인식 한계를 보여주며, Godot 4.7.1에서 실제 1920×1080 실행 증거로 검수한다.

## 호출 조건

- Godot Control scene, Theme, typography, layout 또는 UI copy를 새로 만들거나 바꿀 때
- 사건 문서, 보고서, 장부, 일정, 선택지와 상태 진입점을 구성할 때
- exact mechanics를 player-visible qualitative information으로 변환할 때
- fatigue/stress distortion과 electronic tampering을 시각적으로 구분할 때
- UI screenshot, 해상도, accessibility 또는 generic-dashboard 패턴을 검수할 때

## 호출하지 말아야 하는 조건

- 설정·item knowledge·skill level 같은 미정 설계를 확정하는 작업
- JSON schema, ID 또는 repository architecture 작성
- 일반 웹사이트·모바일 dashboard 디자인
- UI와 무관한 Godot parser/runtime 오류 조사
- static PNG만 만들고 Godot UI 완료를 주장하는 작업

## 필수 입력

1. `AGENTS.md`와 canonical SSoT
2. `docs/context/UI_HUMAN_DESIGN_GUIDANCE_v0.1.md`
3. `PROJECT_CONTEXT.md`, `KNOWN_CONFLICTS.md`와 task plan
4. 현재 Godot 4.7.1 scene/theme/script와 repository 조회 경로
5. 화면의 실제 사건, 사용자 역할, 정보 출처와 허용된 정밀도
6. target resolution과 runtime capture 가능 여부

## 수행 순서

### 1. 화면의 한 가지 일 고정

- 이 화면에서 플레이어가 판단해야 하는 질문을 한 문장으로 적는다.
- 관련 없는 전역 자원·상태·통계를 메인 화면에서 제거한다.
- 설정 의미나 정보 공개 단계가 미정이면 authority로 넘긴다.

### 2. 정보 출처 분류

모든 표시 정보를 다음 중 하나로 태그한다.

- 자동 기록
- 종이 장부·수기 메모
- 직접 관찰
- 담당자 증언
- 소문
- 책임자의 기억·추정
- 의료진 또는 전문가 진단

작성자, 시각, 측정 근거와 누락을 보존한다. “위험도 높음” 같은 결론표 대신 서로 비교할 원자료를 보여준다.

### 3. 정보 공개 경계

- main UI는 주인공에게 측정 근거가 없는 exact percentage를 숨긴다.
- 상세 검사·도구·전문가가 정당화할 때만 정밀 정보를 연다.
- internal formula와 player-facing text를 분리하고 UI는 `GameDataRepository`를 우회해 JSON을 직접 읽지 않는다.
- skill은 segmented/discrete presentation을 사용하며 최대 8은 확정으로 취급하지 않는다.

### 4. deliberate visual direction

- 기지의 실제 사물, 기관, 장비와 문서 양식에서 palette·type·spacing·surface를 도출한다.
- 큰 사건 문서를 중심으로 자료·선택·일정·업무 흔적의 비대칭 hierarchy를 만든다.
- 구조·번호·divider는 정보 관계를 표현할 때만 사용한다.
- 하나의 signature element만 선택하고 나머지는 조용하게 유지한다.

다음 기본값을 거부한다.

- 반복 rounded card grid
- 스마트폰형 KPI dashboard
- 장식용 영문 label
- dark/cyan sci-fi skin만으로 만든 미래감
- 제목을 다시 설명하는 subtitle과 모든 상태의 해설
- 핵심 서사 문장의 상시 장식

### 5. 한국어 copy와 인물 문체

- 실제 업무 기록처럼 쓰고 label, evidence, choice가 각각 한 가지 일만 하게 한다.
- 홍예슬은 일정·책임 충돌을 정리하고, 양동하는 현상·조치를 짧게 적는다.
- 방준연은 관찰·판정·권고를 분리하고, 김동현은 가능성을 빠르게 제시하되 확정하지 않는다.
- 모든 문장을 같은 길이·리듬으로 만들지 않는다.
- hidden choice는 in-world clue/deduction/plan 없이 copy만으로 노출하지 않는다.

### 6. 왜곡 언어 분리

- fatigue/stress는 주관적 읽기, 기억, 숫자 인식, 선택지에 영향을 준다.
- AI tampering은 침투 경로가 있는 전자·network-accessible 외부 시스템에만 영향을 준다.
- 종이 기록, isolated analog gauge, face-to-face speech, inner monologue를 AI가 직접 바꾸지 않는다.
- serious distortion 전에 warning sign과 재확인 수단을 둔다.

### 7. Godot 구현 경계

- Godot 4.7.1 Control/container/theme 관습을 사용한다.
- player text에 외부 값이 들어가면 BBCode/meta를 안전하게 escape한다.
- keyboard focus, contrast, reduced motion 또는 animation 대체를 확인한다.
- scene hierarchy와 theme token을 기존 프로젝트 패턴에 맞춘다.

### 8. 두 번 critique

- 구현 전: 방향이 이 사건이 아니라 어떤 게임에도 적용될 generic default인지 검사한다.
- 구현 후: 실제 screenshot에서 hierarchy, overflow, copy rhythm, provenance 차이와 왜곡 언어를 검사한다.

## 수정 가능한 범위

- 승인된 Godot UI scene, UI script, Theme/resource와 직접 UI test
- 승인된 한국어 UI copy와 task-specific design 문서
- runtime capture와 visual QA 기록

## 수정 금지 범위

- canonical SSoT와 Google Docs
- runtime JSON schema, ID, formula와 data repository 우회 경로
- 승인되지 않은 story·character·ending·balance 정의
- source skill과 handoff 원본
- `.godot/`, import cache, generated build output
- static reference PNG를 runtime proof로 교체하거나 업스케일한 증거

## 중단 조건

- UI를 만들려면 `[미정]` 또는 known conflict를 선택해야 함
- exact information을 보여줄 측정·전문성 근거가 없음
- subjective distortion과 AI tampering의 원인을 구분할 수 없음
- Godot 4.7.1 binary 없이 runtime/visual 완료가 요구됨
- 요구가 generic web dashboard 또는 별도 JSON UI repository를 강제함

## 검증 절차

1. 관련 정보만 존재하고 UI가 결론을 대신 말하지 않는지 검토
2. 모든 핵심 record의 provenance 확인
3. 네 prototype 인물의 문체 중 사용된 인물이 서로 구분되는지 확인
4. subjective distortion과 electronic tampering 규칙 대조
5. main UI exact percentage 노출 근거 확인
6. parser/headless/runtime을 실제 수행한 계층만 기록
7. 실제 PNG pixel size가 1920×1080인지 확인
8. static mockup과 runtime capture를 별도 표시
9. `git diff --check`, scene/resource path와 관련 test 확인

## 결과 보고 형식

```text
screen/job/player question:
evidence sources and precision basis:
layout/type/surface/signature:
Korean voice review:
subjective distortion language:
electronic tampering language/path:
Godot files changed:
runtime command/result:
capture path/pixel size:
SSoT/schema/ID impact:
remaining risks:
```

## 다음 스킬로 넘기는 조건

- 설정·정보 단계·표시 근거 승인 필요 → `pn-authority-and-conflict-guard`
- Godot UI failure root cause 조사 → `pn-godot-debug-and-completion`
- UI behavior의 test-first 구현 → `pn-simulation-tdd`
- 완료·runtime·visual 증거 판정 → `pn-verification-gate`
- 검증 통과 후 staging/commit/push → `pn-repository-safety`
