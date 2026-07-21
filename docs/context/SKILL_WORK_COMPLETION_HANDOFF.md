# Project Nostalgia 스킬 준비 완료 handoff

- 작성일: 2026-07-21
- 완료 branch: `skills/revise-existing-final-batch`
- Phase B 기준 commit: `22ef00a4cb2f3bd4bb32c5e7394e0323f8956a89`
- 상태: 스킬 준비 종료, 실제 Godot 개발 진입

## 1. 완료된 checkpoint

- Phase A: 기반 스킬 4개와 89 scenario, 원격 보존
- Phase L: source skill 27개 라이선스·provenance 재감사, 원격 보존
- Phase B: eligible 3개 일대일 개편과 36 scenario, 원격 보존
- 전체 project skill: 7개
- 전체 정적 scenario: 125개
- SSoT/schema/ID/Godot/runtime JSON 변경: 없음

## 2. 준비 세트 사용 순서

1. authority·known conflict → `pn-authority-and-conflict-guard`
2. 구조·참조·impact 조사 → `pn-repository-map`
3. Godot failure root cause → `pn-godot-debug-and-completion`
4. simulation behavior 구현 → `pn-simulation-tdd`
5. narrative UI → `pn-narrative-ui-director`
6. 기능 증거 판정 → `pn-verification-gate`
7. selective Git 기록·push → `pn-repository-safety`

모든 요청에 일곱 스킬을 전부 호출하지 않는다.

## 3. 명시적으로 종료한 후보

- `pn-save-migration`: 이번 Goal에서 생성 안 함
- 독립 JSON authoring/validation skill: 생성 안 함
- LGPL/unknown source 파생: 없음
- 추가 existing-source skill revision: 종료
- 전역 설치: 하지 않음

새 스킬 제작보다 실제 개발을 우선한다. 새로운 반복 workflow가 실제 개발 중 증명되기 전에는 skill scope를 다시 넓히지 않는다.

## 4. 다음 개발 상태

- Godot project: `game_development/godot_data_core/`
- exact Godot 4.7.1 binary: 현재 없음
- default `res://data`: JSON 0개
- candidate JSON: sibling `game_json_templates/`의 20개
- bootstrap architecture: loader → repository → validator → bootstrap 존재
- parser/runtime: 미검증
- known blockers: missing references, IFBO, 100/1000일 wiring, skill model, viewport 차이

다음 작업의 정본 계획은 `docs/plans/REAL_DEVELOPMENT_ENTRY_PLAN.md`다.

## 5. 안전 handoff

- 새 개발 branch는 이 branch의 Phase R 최종 원격 HEAD에서 만든다.
- main 직접 수정, PR, force push는 하지 않는다.
- `goal/`은 untracked 사용자 지시 자료로 유지하고 자동 staging하지 않는다.
- exact binary가 없으면 D0에서 중단하고 runtime success를 주장하지 않는다.
- known conflict 하나가 막혀도 안전한 parser/baseline/data mapping evidence는 먼저 checkpoint로 보존한다.
