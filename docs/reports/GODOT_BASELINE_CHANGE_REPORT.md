# Godot 4.7.1 기준 확정 변경 보고서

- 작성일: 2026-07-20
- 사용자 승인 근거: 사용자가 본 요청에서 Project Nostalgia의 공식 개발 기준 버전을 `Godot 4.7.1-stable`로 명시적으로 확정하고 canonical SSoT 변경을 지시함
- 변경 종류: 설정/개발 기준 변경. 수치 밸런스 변경 아님
- 변경 전 SSoT SHA-256: `F1F0F3AE6FBD8395DCF60ECC8688B32819C19657F40B853E8299D2145DCF4BD3`

## 기존 규칙

`docs/ssot/PROJECT_NOSTALGIA_SSOT.md` Section 27:

```text
[확정] 게임 개발 엔진은 Godot을 사용한다.
[미정] Godot의 최종 버전, 스크립트 언어의 세부 방침, 목표 플랫폼과 저장·로드 방식.
```

문서와 과거 감사에서는 Godot 4.7.1을 UI 목표 호환 후보로만 다뤘으며 실제 프로젝트 버전은 확인할 수 없었다.

## 승인된 새 규칙

```text
[확정] 공식 개발 및 검증 기준 버전은 Godot 4.7.1-stable이다.
[확정] 이 버전을 실제 프로젝트 생성, 코드 작성, scene/resource 문법, 정적 검사와 실행 검증의 기준으로 사용한다.
[확정] Godot 4.8 개발판이나 이후 최신 버전으로 자동 업그레이드하지 않는다.
[확정] 버전 변경에는 별도 브랜치, 백업, 호환성 감사와 사용자 승인이 필요하다.
```

스크립트 언어 세부 방침, 목표 플랫폼, 저장·로드 방식은 계속 `[미정]`이다.

## 정확한 차이

| 항목 | 기존 | 승인 후 |
|---|---|---|
| 엔진 | Godot `[확정]` | 동일 |
| 정확한 버전 | `[미정]` | Godot 4.7.1-stable `[확정]` |
| 적용 범위 | 정의 없음 | 프로젝트 생성, 코드, scene/resource 문법, 정적·실행 검증 |
| 자동 업그레이드 | 규칙 없음 | 금지 |
| 향후 변경 절차 | 규칙 없음 | 별도 브랜치·백업·호환성 감사·사용자 승인 |

## 영향 파일과 시스템

직접 변경:

- `docs/ssot/PROJECT_NOSTALGIA_SSOT.md` Section 27
- `docs/ssot/PROJECT_NOSTALGIA_SSOT.md` Section 33 변경 이력 추가
- `docs/reports/GODOT_VERSION_AUDIT.md`
- `docs/plans/PROJECT_NOSTALGIA_SKILL_CUSTOMIZATION_PLAN.md` Phase 0

향후 영향:

- 새 `project.godot` 생성 기준
- GDScript 및 scene/resource syntax 검토 기준
- Godot 관련 project skill의 호환성 기준
- static/headless/runtime 검증에 사용할 binary 기준

영향 없음:

- canonical JSON envelope 및 ID 규칙
- 프로젝트 코드와 runtime JSON(이번 작업에서 수정하지 않음)
- source_skills 원본

## 실제 실행 환경과의 구분

이 변경은 사용자가 승인한 **앞으로의 공식 기준 버전**을 확정한다. 과거 미완성 산출물이 실제 어떤 버전으로 생성되었는지는 별도 조사 대상이다.

현재 저장소에는 `project.godot`이 없고 PATH/일반 설치 위치에서 Godot binary도 확인되지 않았으므로 `godot --version` 실행 증거는 아직 없다. 이 실행 환경 검증 미완료 상태는 공식 기준 버전 확정과 구분한다.
