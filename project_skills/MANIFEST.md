# Project Skills Manifest — Prepared Local Set

| 결과물 | 직접 upstream | 원본 경로 | 라이선스 | 일대일 매핑 | 조치 | 정적 검증 | runtime 검증 | 남은 차단 조건 |
|---|---|---|---|---|---|---|---|---|
| `pn-authority-and-conflict-guard` | `writing-plans` | `Project_Nostalgia_Codex_Handoff_v0.1/source_skills/Project_nostalgia_Skills_v0.6/writing-plans/SKILL.md` | MIT | 예 | 계획 절차를 authority/conflict gate로 축소·개편 | 완료 | 해당 없음 | 승인되지 않은 충돌은 계속 차단 |
| `pn-godot-debug-and-completion` | `systematic-debugging` | `Project_Nostalgia_Codex_Handoff_v0.1/source_skills/Project_nostalgia_Skills_v0.6/systematic-debugging/SKILL.md` | MIT | 예 | 근본 원인 절차를 Godot 4.7.1/data-core 조사에 맞게 개편 | 완료 | 미검증 | 정확한 Godot 4.7.1-stable binary 필요 |
| `pn-verification-gate` | `verification-before-completion` | `Project_Nostalgia_Codex_Handoff_v0.1/source_skills/Project_nostalgia_Skills_v0.6/verification-before-completion/SKILL.md` | MIT | 예 | evidence-before-claims gate를 PN 검증 계층에 맞게 개편 | 완료 | 미검증 | 작업별 실제 검증 환경 필요 |
| `pn-repository-safety` | `understand-diff` | `Project_Nostalgia_Codex_Handoff_v0.1/source_skills/Project_nostalgia_Skills_v0.6/understand-anything/Understand-Anything/understand-anything-plugin/skills/understand-diff/SKILL.md` | MIT | 예 | diff 분석을 독립적인 Git 안전 절차로 축소·개편 | 완료 | 해당 없음 | remote 인증·동기화 상태는 작업마다 확인 |
| `pn-simulation-tdd` | `test-driven-development` | `Project_Nostalgia_Codex_Handoff_v0.1/source_skills/Project_nostalgia_Skills_v0.6/test-driven-development/SKILL.md` | MIT | 예 | simulation 고위험 동작의 RED–GREEN–REFACTOR | 완료 | 미검증 | 실제 Godot 4.7.1 test runner 필요 |
| `pn-repository-map` | `understand` | `Project_Nostalgia_Codex_Handoff_v0.1/source_skills/Project_nostalgia_Skills_v0.6/understand-anything/Understand-Anything/understand-anything-plugin/skills/understand/SKILL.md` | MIT | 예 | graph/plugin을 제거한 direct-search read-only map | 완료 | 해당 없음 | 실제 저장소 task local pilot 필요 |
| `pn-narrative-ui-director` | `frontend-design` | `Project_Nostalgia_Codex_Handoff_v0.1/source_skills/Project_nostalgia_Skills_v0.6/frontend-design/SKILL.md` | Apache-2.0 | 예 | deliberate design을 Godot narrative UI로 개편 | 완료 | 미검증 | Godot 4.7.1과 1920×1080 runtime capture 필요 |

## 보류

- `pn-content-authoring`: 대응하는 MIT/Apache source가 없어 독립 작성 후보
- `pn-data-core-guardian`: 대응하는 MIT/Apache source가 없어 독립 작성 후보
- `pn-save-migration`: 이번 Goal의 LGPL 직접 파생 금지로 생성하지 않음
- 나머지 verified source: 승인 결과물 이름 부재 또는 기존 책임과 중복

정적 검증 세부 결과는 `docs/reports/SKILL_REVISION_BATCH_1_REPORT.md`와 `docs/reports/SKILL_REVISION_FINAL_BATCH_REPORT.md`에 기록한다.
