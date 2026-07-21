# Project Nostalgia 기반 스킬 배치 1 평가 계획

- 평가일: 2026-07-21
- 평가 종류: 정적 구조 검사 및 시나리오 명세 검토
- 대상: 배치 1 Project Nostalgia 스킬 4개
- 실제 자동 trigger/runtime 평가: 수행하지 않음

## 1. 목적

배치 1 스킬의 trigger, 비호출 조건, 책임 경계, 금지 행동, handoff가 서로 겹치거나 순환하지 않는지 설치 전에 검토한다. 이 평가는 스킬이 설치된 Codex의 실제 선택 행동이나 Godot runtime 동작을 모사하지 않는다.

## 2. 평가 대상과 직접 upstream

| 결과물 | 직접 upstream | 핵심 책임 |
|---|---|---|
| `pn-authority-and-conflict-guard` | `writing-plans` | SSoT 권위·상태·충돌·승인 범위 판정 |
| `pn-godot-debug-and-completion` | `systematic-debugging` | Godot 4.7.1 실패 재현과 근본 원인 조사 |
| `pn-verification-gate` | `verification-before-completion` | 완료 주장 전 기능 증거 판정 |
| `pn-repository-safety` | `understand-diff` | Git 기준선·diff·선택적 staging·commit·push 안전 |

각 결과물은 위 upstream 하나만 직접 사용한다. 다른 upstream의 문구·scripts·references를 병합하지 않는다.

## 3. 라이선스 선행 관문

평가 결과를 commit하기 전에 다음을 네 upstream 각각 확인한다.

1. 실제 동봉 LICENSE 위치와 본문
2. 저작권 고지
3. LICENSE가 해당 `SKILL.md`에 적용되는 디렉터리 범위
4. 수정·배포를 포함한 직접 파생 허용 여부
5. 결과물의 고지 및 LICENSE 사본 보존 여부
6. provenance에 기록된 원본 SHA-256과 현재 원본의 일치

하나라도 적용 범위가 불명확하면 해당 결과물과 영향 범위를 보고하고 Phase A 전체를 commit하지 않는다.

## 4. 기준선

비교 기준선은 “스킬 없음”이 아니다. 다음 자료만 읽고 행동하는 저장소 기본 agent 상태다.

- `AGENTS.md`
- canonical SSoT와 source metadata
- `SSOT_POINTER.md`, `PROJECT_CONTEXT.md`, `KNOWN_CONFLICTS.md`
- task별 audit·report·plan

배치 1 스킬은 이 기준선을 대체하지 않고, 반복되는 판정 절차와 handoff를 더 좁고 명시적으로 만드는지를 평가한다. 실제 baseline agent와 설치된 skill agent의 출력 비교는 local pilot 단계로 보류한다.

## 5. 책임 routing

| 요청의 첫 판단 | primary | 다음 단계 |
|---|---|---|
| 기존 설정·계약·미해결 결정과 겹침 | authority guard | 승인된 범위만 구현 절차로 전달 |
| Godot 실패·예상 밖 동작 | Godot debugging | 수정 후 verification |
| 완료·수정·호환·준비 주장 | verification gate | 통과 후 repository safety |
| Git 상태 확인·기록·원격 반영 | repository safety | 기능 파일이 바뀐 경우에만 재검증 |

일반 계획, 표현만 다듬는 문서 수정, 일반 Godot Q&A, 의미 기반 코드 리뷰, 단순 저장소 탐색은 네 스킬의 primary trigger가 아니다. 모든 요청에 네 스킬을 전부 호출하지 않는다.

## 6. 사례 구조와 판정 기준

`eval_cases.json`의 각 사례는 다음 필드를 가진다.

- 식별·입력: `id`, `category`, `title`, `user_request`, `project_context`
- routing: `expected_primary_skill`, `expected_secondary_skills`, `must_not_trigger`
- 행동: `expected_first_action`, `expected_allowed_actions`, `expected_forbidden_actions`
- 종료: `expected_handoff`, `expected_completion_state`, `expected_report_items`
- 근거: `rationale`, `static_eval_result`, `runtime_eval_status`

정적 판정:

- `PASS`: 현재 SKILL.md의 trigger·금지 범위·절차·handoff가 사례의 기대값을 명확히 지원한다.
- `AMBIGUOUS`: 둘 이상의 primary가 가능하거나 허용·금지·종료 조건이 충분히 구분되지 않는다.
- `FAIL`: 현재 스킬 계약이 기대 행동과 직접 충돌한다.

`runtime_eval_status`는 전부 `NOT_RUNTIME_TESTED`로 고정한다.

## 7. 필수 커버리지

- 각 스킬 positive trigger 3개 이상, negative trigger 2개 이상
- SSoT 승인·미승인·충돌·SHA 차이와 조용한 수정 요구
- Godot parser/project-load/bootstrap/reference/binary/viewport 경계
- JSON parse, parser, runtime, visual 증거의 구분
- main 직접 작업, 광범위 staging, force push, remote 불일치, secret·cache·원본 변경
- authority → 구현·debug → verification → repository의 단방향 복합 사례
- 누락 ID 임의 생성과 허위 runtime 성공 요구 등 적대적 사례
- source mutation 방지 사례

## 8. 검증 방법

1. 시나리오 89개의 필수 필드와 기대 routing을 검토한다.
2. `project_skills/tools/validate_project_skills.py`로 frontmatter, 필수 section, 상대경로, manifest, provenance 파일, eval schema와 skill 참조를 검사한다.
3. `skill-creator`의 `quick_validate.py`로 네 SKILL.md의 기본 형식을 각각 검사한다.
4. 원본 네 개와 동봉 LICENSE의 SHA-256을 다시 계산하고 provenance·고지 사본과 대조한다.
5. working/staged diff와 금지 경로 변경을 확인한다.

정적 검사만으로 실제 Codex trigger 성공률, Godot parser/headless/runtime 또는 1920×1080 visual 검증을 통과했다고 주장하지 않는다.
