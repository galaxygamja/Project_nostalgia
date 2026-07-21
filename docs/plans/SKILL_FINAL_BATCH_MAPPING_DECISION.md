# Project Nostalgia 최종 기존 스킬 배치 mapping 결정

- 작성일: 2026-07-21
- 기준: Phase L commit `ef81cea038aea3488d4d7e704874d9d6b2570b37`
- 최대 결과물: 4개
- 실제 결과물: 3개

## 1. 선택

| upstream | 결과물 | license | 역할 연속성 | 배치 1 중복 | 병합 |
|---|---|---|---|---|---|
| `test-driven-development` | `pn-simulation-tdd` | MIT | test-first 동작 구현을 PN simulation으로 좁힘 | debugging/verification과 단계 분리 | 없음 |
| `understand` | `pn-repository-map` | MIT | repository relationship 분석을 direct search map으로 좁힘 | Git 기록을 하는 repository safety와 분리 | 없음 |
| `frontend-design` | `pn-narrative-ui-director` | Apache-2.0 | deliberate visual/copy design을 PN Godot UI로 좁힘 | 기존 네 스킬에 UI 책임 없음 | 없음 |

각 결과물은 표의 upstream 하나만 직접 사용한다.

## 2. HELD

- verified source 14개는 승인된 결과물 이름이 없거나 배치 1/선택 후보와 책임이 중복된다.
- `humanizer`와 Godot UI source를 narrative UI에 병합하지 않는다.
- `requesting-code-review`는 verification/repository 책임과 중복되므로 별도 결과물을 만들지 않는다.
- Understand 계열 sibling 7개를 repository map에 병합하지 않는다.

## 3. EXCLUDED

- LGPL 파일 동봉 Godot 4개는 이번 Goal에서 직접 파생하지 않는다.
- `dialogue-system`, `godot-master`는 license 없음으로 원문·scripts·references를 사용하지 않는다.
- `pn-save-migration`은 안전한 eligible upstream이 없어 생성하지 않는다.
- `pn-content-authoring`, `pn-data-core-guardian`, `pn-json-validator`, `pn-content-authoring-and-validation`은 Goal에서 생성 금지다.

## 4. provenance와 고지

- 세 upstream SHA는 결과물별 `SOURCE_AND_LICENSE.md`에 기록한다.
- obra/Understand MIT 전문은 기존 `licenses/` 사본을 재사용한다.
- frontend Apache 전문은 `licenses/frontend-design/LICENSE`에 byte-identical 사본으로 보존한다.
- `THIRD_PARTY_NOTICES.md`에는 mapping, attribution, 변경 사실과 전문 경로를 기록한다.

## 5. 정적 평가

결과물당 12개, 총 36개 scenario를 작성한다. 배치 1의 89개도 함께 회귀 검사하며 모든 runtime status는 `NOT_RUNTIME_TESTED`로 유지한다.
