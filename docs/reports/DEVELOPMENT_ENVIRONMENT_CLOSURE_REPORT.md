# Project Nostalgia 개발 환경 종료 기록

- 기록일: 2026-07-24
- 상태: 다음 실제 개발 Goal 시작 가능 — known baseline issues는 별도 범위로 유지
- 개발 branch: `godot/minimal-data-bootstrap-runtime`
- 이 기록의 기준 main: `ec187f14d77e84429e3cd29aeac12af167ffc39b`

## 완료한 준비 작업

| 항목 | 결과 |
| --- | --- |
| 스킬 정제 통합 | `b95f5c1` → `70913e1`; 7개 project skill, provenance/license, 관련 계획·보고서만 반입 |
| 제외 스킬 감사 | `5dfa393`; LGPL 4개 및 `LICENSE_UNKNOWN` 2개를 직접 파생하지 않는 대체·재검토 경로 기록 |
| 게임 기준선 통합 | `ec187f1`; import commit `2a9a42be9fc4c4da0bbc35c6fe96b5128c19e0f7`의 allowlisted source 92개 blob을 exact 검증 후 반입 |
| Godot 환경 | `4.7.1.stable.official.a13da4feb` portable executable 확보·실행 확인 |

게임 source는 `2a9a42be`와 보존된 `3138faf20df172263e59335410a349a8cdde4b83`에서 `game_development/` 및 SSoT blob이 동일함을 확인했다. 기준선 통합 commit은 source와 byte-identical하며, source 이외에는 provenance·allowlist·format/runtime 보고서만 추가했다.

## 확정된 실행 환경과 실제 검증

- executable: `C:\Users\User\tools\Godot\4.7.1-stable\Godot_v4.7.1-stable_win64.exe`
- version: `4.7.1.stable.official.a13da4feb`
- executable SHA-256: `323F9C4CC5DB674E98815CDD8E69DA007D5EFC779ABEDC8C0E42883B7FDEA12A`
- archive SHA-256: `C7A289051EAEFB460B0106B60E9CD5BEE0EF55FD102DCB2BED1EB356CF3D90A1`
- Authenticode: valid; signer `Prehensile Tales B.V.`

다음은 실제로 실행해 exit code 0을 확인한 기준선 명령이다.

```powershell
<godot> --headless --path game_development/godot_data_core --editor --quit
<godot> --headless --path game_development/godot_data_core --script res://tests/runtime_core_test.gd
<godot> --headless --path game_development/godot_data_core --script res://tests/game_loop_v1_test.gd
```

또한 sibling `game_json_templates/`의 non-template JSON 20개를 읽기 전용으로 사용한 smoke에서 20개 문서 load, 28개 definition registration, validator error 17건과 warning 1건을 관측했다. 이는 runtime JSON을 `res://data`에 배치하거나 validator 오류를 해결했다는 뜻이 아니다.

## 의도적으로 남긴 기준선 예외와 다음 범위

- `res://data`에는 JSON이 0개다. candidate 20개 배치와 manifest/copy는 다음 구현 Goal의 D2 범위다.
- missing reference, IFBO 의미, item knowledge, skill model, 100/1000-day wiring, 900×540 viewport는 해결하지 않았다.
- 기존 trailing whitespace는 346건(SSoT 343, audit 3)이며, 기준선 예외로만 기록했다. 대량 정정은 하지 않았다.
- `.godot/`와 import-generated `.uid`는 검증 중 생성됐으나 삭제했고 commit하지 않았다.
- SSoT, runtime JSON, source/handoff 원본, `goal/`에는 변경을 가하지 않았다.

실제 개발은 `docs/plans/REAL_DEVELOPMENT_ENTRY_PLAN.md`의 D0–D5를 최신 개발 branch에서 실행한다. 해당 계획의 과거 binary 부재 문구는 이 기록과 `DEVELOPMENT_ENVIRONMENT_HANDOFF.md`의 검증 결과로 대체한다.

## Git 보존 상태

- `main`, `integration/verified-game-baseline`, 개발 branch의 기준선 SHA: `ec187f14d77e84429e3cd29aeac12af167ffc39b`
- skill 통합 전 backup: `backup/main-before-skill-preparation-integration-20260724-012406` → `b95f5c1`
- 게임 기준선 통합 전 backup: `backup/main-before-verified-game-baseline-20260724-015558` → `5dfa393`
- force push, PR, reset, 전체 공백 정정은 수행하지 않았다.

이 종료 기록 commit은 개발 branch에만 추가한다. `main`은 검증된 기준선 commit에 그대로 둔다.
