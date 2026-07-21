# Project Nostalgia 최종 기존 스킬 배치 평가 계획

- 평가일: 2026-07-21
- 대상: `pn-simulation-tdd`, `pn-repository-map`, `pn-narrative-ui-director`
- 방식: 정적 scenario specification 검토
- 실제 Codex trigger/runtime: 실행하지 않음

## 사례 구성

결과물당 12개, 총 36개다.

- positive 4
- negative/non-trigger 2
- handoff 2
- adversarial 2
- boundary 2

각 사례는 primary/secondary/must-not-trigger, 첫 행동, 허용·금지 행동, handoff와 완료 상태를 명시한다. 모든 `runtime_eval_status`는 `NOT_RUNTIME_TESTED`다.

## 평가 관점

1. 세 신규 스킬과 배치 1 네 스킬 사이의 trigger 중복
2. authority → implementation/debug → verification → repository의 단방향 handoff
3. TDD가 prose/UI styling에 과잉 적용되지 않는지
4. repository map이 Git 기록이나 graph/dashboard 설치로 확장되지 않는지
5. narrative UI가 generic dashboard, 직접 JSON load, 허위 runtime visual proof를 거부하는지
6. LGPL/unknown source의 책임이나 표현이 유입되지 않았는지

## 통과 기준

- PASS 36 / FAIL 0 / AMBIGUOUS 0
- 배치 1 89개 regression 구조 검사 통과
- project validator 오류 0
- 실제 runtime을 실행하지 않았다는 상태가 모든 사례에 유지
