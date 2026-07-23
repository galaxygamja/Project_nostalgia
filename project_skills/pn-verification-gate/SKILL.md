---
name: pn-verification-gate
description: Use at the functional evidence gate immediately before declaring Project Nostalgia work complete, fixed, passing, compatible, or ready for Git recording; maps requirements to fresh static/data/Godot evidence and returns complete, partial, or blocked, but does not diagnose failures or execute staging, commit, push, or general review.
---

# Project Nostalgia Verification Gate

## 목적

`verification-before-completion`의 핵심인 **주장 전에 신선한 증거를 확인한다**는 원칙을 Project Nostalgia의 검증 계층과 결과 상태에 적용한다.

완료를 암시하는 표현 또는 기능 변경을 Git에 기록하기 전에 이 gate를 통과한다. 다른 project skill도 이 결과 형식을 따르거나 이 스킬로 넘긴다. 검증이 통과한 뒤 staging/commit/push는 `pn-repository-safety`가 담당하며, Git 작업 자체가 최종 주장에 포함되면 repository 결과를 별도 증거로 보고한다.

## 호출 조건

- `완료`, `수정됨`, `통과`, `준비됨`, `호환됨`을 주장하기 직전
- 기능 변경을 staging/commit 대상으로 승인하기 직전
- Godot/JSON/Git 작업 결과를 최종 보고하기 전
- agent·도구·과거 report가 성공했다고 했지만 직접 확인하지 않았을 때
- 부분 검사로 전체 성공을 추론하려 할 때

## 호출하지 말아야 하는 조건

- 단순 Git status, diff 목록, staging 또는 push 안전 확인: `pn-repository-safety`
- 의미·품질에 대한 일반 코드 리뷰나 원인 조사
- 오류의 근본 원인을 조사하는 중: `pn-godot-debug-and-completion`
- authority 충돌과 승인 계획 수립: `pn-authority-and-conflict-guard`
- Git 명령을 안전하게 실행하는 절차 자체: `pn-repository-safety`

## 필수 입력

- 검증하려는 각 주장
- 사용자 요구사항과 허용·금지 범위
- 현재 branch/commit/status/diff
- 생성·수정·삭제 예상 경로
- 관련 test/validator/parser/runtime 명령
- Godot executable 경로와 실제 `--version`, 또는 binary 부재
- 최신 명령의 전체 출력, exit code, failure/warning count
- 원본 hash baseline이 있으면 작업 전 hash

## 핵심 관문

각 주장에 대해 다음을 반복한다.

1. **주장 식별:** 무엇이 완료되었다고 말하려는가?
2. **증거 정의:** 그 주장을 직접 입증하는 전체 명령·검사는 무엇인가?
3. **신선하게 실행:** 현재 작업 상태에서 전체 검사를 실행한다. 기능 증거는 관련 파일이 바뀌면 stale이므로 다시 실행한다.
4. **출력 판독:** exit code, 전체 오류, failure count, skipped 항목을 확인한다.
5. **범위 대조:** 증거가 주장 전체를 직접 입증하는가?
6. **상태 판정:** 완료 / 부분 완료 / 차단됨 중 하나로 기록한다.
7. **그 뒤에만 보고:** 증거보다 강한 표현을 사용하지 않는다.

실행하지 않은 명령, 과거 실행, 부분 출력, “통과할 것”이라는 추론은 성공 증거가 아니다.

## 수행 순서

### 1. 요구사항·산출물 검증

- 사용자 요구사항을 checklist로 다시 읽는다.
- 각 요구사항에 파일 또는 증거를 대응한다.
- 생성 파일 존재, 이름, frontmatter/필수 section을 확인한다.
- 상대경로가 실제 존재하는지 검사한다.
- unrelated 변경과 누락 산출물을 기록한다.

### 2. 검증 계층 분리

Godot 결과:

1. 문서/정적 텍스트 검토
2. Godot 4.7.1 parser
3. headless project load
4. runtime/test execution
5. 1920×1080 visual capture

JSON 결과:

1. JSON parse
2. envelope (`schema_version`, `data_type`, singleton/`entries`)
3. schema/required field
4. ID shape와 uniqueness
5. reference existence와 expected type
6. Godot loader/repository/validator/bootstrap integration
7. runtime behavior

Git 결과:

1. working tree diff
2. staged diff
3. commit object
4. remote push/upstream 확인

