# Project Nostalgia 스킬 준비 완료 handoff

- 작성일: 2026-07-21
- 완료 branch: `skills/revise-existing-final-batch`
- Phase B 기준 commit: `22ef00a4cb2f3bd4bb32c5e7394e0323f8956a89`
- 상태: 스킬 준비 종료, 실제 Godot 개발 진입

## 0. 2026-07-24 정제 통합 및 제외 스킬 감사 갱신

- 정제 main 기준 commit: `70913e11bbb98263e7452a0828f7b200f0d924de`
- 이 main에는 7개 project skill, provenance/license records, skill plans/reports만 들어 있다.
- `3138faf20df172263e59335410a349a8cdde4b83`는 검증된 원본 및 별도 게임 기준선 후보로 보존했다. SSoT, `game_development/`, runtime JSON, source handoff bundle은 정제 main에 넣지 않았다.
- 제외 source 6개는 첫 bootstrap blocker가 아니다. LGPL 4개는 이번 범위에서 직접 파생하지 않고, `LICENSE_UNKNOWN` 2개는 명시 허가 전 원문·scripts·references를 사용하지 않는다. 상세 결정은 `docs/reports/EXCLUDED_SKILL_FUNCTIONAL_NEEDS_AUDIT.md`와 `docs/plans/EXCLUDED_SKILL_REPLACEMENT_DECISION.md`를 따른다.
- 게임 기준선 통합 Goal는 완료됐다. 실제 구현은 최신 `godot/minimal-data-bootstrap-runtime`에서 별도 Goal로 시작하며, `goal/`은 untracked 사용자 자료로 계속 보존한다.

### 환경 갱신

- 게임 기준선 통합 source: `2a9a42be9fc4c4da0bbc35c6fe96b5128c19e0f7`; `3138faf`와 `game_development/`·SSoT blob이 동일하다.
- 정확한 Godot `4.7.1.stable.official.a13da4feb` binary를 확인했고 import와 기존 headless test를 실행했다.
- 이 Goal는 기준선만 반입했다. runtime JSON 배치와 known validation repair는 다음 구현 Goal의 별도 범위다.
- 전체 종료 상태와 검증 명령은 `docs/reports/DEVELOPMENT_ENVIRONMENT_CLOSURE_REPORT.md`를 정본으로 따른다.

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
- exact Godot 4.7.1 binary: `C:\\Users\\User\\tools\\Godot\\4.7.1-stable\\Godot_v4.7.1-stable_win64.exe` (`4.7.1.stable.official.a13da4feb`)
- default `res://data`: JSON 0개
- candidate JSON: sibling `game_json_templates/`의 20개
- bootstrap architecture: loader → repository → validator → bootstrap 존재
- parser/runtime: import와 기존 headless test는 exit 0으로 확인; candidate 20개를 사용한 read-only smoke는 loader/repository/validator까지 도달해 known validation error 17건·warning 1건을 재현
- known blockers: missing references, IFBO, 100/1000일 wiring, skill model, viewport 차이

다음 작업의 정본 계획은 `docs/plans/REAL_DEVELOPMENT_ENTRY_PLAN.md`다.

## 5. 안전 handoff

- 실제 개발은 `godot/minimal-data-bootstrap-runtime`의 환경 종료 기록 commit에서 계속한다.
- main 직접 수정, PR, force push는 하지 않는다.
- `goal/`은 untracked 사용자 지시 자료로 유지하고 자동 staging하지 않는다.
- exact binary는 확보·검증됐지만, runtime JSON 배치 및 known validation repair는 아직 구현하지 않았다.
- known conflict 하나가 막혀도 안전한 parser/baseline/data mapping evidence는 먼저 checkpoint로 보존한다.
