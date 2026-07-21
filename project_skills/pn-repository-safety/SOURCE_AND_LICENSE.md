# Source and License

- 결과물: `pn-repository-safety`
- 직접 원본 스킬: `understand-diff`
- 원본 경로: `Project_Nostalgia_Codex_Handoff_v0.1/source_skills/Project_nostalgia_Skills_v0.6/understand-anything/Understand-Anything/understand-anything-plugin/skills/understand-diff/SKILL.md`
- 원본 프로젝트 또는 배포 묶음: `Egonex-AI/Understand-Anything`로 감사된 로컬 monorepo bundle
- 라이선스: MIT
- 원본 SHA-256: `0D99E1140812A336025C6779899EF0F439AE0FBA115527F98695E57A2BA12245`
- 라이선스 사본: `licenses/understand-anything/LICENSE`

이 파일과 동봉 `SKILL.md`는 원본을 Project Nostalgia 전용으로 수정한 파생 작업본이다.

## 유지한 핵심 부분

- 변경 파일 목록을 먼저 확인
- 기준 commit과 현재 repository freshness 비교
- committed/working/staged/untracked 상태 분리
- changed components, affected scope와 risk를 구조적으로 보고
- 불완전한 metadata에서도 사실에 맞는 best-effort 상태 보고

## 제거·축소한 부분

- `.ua`/`.understand-anything` knowledge graph 필수 의존
- graph node/edge/layer 탐색
- `diff-overlay.json` 생성과 dashboard 실행
- Node/pnpm/plugin 설치 및 네트워크 의존

## Project Nostalgia용 추가

- fetch/branch/remote/upstream/base commit gate
- 별도 branch 및 non-force push
- allowlist 기반 selective staging
- untracked source snapshot·`game_development/`·`.godot/` 보호
- staged diff, secret, large-file 검사
- commit/push SHA와 종료 working tree 확인

## 저작권 고지

Copyright (c) 2026 Yuxiang Lin

Copyright (c) 2026 Infinite Universe, Inc.

MIT permission notice 전문은 `licenses/understand-anything/LICENSE`에 있고, attribution과 해당 경로는 저장소 루트 `THIRD_PARTY_NOTICES.md`에 기록한다.
