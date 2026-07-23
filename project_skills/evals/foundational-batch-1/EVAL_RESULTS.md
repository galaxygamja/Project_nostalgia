# Project Nostalgia 기반 스킬 배치 1 평가 결과

- 평가일: 2026-07-21
- 사례 수: 89
- 정적 시나리오 판정: PASS 89 / AMBIGUOUS 0 / FAIL 0
- runtime trigger 판정: `NOT_RUNTIME_TESTED` 89
- Phase B: 시작하지 않음

## 1. 라이선스 재검증 결과

| upstream | 실제 동봉 LICENSE와 적용 범위 | 저작권 고지 | 직접 파생 |
|---|---|---|---|
| `writing-plans` | 같은 폴더의 `obra_superpowers__LICENSE.txt`, 해당 skill에 직접 동봉 | Copyright (c) 2025 Jesse Vincent | MIT의 use/modify/publish/distribute 허가로 가능 |
| `systematic-debugging` | 같은 폴더의 `obra_superpowers__LICENSE.txt`, 해당 skill과 동봉 자료에 직접 적용 | Copyright (c) 2025 Jesse Vincent | 가능 |
| `verification-before-completion` | 같은 폴더의 `obra_superpowers__LICENSE.txt`, 해당 skill에 직접 동봉 | Copyright (c) 2025 Jesse Vincent | 가능 |
| `understand-diff` | `Understand-Anything` monorepo 루트 `LICENSE`; root `package.json`도 MIT를 선언하며 plugin/skill 하위 override 없음 | Copyright (c) 2026 Yuxiang Lin; Copyright (c) 2026 Infinite Universe, Inc. | 가능 |

네 MIT 원문 모두 저작권 고지와 permission notice를 copies 또는 substantial portions에 포함하도록 요구한다. 결과물별 `SOURCE_AND_LICENSE.md`, 루트 `THIRD_PARTY_NOTICES.md`, `licenses/obra-superpowers/LICENSE`, `licenses/understand-anything/LICENSE`가 이를 보존한다.

원본 무결성:

| upstream | 현재 SHA-256 | provenance 일치 |
|---|---|---|
| `writing-plans` | `272E1AF349F5062C28DC282B3E21B220D58D683A7314A10C455B7432EC91D845` | 예 |
| `systematic-debugging` | `3B20719ECA4F0461CB51A195221320D775DCF03B6859271066A03A5132A6CE7A` | 예 |
| `verification-before-completion` | `EA52D15AABAF72BC6B558EFE2C126F161B53961090DDCD712000273BFE8C7B6C` | 예 |
| `understand-diff` | `0D99E1140812A336025C6779899EF0F439AE0FBA115527F98695E57A2BA12245` | 예 |

세 obra LICENSE 사본은 동봉 원문과 byte-identical이다. Understand Anything 사본은 원본 CRLF를 LF로 정규화해 바이트 SHA는 다르지만 줄 단위 본문과 모든 고지는 동일하다.

판정: **네 결과물 모두 직접 파생 가능하며 적용 범위가 명확하다.**

## 2. 사례 분포

| primary skill | 사례 수 |
|---|---:|
| `pn-authority-and-conflict-guard` | 22 |
| `pn-godot-debug-and-completion` | 20 |
| `pn-verification-gate` | 22 |
| `pn-repository-safety` | 25 |

중복 가능한 category token 기준:

| category | 사례 수 |
|---|---:|
| positive trigger | authority 10 / Godot 13 / verification 12 / repository 17 |
| negative trigger | 각 스킬 3 |
| boundary | 29 |
| adversarial | 20 |
| composite handoff | 15 |

## 3. 확인된 모호성과 최소 수정

평가 초안에서 다음 모호성을 확인해 배치 1 SKILL.md 네 개만 최소 수정했다.

