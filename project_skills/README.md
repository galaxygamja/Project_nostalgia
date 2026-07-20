# Project Nostalgia Project Skills

이 폴더는 라이선스가 확인된 source skill을 Project Nostalgia의 authority, Godot 4.7.1, 검증 및 Git 안전 규칙에 맞게 축소·개편한 **검토용 작업본**이다.

- `Project_Nostalgia_Codex_Handoff_v0.1/source_skills/` 아래 자료는 보존해야 하는 원본이며 직접 수정하지 않는다.
- 현재 범위는 **개편 배치 1**이다.
- 이 폴더의 스킬은 아직 Claude Code/Codex 또는 다른 agent 환경에 설치하거나 전역 등록하지 않았다.
- 설치 전 내용, trigger, 권한 범위와 라이선스 고지를 검토해야 한다.
- Godot 4.7.1-stable binary가 확인되지 않아 Godot parser/headless/runtime 검증은 미완료다.

## 배치 1 스킬

1. `pn-authority-and-conflict-guard` — SSoT 상태·충돌·승인 gate와 변경 계획
2. `pn-godot-debug-and-completion` — Godot 4.7.1 오류의 재현·근본 원인 조사
3. `pn-verification-gate` — 완료 주장 전 신선한 증거 확인
4. `pn-repository-safety` — branch/status/diff/staging/push 안전 절차

각 결과물은 하나의 승인된 MIT upstream과 일대일 대응한다. 다른 source skill의 문구나 파일을 병합하지 않았다.

## 제외 및 보류

- 라이선스 불명으로 제외: `dialogue-system`, `godot-master`
- 배치 1 직접 사용 금지: LGPL-3.0 Godot 스킬 4개
- JSON 작성 `pn-content-authoring`과 JSON 검증 `pn-data-core-guardian`은 분리된 독립 프로젝트 스킬 후보로 다음 배치 이후에 보류한다.
- `pn-simulation-tdd`, `pn-narrative-ui-director`, `pn-save-migration`, `pn-repository-map`도 이번 배치에 포함하지 않았다.

저작권 및 라이선스 정보는 각 스킬의 `SOURCE_AND_LICENSE.md`, 루트 `THIRD_PARTY_NOTICES.md`, `licenses/`를 확인한다.
