# Source and License

- 결과물: `pn-simulation-tdd`
- 직접 원본 스킬: `test-driven-development`
- 원본 경로: `Project_Nostalgia_Codex_Handoff_v0.1/source_skills/Project_nostalgia_Skills_v0.6/test-driven-development/SKILL.md`
- 원본 프로젝트 또는 배포 묶음: `obra/superpowers`로 감사된 로컬 skill bundle
- 라이선스: MIT
- 원본 SHA-256: `B5B4717B8B761CCE15A6CFE9022E33FD959E0894C0C39D72C9CB49C23486C10E`
- 라이선스 사본: `licenses/obra-superpowers/LICENSE`

이 결과물은 원본 하나를 Project Nostalgia simulation 동작에 맞게 축소·수정한 일대일 파생 작업본이다.

## 유지한 핵심 부분

- 실패하는 테스트를 먼저 확인하는 RED–GREEN–REFACTOR
- 한 테스트에 한 행동
- 기대 이유의 실패와 전체 회귀 확인
- production 동작을 검증하고 mock 과사용을 피하는 원칙

## Project Nostalgia용 변경

- TDD 적용 범위를 시간·조건·지연 효과·schedule·save/load·reference 동작으로 제한
- 48 slots/day와 variable duration/absolute slot 규칙 반영
- deterministic distortion과 reload reroll 방지 추가
- authority/debugging/verification/repository 책임 분리

## 저작권 고지

Copyright (c) 2025 Jesse Vincent

MIT permission notice 전문은 `licenses/obra-superpowers/LICENSE`에 있고, attribution과 해당 경로는 `THIRD_PARTY_NOTICES.md`에 기록한다.