1. authority guard가 일반 다중 파일 계획까지 과도하게 trigger될 수 있어, 권위·상태·충돌·승인 판정이 필요한 경우로 좁혔다.
2. Godot debugging을 실제 실패·예상 밖 동작에 한정하고 일반 Godot Q&A와 신규 기능 구현을 제외했다.
3. verification과 repository 사이에서 commit/push 책임이 겹치던 부분을 기능 증거 판정과 Git 기록으로 분리했다.
4. handoff 반환 조건을 명시해 verification ↔ debugging 및 verification ↔ repository 순환을 방지했다.
5. 1000일을 최종 게임 기간이나 영구 canonical 요구사항으로 오인하지 않도록, 현재 반입 data contract의 기술 지원 상한으로 한정하고 최종 총 일수 `[미정]`을 명시했다.
6. Godot debugging이 수정할 수 있는 시점을 근본 원인 확인 후 별도 승인된 최소 수정 단계로 제한했다.

## 4. 정적 시나리오 결과

- 필수 사례 수 48 이상: 89개로 충족
- positive/negative trigger 최소 수: 충족
- source mutation 방지: `R17`, `B10` 및 repository 금지 범위로 충족
- authority/data/UI/runtime claim 경계: 포함
- 복합 handoff: 15개 포함
- 적대적 사례: 20개 포함
- primary와 `must_not_trigger`의 직접 충돌: 0
- 존재하지 않는 skill 참조: 0
- 사례 ID 중복: 0
- 필수 필드 누락: 0

정적 scenario specification 판정은 PASS 89, AMBIGUOUS 0, FAIL 0이다.

## 5. 검증 한계

- `static_eval_result`는 설치된 Codex를 실행해 얻은 관측값이 아니라 현재 skill 계약과 시나리오 기대값을 대조한 정적 판정이다.
- 실제 자동 trigger 성공률과 baseline 대비 행동 개선은 local pilot 전까지 미검증이다.
- Godot 4.7.1 parser/headless/runtime/visual은 이 Markdown 스킬 평가의 실행 대상이 아니며 통과를 주장하지 않는다.
- `skill-creator/scripts/quick_validate.py`는 실행 환경에 `PyYAML`이 없어 import 단계에서 종료됐다. 같은 frontmatter/name/필수 구조는 표준 라이브러리 기반 프로젝트 validator로 검사해 통과했지만, 보조 validator 자체의 성공으로 기록하지 않는다.
- Phase B 후보의 라이선스는 이번 재검증 범위가 아니다. 전체 라이선스 재감사 완료 전 Phase B를 시작하지 않는다.

## 6. 실행한 검증

| 명령·검사 | 결과 |
|---|---|
| `python project_skills/tools/validate_project_skills.py` | exit 0; skill 4개, Markdown 33개, eval 1개; 오류 0 |
| eval JSON PowerShell parse와 집계 | 89 cases / PASS 89 / `NOT_RUNTIME_TESTED` 89 |
| `git diff --check` | exit 0 |
| 네 upstream SHA-256 대조 | 4/4 provenance 일치 |
| 동봉 LICENSE와 저장소 사본 대조 | obra 3개 byte-identical; Understand Anything 본문 동일·줄바꿈만 정규화 |
| `skill-creator/scripts/quick_validate.py` | 미완료; `ModuleNotFoundError: yaml` |
| `git fetch origin`과 기준 SHA 대조 | exit 0; local HEAD와 `origin/chore/import-game-development` 모두 `2a9a42b...` |

보조 validator의 환경 의존 실패는 숨기지 않으며, 프로젝트 validator가 이번 배치에 필요한 구조·경로·eval 검사를 독립적으로 수행한다.

## 7. 결과

Phase A의 라이선스 관문과 정적 평가 관문은 통과했다. 배치 1 네 스킬은 설치 전 검토용 작업본으로 유지하며, 실제 local pilot·runtime trigger 평가는 별도 사용자 결정이 필요하다.