한 계층의 통과로 다른 계층을 통과했다고 쓰지 않는다. 정확한 Godot 4.7.1-stable binary가 없으면 parser/headless/runtime는 `미검증`이다.

### 3. 금지 범위와 불변성 확인

작업별 금지 경로를 확인한다. Project Nostalgia에서는 특히 다음을 검사한다.

- canonical SSoT가 승인 없이 바뀌지 않았는가
- source skills 원본 SHA-256이 작업 전과 같은가
- `game_development/`, runtime JSON, Godot 코드가 범위 밖에서 바뀌지 않았는가
- `.godot/`, secret, unrelated untracked 파일이 stage되지 않았는가
- 누락 reference ID나 데이터를 임의 생성하지 않았는가
- 알려진 충돌을 자동 해결하지 않았는가

### 4. 상태 판정

#### 완료

- 모든 승인 요구사항에 직접 증거가 있음
- 관련 검사가 최신 상태에서 성공
- 금지 범위와 diff가 깨끗함
- 미검증 항목이 완료 주장에 필요하지 않거나 명확히 분리됨

#### 부분 완료

- 일부 산출물 또는 정적 검사는 통과했으나 runtime·외부 환경 등 필요한 계층이 미검증
- 완료된 범위와 미검증 범위를 정확히 분리할 수 있음

#### 차단됨

- 요구 증거가 실패함
- 필수 binary/file/권한이 없음
- diff가 승인 범위를 벗어남
- 원본 hash가 달라짐
- 사용자 결정 없이 known conflict를 해결해야 함

실패 또는 차단 상태에서도 사실대로 보고한다. 통과를 위해 오류를 숨기거나 자동 수정하지 않는다.

## 수정 가능한 범위

이 스킬의 기본 동작은 읽기·실행 검증과 보고다. 사용자가 명시한 검증 산출물 외에는 파일을 수정하지 않는다.

## 수정 금지 범위

- 검증을 통과시키기 위한 코드·JSON·SSoT 자동 수정
- source skill 원본
- 오류 로그 삭제·축약으로 실패 은폐
- 누락 reference나 fixture 임의 생성
- 검증되지 않은 결과의 commit/push

## 중단 조건

- 주장에 대응하는 직접 검증 방법이 없음
- 필수 실행 환경이 없음
- 전체 출력이나 exit code를 확인할 수 없음
- working/staged diff가 승인 범위와 다름
- 원본 hash 불변성 검사 실패
- 요구사항이 서로 충돌함

## 검증 절차

최소 checklist:

- [ ] 주장별 직접 증거를 정의함
- [ ] 현재 상태에서 검사를 신선하게 실행함
- [ ] exit code와 failure/warning/skipped 수를 확인함
- [ ] 정적/Godot parser/headless/runtime를 구분함
- [ ] JSON parse/schema/reference/integration을 구분함
- [ ] working diff와 staged diff를 따로 확인함
- [ ] 생성 파일과 상대경로를 확인함
- [ ] 원본 SHA-256 불변을 확인함
- [ ] 금지·untracked·secret 경로가 stage되지 않음을 확인함
- [ ] 완료/부분 완료/차단됨 상태를 선택함

## 결과 보고 형식

```text
최종 상태: 완료 | 부분 완료 | 차단됨
검증 시각/branch/commit:
요구사항별 결과:
실행한 명령:
exit code/failure/warning/skipped:
정적 검사:
JSON parse/schema/ID/reference 검사:
Godot --version/parser/headless/runtime/visual:
working diff/staged diff:
생성·변경 파일:
원본 hash 불변성:
금지 범위·secret 검사:
실패 항목:
미검증 항목:
보류 및 사용자 결정:
```

## 다음 스킬로 넘기는 조건

- 실패의 root cause 조사 → `pn-godot-debug-and-completion`. 실패 명령, 최초 실패 지점, 추가로 필요한 증거와 다시 verification으로 돌아오는 조건을 전달한다.
- 충돌·authority 승인 필요 → `pn-authority-and-conflict-guard`. 충돌 항목과 승인 범위를 전달하며 새 승인 또는 기준 SHA가 확인될 때만 돌아온다.
- 기능 검증 통과 후 안전한 stage/commit/push 실행 → `pn-repository-safety`. repository 작업 뒤 Git 기록·remote 상태는 repository 증거로 최종 보고하고, 기능 파일이 바뀐 경우에만 이 gate를 다시 실행한다.
- JSON domain 수정 → 담당 스킬이 아직 없으므로 보류하고 별도 승인 요청
