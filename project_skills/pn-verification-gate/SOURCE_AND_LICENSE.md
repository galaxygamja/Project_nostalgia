# Source and License

- 결과물: `pn-verification-gate`
- 직접 원본 스킬: `verification-before-completion`
- 원본 경로: `Project_Nostalgia_Codex_Handoff_v0.1/source_skills/Project_nostalgia_Skills_v0.6/verification-before-completion/SKILL.md`
- 원본 프로젝트 또는 배포 묶음: `obra/superpowers`로 감사된 로컬 skill bundle
- 라이선스: MIT
- 원본 SHA-256: `EA52D15AABAF72BC6B558EFE2C126F161B53961090DDCD712000273BFE8C7B6C`
- 라이선스 사본: `licenses/obra-superpowers/LICENSE`

이 파일과 동봉 `SKILL.md`는 원본을 Project Nostalgia 전용으로 수정한 파생 작업본이다.

## 유지한 핵심 부분

- evidence before claims
- 주장별 직접 검증 명령 식별
- fresh/full command 실행과 전체 출력·exit code 확인
- 부분 검사를 전체 성공으로 일반화하지 않음
- commit 및 완료 보고 전 gate 적용

## 제거·축소한 부분

- 범용 rationalization/실패 사례와 감정적 표현
- 특정 agent delegation 예시
- Project Nostalgia와 무관한 build/linter 예시 반복

## Project Nostalgia용 추가

- 완료/부분 완료/차단됨 상태
- Godot parser/headless/runtime/visual 계층
- JSON parse/envelope/schema/ID/reference/integration 계층
- working/staged/commit/push 증거 분리
- source hash와 금지 경로 불변성
- 누락 참조·known conflict 자동 수정 금지

## 저작권 고지

Copyright (c) 2025 Jesse Vincent

MIT permission notice 전문은 `licenses/obra-superpowers/LICENSE`에 있고, attribution과 해당 경로는 저장소 루트 `THIRD_PARTY_NOTICES.md`에 기록한다.
