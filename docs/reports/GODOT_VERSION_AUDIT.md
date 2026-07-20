# Project Nostalgia Godot 버전 감사

- 최초 감사일: 2026-07-20
- 기준 확정일: 2026-07-20
- 감사 브랜치: `docs/confirm-godot-4.7.1`
- 범위: 저장소·공개 Drive listing·로컬 실행 환경 근거와 사용자 승인 결정

## 1. 최종 판정

Project Nostalgia의 **공식 개발 및 검증 기준 버전은 Godot 4.7.1-stable**이다.

이 기준은 사용자가 2026-07-20 본 요청에서 명시적으로 승인했다. 다음에 적용한다.

- 실제 프로젝트 생성
- GDScript 코드 작성
- `.tscn`/`.tres` 등 scene/resource 문법
- 정적 검사
- headless/runtime 실행 검증
- 향후 Godot 관련 Project Nostalgia 스킬 개편

Godot 4.8 개발판이나 이후 최신 버전으로 자동 변경하지 않는다. 변경에는 별도 브랜치, 백업, 호환성 감사와 사용자 승인이 필요하다.

## 2. 공식 기준과 과거 산출물 버전의 구분

| 구분 | 판정 |
|---|---|
| 앞으로 사용할 공식 기준 | **Godot 4.7.1-stable `[확정]`** |
| 저장소 내 실제 project 생성 버전 | 확인 불가 (`project.godot` 없음) |
| Drive 미완성 산출물의 과거 버전 | 확인 불가(내부 파일 접근/로컬 반입 필요) |
| UI 문서의 목표 호환 표기 | Godot 4.7.1 |
| 로컬 binary 실행 검증 | 미완료 |

과거 산출물에서 다른 버전 흔적이 발견되어도 공식 기준을 자동 변경하지 않는다. 4.7.1-stable과의 차이를 migration audit로 보고한다.

## 3. 사용자 승인 전후

### 변경 전

Canonical SSoT Section 27:

```text
[확정] 게임 개발 엔진은 Godot을 사용한다.
[미정] Godot의 최종 버전, 스크립트 언어의 세부 방침, 목표 플랫폼과 저장·로드 방식.
```

### 변경 후

```text
[확정] 공식 개발 및 검증 기준 버전은 Godot 4.7.1-stable이다.
[확정] 이 버전을 실제 프로젝트 생성, 코드 작성, scene/resource 문법, 정적 검사와 실행 검증의 기준으로 사용한다.
[확정] 자동 업그레이드를 금지한다.
[확정] 버전 변경에는 별도 브랜치·백업·호환성 감사·사용자 승인이 필요하다.
```

상세 차이는 `docs/reports/GODOT_BASELINE_CHANGE_REPORT.md`에 기록했다.

## 4. 저장소 프로젝트 근거

### `project.godot`

저장소 전체 검색 결과: 없음.

### Godot 프로젝트 파일 형식

- `*.tscn`: 없음
- `*.gd.uid`: 없음
- Project Nostalgia 소속 `*.tres`/`.res`: 없음
- Project Nostalgia 소속 `.gd`: 없음

`source_skills`의 외부 GDScript 예제는 실제 프로젝트 근거에서 제외했다.

### 문서 근거

`prompts/UI_REVISION_PROMPT_v0.2.md`는 Godot 4.7.1을 세 곳에서 목표 호환 버전으로 명시한다. 이는 사용자 확정 이전의 일관된 후보 근거지만 runtime 검증 증거는 아니다.

## 5. Google Drive 미완성 산출물

공유 폴더의 직접 하위 listing은 공개 접근 가능했다.

- `game_json_templates`
- `godot_data_core`
- `json_authoring_guidelines.json`
- `게임 프로젝트 설정 기준서 — Project_Nostalgia`

현재 도구로 `godot_data_core` 내부를 열람하지 못해 `project.godot`와 scene/script/resource를 직접 검증하지 못했다. 상세 결과와 로컬 반입 절차는 `docs/reports/UNFINISHED_GODOT_PROJECT_AUDIT.md`에 기록했다.

## 6. 실행 binary 검증

다음 명령 이름을 확인했으나 모두 찾지 못했다.

- `godot`
- `godot4`
- `Godot_v4.7.1-stable_win64.exe`

일반 설치 경로도 발견되지 않았다.

따라서:

- 공식 기준 버전 결정: 완료
- `godot --version` 증거: 미완료
- 실제 4.7.1 runtime 실행 검증: 미완료

임의의 다른 Godot 버전을 설치하거나 사용하지 않았다.

## 7. Phase 0 영향

Godot 버전 **정책 결정 차단 조건은 해제**되었다. 앞으로의 기준은 4.7.1-stable이다.

다만 다음 실행 환경 준비는 별도 후속 항목이다.

1. Godot 4.7.1-stable binary 설치 또는 위치 제공
2. `godot --version` 결과 기록
3. 미완성 프로젝트 로컬 반입
4. 4.7.1 parser/headless/runtime compatibility 검사

이 항목들이 없으면 runtime test 통과를 주장할 수 없다.

## 8. 확인 결과 요약

```text
Official baseline                    → Godot 4.7.1-stable
Canonical status                     → [확정]
project.godot in repository          → 0
Project scenes/scripts in repository → 0
Drive direct listing                 → accessible
Drive candidate internal files       → not accessible with current tool
Get-Command godot/godot4             → NOT_FOUND
godot --version                      → not run; binary unavailable
Automatic upgrade                    → prohibited
```
