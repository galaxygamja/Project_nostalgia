# Project Nostalgia 스킬 개편 명세

- 작성일: 2026-07-20
- 상태: 구현 전 기준 명세
- 공식 Godot 기준: **Godot 4.7.1-stable**
- 근거: canonical SSoT Section 27 및 2026-07-20 사용자 승인

## 1. 목적

Project Nostalgia 전용 스킬을 향후 개편할 때 적용할 공통 기준을 정의한다. 이 문서는 실제 스킬 구현을 시작하지 않으며, 구현 전에 지켜야 할 version·authority·license 경계를 고정한다.

## 2. Godot 버전 고정 규칙

모든 Godot 관련 스킬은 다음을 따른다.

1. 코드, API, GDScript 문법, project settings, scene/resource format, test command를 **Godot 4.7.1-stable** 기준으로 작성한다.
2. Godot 4.8 개발판 또는 이후 최신 문서를 기본값으로 사용하지 않는다.
3. `stable`처럼 움직이는 문서 alias만 근거로 API를 확정하지 않고, 가능한 경우 4.7 문서와 4.7.1 실행 결과를 사용한다.
4. 외부 원본 스킬이 4.3+, 4.6, 4.7+, 4.8을 가정하면 4.7.1과의 차이를 먼저 기록한다.
5. 4.7.1에서 확인하지 못한 API는 “검증 필요”로 표시하고 실행 성공을 주장하지 않는다.
6. 버전 변경은 별도 branch, source backup, compatibility audit, migration plan과 사용자 승인이 있어야 한다.

## 3. 과거 산출물 처리

- 과거 미완성 Godot 프로젝트의 생성 버전과 앞으로의 공식 기준을 분리한다.
- 과거 파일이 다른 버전 format이면 자동 upgrade/open-save하지 않는다.
- 원본 snapshot과 hash를 보존한 뒤 4.7.1 compatibility report를 작성한다.
- Godot editor가 자동 변환할 수 있는 파일도 변환 전 diff와 승인을 요구한다.

## 4. 검증 계층

Godot 관련 스킬의 완료 보고는 다음을 구분한다.

1. 문서 기준 검토
2. 정적 텍스트/JSON 검사
3. Godot 4.7.1 parser/headless 검사
4. Godot 4.7.1 runtime 실행
5. 1920×1080 visual capture 검사

상위 단계가 수행되지 않았으면 하위 단계만으로 통과했다고 표현하지 않는다. `godot --version` 출력을 실행 기록에 포함한다.

## 5. 프로젝트 authority 및 data architecture

모든 스킬은 다음 우선순위를 따른다.

- `AGENTS.md`
- canonical SSoT
- `SSOT_POINTER.md`와 `KNOWN_CONFLICTS.md`
- canonical JSON data core

Godot 4.7.1을 사용하더라도 다음은 바꾸지 않는다.

- `schema_version: 1`, `data_type`, `entries`
- `ABCD_001` ID 규칙
- `GameJsonLoader` → `GameDataRepository` → `GameDataValidator` → `GameDataBootstrap`
- `requirements`/`effects` 분리
- 구조화된 formula
- human-authored Korean source와 generated runtime JSON 분리

## 6. 원본 스킬 라이선스 경계

- MIT/Apache/LGPL 재료는 `SKILL_LICENSE_AUDIT.md`의 조건과 attribution을 따른다.
- license 불명인 `dialogue-system`, `godot-master`의 원문·script·reference를 수정본에 사용하지 않는다.
- LGPL 원본을 직접 복사·변형할 경우 corresponding source와 license 조건을 적용한다.
- 가능하면 Project Nostalgia 요구사항을 기준으로 독립 재작성하고 provenance를 기록한다.

## 7. 대상 스킬별 4.7.1 적용

| 목표 스킬 | 4.7.1 기준 항목 |
|---|---|
| `pn-data-core-guardian` | FileAccess/JSON/GDScript typing, project import behavior |
| `pn-simulation-tdd` | test runner와 headless invocation, 시간 로직 syntax |
| `pn-godot-debug-and-completion` | `--headless`, parser/runtime command와 exit evidence |
| `pn-narrative-ui-director` | Control/RichTextLabel/Theme API, ImageUnit, 1920×1080 settings |
| `pn-content-authoring-and-validation` | JSON load/validation integration |
| `pn-save-migration` | FileAccess, serialization, user:// behavior |
| `pn-repository-map` | `.godot/` 제외, `.gd.uid`/scene/resource parsing |

`pn-authority-and-conflict-guard`는 엔진 API를 구현하지 않지만 버전 변경 승인 gate를 포함한다.

## 8. 구현 전 차단 조건

- Godot 4.7.1-stable binary가 없으면 runtime-specific example을 “검증 완료”로 표시하지 않는다.
- 과거 Drive 산출물은 로컬 반입·hash manifest 전 사용하지 않는다.
- license 불명 source를 사용하지 않는다.
- 실제 스킬 파일 작성은 별도 사용자 승인 후 시작한다.
