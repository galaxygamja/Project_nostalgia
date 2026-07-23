# 제외 스킬 기능 필요성 감사

- 감사일: 2026-07-24
- 기준: 보존 snapshot `3138faf20df172263e59335410a349a8cdde4b83`, 정제 main `70913e11bbb98263e7452a0828f7b200f0d924de`
- 범위: 직접 파생에서 제외한 6개 source skill의 기능 필요성 및 대체 경로
- 방법: 읽기 전용으로 SSoT, `game_development/godot_data_core/`, 현재 7개 project skill, 기존 라이선스 재감사·개발 계획을 대조했다. source bundle, SSoT, 게임 기준선은 수정하지 않았다.

## 결론

첫 Godot bootstrap의 범위는 20개 JSON을 canonical `res://data`로 연결하고 `GameJsonLoader → GameDataRepository → GameDataValidator → GameDataBootstrap` 결과를 관측하는 일이다. 여섯 source 모두 이 단계의 차단 요인이 아니다. 현재 실제 차단은 정확한 Godot 4.7.1 binary, JSON 입력 연결, 그리고 관측될 validator 오류이며, 제외 source의 부재가 아니다.

현재 7개 project skill은 권위·조사·검증·TDD·UI 방향을 다룬다. 저장 스키마, HSM, RichText 구현, 대화 runtime을 제공하지는 않으며, 그 기능 공백은 필요성이 실증되고 별도 승인된 Goal에서만 독립 설계로 다룬다.

| 대상 source | source / 라이선스 상태 | 대응 기능과 필요 시점 | 첫 bootstrap 차단 | 현재 7개 대응 | 최종 결정·후속 행동 | 재검토 조건 |
|---|---|---|---|---|---|---|
| `godot-resource-data-patterns` | `Godot Resource Data Patterns/SKILL.md`; LGPL-3.0 표준문 동봉, 적용 연결·권리자·upstream 불충분 | Resource/RefCounted, `.tres`, inventory·stats·serialization. 현 core의 definition data는 canonical JSON이므로 대체하면 충돌한다. runtime-only transient ownership/cache 필요가 생길 때 | 아니오 | debug/TDD는 조사·검증만 지원 | 직접 채택하지 않는다. JSON envelope·repository를 유지하고 필요 시 독립 설계 | JSON을 대체하지 않는 runtime-only 요구와 canonical 경계 영향이 승인됨 |
| `godot-save-load-systems` | `godot-save-load-systems/SKILL.md`; 동일 LGPL 상태 | versioned save, migration, 손상 save recovery. mutable state와 save schema가 승인된 뒤 | 아니오 | `pn-simulation-tdd`, verification은 향후 test/evidence만 지원 | 별도 save Goal에서 clean-room 설계 또는 검증된 permissive 대체 검토 | definition/state 분리와 versioned save schema가 승인됨 |
| `godot-state-machine-advanced` | `godot-state-machine-advanced/SKILL.md`; 동일 LGPL 상태 | HSM/pushdown character·AI behavior. 현재 loop는 명시 enum 전이로 충분하며, 복합 중첩·interrupt 요구가 생길 때 | 아니오 | TDD/debug가 전이 검증을 지원 | 설치하지 않는다. 상태 목록·전이표·invariant부터 독립 작성 | enum+명시 전이로 해결되지 않는 복합 behavior 요구가 확인됨 |
| `godot-ui-rich-text` | `godot-ui-rich-text/SKILL.md`; 동일 LGPL 상태 | RichTextLabel, BBCode, meta interaction. D4 smoke 화면 이후 실제 문서·증거 UI 단계 | 아니오 | `pn-narrative-ui-director`는 UI 원칙·검수 방향만 지원 | 직접 구현물은 사용하지 않는다. safe BBCode, provenance, accessibility를 독립 명세 | 실제 document/evidence UI 요구와 display contract가 승인됨 |
| `dialogue-system` | `godot-dialogue-system-1.0.0/SKILL.md`; `LICENSE_UNKNOWN` | branching dialogue/manager/resource DB. 콘텐츠 mapping 단계에서 필요할 수 있으나 canonical은 encounter/task/clue/deduction JSON과 structured requirements/effects | 아니오 | authority guard가 schema 충돌을 차단, runtime 구현은 없음 | 원문·manager·expression-string 방식을 쓰지 않는다. canonical content mapping으로 독립 설계 | structured conditions/IDs로 해결되지 않는 승인된 기능 gap가 존재함 |
| `godot-master` | `godot-master/SKILL.md`와 보조 scripts/references; `LICENSE_UNKNOWN` | 광범위 Godot handbook. 현재는 narrow data core와 parser/bootstrap만 필요; 특정 subsystem에서만 필요 가능 | 아니오 | debug, TDD, verification, narrative UI가 현재 좁은 workflow를 지원 | 직접 도입하지 않는다. 공식 문서와 project-local 설계를 우선 | 특정 subsystem gap가 확인되고 공식 문서·독립 설계로 해소되지 않음 |

## 라이선스 경계

이는 법률 자문이 아니다. `docs/reports/SKILL_LICENSE_REAUDIT.md`와 `docs/plans/SKILL_BATCH_2_LICENSE_ELIGIBILITY.md`의 작업 정책을 적용했다. LGPL 4개는 자동으로 불필요하다고 판정하지 않으며, 이번 프로젝트 범위에서 source 문장·구조·scripts를 직접 복사·변형하지 않는다. `LICENSE_UNKNOWN` 2개는 명시 허가가 확인될 때까지 원문·scripts·references를 입력 재료로도 사용하지 않는다. 대체물은 provenance, license, notice, 외부 의존성 조건을 먼저 확인한다.

## 기존 커버리지와 다음 경계

- canonical data는 JSON envelope, `GameJsonLoader`, `GameDataRepository`, `GameDataValidator`, `GameDataBootstrap`을 유지한다.
- simulation·save/load behavior의 test discipline은 `pn-simulation-tdd`, 완료 주장 검증은 `pn-verification-gate`를 사용한다.
- document/evidence UI의 PN-specific constraints는 `pn-narrative-ui-director`를 사용한다.
- 현재 정제 main에는 게임 기준선이 의도적으로 없다. 실제 bootstrap 구현 전에 `3138faf`의 게임 기준선을 별도 승인 Goal로 통합·검토해야 한다.
