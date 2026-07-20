# Project Nostalgia Godot 버전 감사

- 감사일: 2026-07-20
- 감사 브랜치: `audit/godot-and-skill-licenses`
- 범위: 저장소에 실제 존재하는 Godot 프로젝트·문서·실행 환경 근거
- 결론 수준: **실제 프로젝트 버전 확정 불가**

## 1. 결론

현재 저장소만으로 Project Nostalgia의 **실제 사용 Godot 버전을 확인할 수 없다.**

확인 가능한 가장 구체적인 버전 표기는 `prompts/UI_REVISION_PROMPT_v0.2.md`의 **Godot 4.7.1**이다. 그러나 이 파일은 UI 제작·수정 지시문이며, 실제 프로젝트의 `project.godot`, scene/resource header, 실행 로그 또는 Godot binary가 없으므로 4.7.1을 실제 사용 버전이라고 확정할 수 없다.

따라서 보수적인 판정은 다음과 같다.

- 확정 엔진: **Godot**
- 문서상 목표/호환 버전 후보: **Godot 4.7.1**
- 실제 프로젝트가 생성·실행된 Godot 버전: **확인 불가**
- 스킬 커스터마이징의 baseline 버전: **아직 확정 금지**

## 2. 근거별 조사

### 2.1 Canonical SSoT

`docs/ssot/PROJECT_NOSTALGIA_SSOT.md`:

- line 379: 개발 엔진은 Godot으로 `[확정]`
- line 533: Godot의 최종 버전은 `[미정]`

이는 엔진 선택만 확정하고 정확한 버전은 아직 정하지 않았음을 뜻한다.

### 2.2 `project.godot`

저장소 전체에서 `**/project.godot`을 검색했으나 발견되지 않았다.

결과:

```text
No files found
```

따라서 `config_version`, renderer, feature tags, main scene 등으로 버전을 추론할 수 없다.

### 2.3 Godot 프로젝트 파일 형식

다음 파일을 검색했으나 발견되지 않았다.

- `*.tscn`
- `*.gd.uid`
- 프로젝트 소속 `*.tres`/`.res` 근거

`source_skills` 안에는 예제 GDScript가 있지만 이는 외부 스킬 원본이며 Project Nostalgia 프로젝트 파일이 아니다. 버전 근거에서 제외했다.

### 2.4 GDScript 문법

Project Nostalgia 프로젝트 코드로 분류할 수 있는 GDScript가 저장소에 없다.

검색된 `.gd` 파일은 모두 다음 제외 경로 아래의 외부 스킬 예제다.

`Project_Nostalgia_Codex_Handoff_v0.1/source_skills/Project_nostalgia_Skills_v0.6/`

따라서 문법으로 실제 프로젝트 버전을 판정하지 않았다.

### 2.5 README와 프로젝트 문서

루트 `README.md`는 제목 한 줄뿐이며 Godot 버전을 기록하지 않는다.

`prompts/UI_REVISION_PROMPT_v0.2.md`에는 다음 세 곳에서 Godot 4.7.1이 명시된다.

- line 21: `Godot 4.7.1`
- line 304: `Godot 4.7.1 호환 타입 수정`
- line 416: `Godot 4.7.1에서 오류 없이 실행됨` 체크 항목

해석:

- 4.7.1을 UI 산출물의 목표 호환 버전으로 삼았다는 문서 근거는 있다.
- 실제 UI 프로젝트나 실행 결과가 저장소에 없으므로 이 체크 항목이 통과했다는 증거는 아니다.
- `docs/context/PROJECT_CONTEXT.md`와 audit는 기존 UI가 static validation만 받았고 Godot runtime test는 없었다고 명시한다.

### 2.6 실행 파일과 설치 정보

다음 명령 이름을 `Get-Command`로 확인했다.

- `godot`
- `godot4`
- `Godot_v4.7.1-stable_win64.exe`

모두 `NOT_FOUND`였다.

다음 일반 설치 경로도 존재하지 않았다.

- `C:\Program Files\Godot`
- `C:\Program Files (x86)\Godot`
- `%LOCALAPPDATA%\Programs\Godot`
- `C:\Godot`

이는 시스템 전체를 완전 탐색한 결과가 아니라 PATH와 일반 위치 검사다. 사용자가 다른 위치에 portable binary를 보유했을 가능성은 배제할 수 없다.

## 3. 확인된 사실과 불확실성

| 항목 | 판정 | 근거 |
|---|---|---|
| 엔진 | Godot 확정 | canonical SSoT |
| 최종 버전 | 미정 | canonical SSoT line 533 |
| 목표 호환 후보 | 4.7.1 | UI revision prompt 3개 표기 |
| 실제 프로젝트 format | 확인 불가 | `project.godot`, `.tscn` 없음 |
| 실제 GDScript 문법 수준 | 확인 불가 | 프로젝트 코드 없음 |
| runtime 실행 버전 | 확인 불가 | binary와 실행 로그 없음 |
| 기존 runtime test | 수행 증거 없음 | context/audit의 static-only 경고 |

## 4. Phase 0 영향

“실제 Godot 버전 확인” 항목은 **미완료 유지**한다. 4.7.1을 baseline으로 임의 확정하지 않는다.

완료하려면 최소 하나가 필요하다.

1. 실제 프로젝트의 `project.godot` 및 주요 `.tscn`/`.gd` 파일 이관
2. 사용 예정 Godot binary에 대한 `godot --version` 결과
3. 해당 binary로 프로젝트를 열거나 headless parse/run한 명령과 exit 결과

## 5. 실행한 검사

```text
Glob **/project.godot                 → 0
Glob **/*.tscn                        → 0
Glob **/*.gd.uid                      → 0
Glob **/*.gd                          → source_skills 예제만 발견
Grep Godot version/config/format      → UI prompt의 4.7.1 표기만 프로젝트 문서에서 발견
Get-Command godot                     → NOT_FOUND
Get-Command godot4                    → NOT_FOUND
Get-Command Godot_v4.7.1...exe        → NOT_FOUND
일반 설치 경로 Test-Path             → 모두 False
```

## 6. 최종 판정

**확인된 Godot 버전:** 실제 버전 확인 불가. 문서상 목표 후보는 4.7.1이며, canonical SSoT의 최종 버전 상태는 `[미정]`이다.
