# 제외 스킬 대체 결정

- 결정일: 2026-07-24
- 근거: `docs/reports/EXCLUDED_SKILL_FUNCTIONAL_NEEDS_AUDIT.md`
- 상태: 현재 개발 진입에는 추가 source skill을 설치하거나 파생하지 않는다.

## 공통 규칙

1. 여섯 source는 첫 Godot bootstrap의 blocker가 아니다.
2. LGPL 4개는 이번 범위에서 직접 파생하지 않는다. `LICENSE_UNKNOWN` 2개는 명시 허가 확인 전 원문·scripts·references를 사용하지 않는다.
3. 기능이 필요해지면 project SSoT, canonical JSON data core, 승인된 요구사항만으로 clean-room 사양·테스트를 작성한다. 외부 permissive 대체물은 source, license, notice, dependency 조건을 별도 검증한다.
4. 이 결정은 라이선스의 최종 법률적 결론이 아니며, 현재 source evidence에 근거한 프로젝트 작업 경계다.

| 대상 | 현재 결정 | 대체/후속 경로 | 시작 금지선 | 재검토 trigger |
|---|---|---|---|---|
| `godot-resource-data-patterns` | 제외 유지 | canonical JSON을 유지한 runtime-only helper를 독립 설계 | Resource DB·`.tres`를 definition data의 병렬 기준으로 만들지 않음 | ownership/cache 요구와 architecture approval |
| `godot-save-load-systems` | 제외 유지 | approved save schema 후 clean-room save/migration design | save 예제·migration 표현을 복사하지 않음 | mutable state boundary와 migration policy approval |
| `godot-state-machine-advanced` | 제외 유지 | project-specific state table/invariants/tests부터 작성 | HSM scripts·stack/context 패턴을 복사하지 않음 | complex nested/interrupt behavior가 명시 전이를 초과 |
| `godot-ui-rich-text` | 제외 유지 | PN document UI requirements에 맞춘 safe RichText implementation | supplied BBCode/effect/controller를 복사하지 않음 | actual evidence UI task와 accessibility contract approval |
| `dialogue-system` | 제외 유지 | encounter/task/clue/deduction JSON mapping을 독립 작성 | DialogueData/Manager, executable condition strings, references 사용 금지 | structured canonical model의 검증된 기능 gap |
| `godot-master` | 제외 유지 | official Godot docs와 project-local minimal design을 우선 | bundle scripts/references를 참조·복사하지 않음 | specific subsystem gap와 source-independent design need |

## 개발 순서 영향

`godot/minimal-data-bootstrap-runtime`은 스킬 대체를 시작하는 branch가 아니다. 먼저 별도 승인된 게임 기준선 통합 Goal가 `3138faf20df172263e59335410a349a8cdde4b83`의 `game_development/` 및 관련 자료를 정제 main에 반입할지 검토해야 한다. 그 전에는 이 문서의 결정을 근거로 게임 파일·runtime JSON·SSoT를 변경하지 않는다.
