# Source and License

- 결과물: `pn-godot-debug-and-completion`
- 직접 원본 스킬: `systematic-debugging`
- 원본 경로: `Project_Nostalgia_Codex_Handoff_v0.1/source_skills/Project_nostalgia_Skills_v0.6/systematic-debugging/SKILL.md`
- 원본 프로젝트 또는 배포 묶음: `obra/superpowers`로 감사된 로컬 skill bundle
- 라이선스: MIT
- 원본 SHA-256: `3B20719ECA4F0461CB51A195221320D775DCF03B6859271066A03A5132A6CE7A`
- 라이선스 사본: `licenses/obra-superpowers/LICENSE`

이 파일과 동봉 `SKILL.md`는 원본을 Project Nostalgia 전용으로 수정한 파생 작업본이다.

## 유지한 핵심 부분

- 수정 전 root-cause 조사
- 일관된 재현과 전체 오류 읽기
- working/broken pattern 비교
- 한 번에 하나의 구체적 가설과 최소 검증
- 세 번 이상 실패하면 architecture를 재검토하는 중단 gate

## 제거·축소한 부분

- 일반 CI/signing 예제와 범용 rationalization 목록
- 원본 부속 reference 직접 의존
- 다른 `superpowers:*` 스킬 호출 지시
- Project Nostalgia와 무관한 운영 사례와 성과 수치

## Project Nostalgia용 추가

- Godot 4.7.1-stable version gate
- parser/project load/runtime/visual 검증 계층
- loader → repository → validator → bootstrap 경계 추적
- 미완성 프로젝트와 canonical architecture 비교
- known conflicts 및 1000일 지원 상한 해석
- 누락 JSON/reference 임의 생성 및 원본 자동 변환 금지

## 저작권 고지

Copyright (c) 2025 Jesse Vincent

MIT permission notice 전문은 `licenses/obra-superpowers/LICENSE`에 있고, attribution과 해당 경로는 저장소 루트 `THIRD_PARTY_NOTICES.md`에 기록한다.
