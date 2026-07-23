# Source skill 라이선스 재감사 차이 보고서

- 비교 대상: `docs/reports/SKILL_LICENSE_AUDIT.md`
- 재감사 기준일: 2026-07-21

## 1. 변경된 기존 판정

| 대상 | 기존 기록 | 재감사 결과 | 영향 |
|---|---|---|---|
| `algorithmic-art` | 권리자·연도 불명 | LICENSE 끝에서 `Copyright 2026 Anthropic, PBC.` 확인 | attribution 정정 |
| `canvas-design` | 권리자·연도 불명 | 동일 Anthropic 2026 고지 확인 | attribution 정정 |
| `skill-creator` | 권리자·연도 불명 | 동일 Anthropic 2026 고지 확인 | attribution 정정; frontmatter license 필드 부재는 별도 기록 |
| Godot 4개 | LGPL-3.0 적용을 사실상 확정 | 동일 LGPL 표준문은 있으나 skill 권리자·upstream·명시적 적용 선언 없음 | 이번 Goal에서는 `EXCLUDED`; 법적 scope를 확대 확정하지 않음 |
| `dialogue-system`, `godot-master` | 확인 불가·보류 | `LICENSE_UNKNOWN` | 직접 사용 금지 유지 |

라이선스 본문 수량 MIT 17 / Apache-2.0 4 / LGPL 파일 동봉 4 / 없음 2는 바뀌지 않았다. “공개 포함 가능 25개”와 “PN 수정본 가능 25개”라는 과거 표현은 LGPL scope와 이번 Goal 정책을 섞으므로 폐기한다.

## 2. 문서·구조 차이

- 과거 권장 구조 `third_party/LICENSES/NOTICE.md/SOURCE.md`는 실제 `licenses/`, `THIRD_PARTY_NOTICES.md`, `SOURCE_AND_LICENSE.md`로 정규화됐다.
- `SKILL_INVENTORY.md`의 canonical SSoT와 Git 부재 설명은 현재 상태에서 stale이다. 이 문서는 역사적 인벤토리로 유지하고 현재 판정은 재감사 문서가 대체한다.
- unknown source에서 아이디어나 refs를 추출한다는 과거 권고는 폐기한다. 필요한 PN 절차는 SSoT와 프로젝트 자료에서 독립 작성한다.
- 배치 1 provenance 문서가 `THIRD_PARTY_NOTICES.md`에도 MIT 전문이 있다고 표현하지만, 실제 전문은 `licenses/*/LICENSE`에 있다. Phase B의 project skill 문서 갱신 시 문구를 바로잡는다.

## 3. Phase B 영향

- `pn-simulation-tdd`: eligible
- `pn-repository-map`: eligible
- `pn-narrative-ui-director`: eligible, 단 frontend 권리자·upstream 미기록을 provenance에 그대로 표시
- `pn-save-migration`: 이번 Goal에서 제외
- 독립 JSON authoring/validation skill: 생성 금지 유지

## 4. 변경하지 않은 영역

source skill, handoff 원본, `project_skills/`, `THIRD_PARTY_NOTICES.md`, `licenses/`, `game_development/`, `docs/ssot/`는 Phase L에서 수정하지 않는다.
