# Project Nostalgia 최종 기존 스킬 배치 라이선스 eligibility

- 작성일: 2026-07-21
- 근거: `docs/reports/SKILL_LICENSE_REAUDIT.md`
- Phase B 최대 결과물: 4개

## 1. 상태 정의

- `ELIGIBLE`: 라이선스 관문과 승인된 일대일 결과물 이름을 충족
- `HELD`: license 재사용은 가능하지만 승인 이름·역할 연속성·중복 조건을 충족하지 못함
- `EXCLUDED`: 이번 Goal에서 직접 파생 금지 또는 license 없음

배치 1에서 이미 사용한 `writing-plans`, `systematic-debugging`, `verification-before-completion`, `understand-diff`는 이 표의 23개 남은 후보에서 제외한다.

## 2. ELIGIBLE

| priority | upstream | 결과물 | license 분류 | 근거 | 조건 |
|---:|---|---|---|---|---|
| 1 | `test-driven-development` | `pn-simulation-tdd` | MIT / `VERIFIED_DIRECT` | 개별 LICENSE, © 2025 Jesse Vincent | simulation behavior에만 TDD 적용 |
| 2 | `understand` | `pn-repository-map` | MIT / `VERIFIED_BY_EXPLICIT_BUNDLE_SCOPE` | monorepo root LICENSE + package metadata | graph/dashboard 설치 의존 제거, 읽기 전용 map/query/impact |
| 3 | `frontend-design` | `pn-narrative-ui-director` | Apache-2.0 / `VERIFIED_DIRECT` | SKILL frontmatter가 개별 LICENSE를 직접 지정 | 권리자·연도·upstream 미기록 고지, Godot/PN 자료는 프로젝트 규칙으로 독립 추가 |

## 3. HELD

| upstream | 이유 |
|---|---|
| `algorithmic-art`, `canvas-design` | 승인된 결과물 이름이 없고 게임 개발 workflow와 역할 불연속 |
| `baoyu-article-illustrator`, `baoyu-diagram` | 현재 승인된 project skill 결과물 없음 |
| `humanizer` | 독립 결과물 이름이 없고 narrative UI에 병합할 수 없음 |
| `requesting-code-review` | 배치 1 verification/repository 책임과 중복 |
| `skill-creator` | 현재 eval 도구가 이미 독립 구현됐고 승인 결과물 이름 없음 |
| `understand-chat`, `understand-dashboard`, `understand-domain`, `understand-explain`, `understand-figma`, `understand-knowledge`, `understand-onboard` | `pn-repository-map`에 여러 원본을 병합할 수 없으며 별도 승인 결과물 이름 없음 |

HELD 합계는 14개다.

## 4. EXCLUDED

| upstream | 이유 |
|---|---|
| `godot-resource-data-patterns` | LGPL 직접 파생 금지; canonical JSON과 역할 충돌 |
| `godot-save-load-systems` | LGPL 직접 파생 금지; 따라서 `pn-save-migration` 생성 안 함 |
| `godot-state-machine-advanced` | LGPL 직접 파생 금지; 현재 승인 결과물도 없음 |
| `godot-ui-rich-text` | LGPL 직접 파생 금지; narrative UI에 병합하지 않음 |
| `dialogue-system` | `LICENSE_UNKNOWN`; 직접 사용 금지 |
| `godot-master` | `LICENSE_UNKNOWN`; 원문·scripts·references 직접 사용 금지 |

EXCLUDED 합계는 6개다.

## 5. Phase B 선택 상한

eligible 후보는 3개이므로 최대 4개 상한 안에서 세 후보만 mapping 검토 대상으로 넘긴다. 각 후보는 하나의 upstream만 사용하며 서로 또는 배치 1 source를 병합하지 않는다. 모호성이 발견되면 해당 후보만 HELD로 되돌린다.
