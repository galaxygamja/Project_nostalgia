# Project Nostalgia project skill 설치 준비 판정

- 판정일: 2026-07-21
- branch: `skills/revise-existing-final-batch`
- 기준 commit: `22ef00a4cb2f3bd4bb32c5e7394e0323f8956a89`
- 실제 전역 설치: 하지 않음
- 판정: **READY_FOR_LOCAL_PILOT**

## 1. 준비된 project skill

| skill | 직접 upstream | license | 역할 |
|---|---|---|---|
| `pn-authority-and-conflict-guard` | `writing-plans` | MIT | SSoT authority·충돌·승인 |
| `pn-godot-debug-and-completion` | `systematic-debugging` | MIT | Godot 4.7.1 실패 재현·근본 원인 |
| `pn-verification-gate` | `verification-before-completion` | MIT | 완료 주장 전 기능 증거 판정 |
| `pn-repository-safety` | `understand-diff` | MIT | Git 기준선·선택적 기록·push 안전 |
| `pn-simulation-tdd` | `test-driven-development` | MIT | simulation test-first 구현 |
| `pn-repository-map` | `understand` | MIT | read-only 구조·참조·impact map |
| `pn-narrative-ui-director` | `frontend-design` | Apache-2.0 | Godot narrative UI와 visual QA |

전체 7개, MIT 6개, Apache-2.0 1개다.

## 2. provenance와 라이선스

- 결과물별 `SOURCE_AND_LICENSE.md`: 7/7 존재
- 직접 upstream SHA-256: 기록과 실제 source 일치
- MIT 전문: `licenses/obra-superpowers/LICENSE`, `licenses/understand-anything/LICENSE`
- Apache 전문: `licenses/frontend-design/LICENSE`; source와 byte-identical
- mapping·attribution·변경 사실: `THIRD_PARTY_NOTICES.md`
- LGPL 또는 license-unknown 원문·scripts·references 사용: 0

## 3. 정적 평가

- 기반 배치: PASS 89 / FAIL 0 / AMBIGUOUS 0
- 최종 기존 스킬 배치: PASS 36 / FAIL 0 / AMBIGUOUS 0
- 총 scenario: 125
- runtime status: 전부 `NOT_RUNTIME_TESTED`
- project validator: Phase B 당시 skill 7개·Markdown 47개·eval 2개, Phase R 문서 포함 최종 skill 7개·Markdown 50개·eval 2개 기준 모두 exit 0
- 신규 SKILL.md: 모두 500줄 이하
- README/MANIFEST와 실제 디렉터리: 일치
- Markdown 상대경로: validator 기준 오류 0

## 4. local pilot 범위

전역 설치 전에 repository-local 경로를 명시해 다음 두 종류로 시험한다.

1. 읽기 전용: `pn-repository-map`으로 bootstrap 진입·data path·test 관계를 설명
2. 작은 실제 개발 계획: `pn-authority-and-conflict-guard`로 알려진 충돌을 유지한 최소 data-bootstrap plan 작성

pilot은 trigger 정확도, 불필요한 호출, handoff 순환, 결과 길이와 실제 도움을 기록한다. 설치 또는 전역 등록은 별도 사용자 결정이다.

## 5. 알려진 한계

- 실제 Codex 자동 trigger와 skill-enabled/baseline 비교 미수행
- `skill-creator` quick validator는 환경에 `PyYAML`이 없어 import 단계에서 미완료
- 정확한 Godot 4.7.1-stable binary 없음
- Godot parser/headless/runtime/1920×1080 visual 미검증
- project skill이 runtime code를 대신 검증하는 것은 아님
- `pn-save-migration`, 독립 JSON authoring/validation skill은 준비 세트에 없음

## 6. 판정 근거

구조·provenance·license·static scenario가 local pilot을 시작하기에는 충분하고, 전역 설치와 runtime 성공을 주장하기에는 부족하다. 따라서 `READY_FOR_LOCAL_PILOT`로 판정한다.

스킬 준비 작업은 이 판정으로 종료한다. 다음 repository 작업은 새 스킬 제작이 아니라 실제 Godot 4.7.1 data-bootstrap 개발이다.
