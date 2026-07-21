---
name: pn-repository-map
description: Use for read-only Project Nostalgia repository structure, dependency, reference, or change-impact questions that require mapping Godot scenes/scripts/autoloads, canonical JSON IDs and references, document authority, or a Git diff; uses direct repository evidence without installing graph tooling, generating dashboards, or modifying source files.
---

# Project Nostalgia Repository Map

## 목적

현재 commit의 실제 파일과 참조를 읽기 전용으로 추적해 구조, 질의, 변경 영향을 설명한다. `.ua` graph, Node/pnpm plugin, dashboard, auto-update hook을 만들지 않으며 코드에서 게임 canon을 역추론하지 않는다.

## 호출 조건

- 특정 Godot scene/script/autoload가 어디서 연결되는지 물을 때
- JSON ID의 정의·참조·loader flow를 추적할 때
- 문서 authority와 pointer 관계를 확인할 때
- Git diff가 어떤 scene, test, ID 또는 문서에 영향을 주는지 조사할 때
- 저장소 구조를 다음 구현 계획의 근거로 요약할 때

## 호출하지 말아야 하는 조건

- branch/staging/commit/push 안전 작업: `pn-repository-safety`
- 버그의 근본 원인 조사: `pn-godot-debug-and-completion`
- SSoT 의미·충돌·승인 판정: `pn-authority-and-conflict-guard`
- semantic code quality review 또는 기능 완료 판정
- 전체 knowledge graph/dashboard 설치 요청이 아닌 단순 파일 찾기 한 건

## 필수 입력

1. 조사 질문과 경계: `scan`, `query`, `impact` 중 하나
2. repository root와 현재 commit SHA
3. 포함할 파일·ID·diff 범위
4. 제외 경로와 generated/cache 정책
5. canonical SSoT 및 data-core 경로

## 수행 순서

### 1. freshness 확인

- `git rev-parse --show-toplevel`, branch, HEAD, status를 읽는다.
- 보고서에 기준 commit과 working/staged/untracked 여부를 분리한다.
- stale한 이전 map이나 audit를 현재 source보다 우선하지 않는다.

### 2. 직접 검색

- 파일 목록은 `rg --files`를 우선한다.
- symbol, path, ID와 resource reference는 `rg`로 정의와 사용처를 찾는다.
- `.godot/`, build, cache, dependency vendor, source skill 원본은 기본 map에서 제외한다.
- 질문에 필요한 경로만 단계적으로 읽는다.

### 3. 관계 유형별 추적

#### Godot

- `project.godot` main scene와 autoload
- `.tscn` script/resource path
- `.gd` preload/load, signals, node paths와 test 대상
- `.gd.uid`는 보존 대상이지만 cache로 취급하지 않음

#### canonical data

- `schema_version`, `data_type`, `entries`
- ID 정의와 모든 참조
- `GameJsonLoader` → `GameDataRepository` → `GameDataValidator` → `GameDataBootstrap`
- requirements/effects, flags, formula, initial state 연결

#### 문서 authority

- `AGENTS.md` 읽기 순서
- canonical SSoT, source metadata, pointer, context, conflicts
- audit/report/plan은 상위 authority를 대체하지 않음

#### diff impact

- 기준 commit, working diff, staged diff를 분리
- changed path와 changed ID를 먼저 추출
- 직접 upstream/downstream reference와 test를 열거
- 추측 관계는 `inference`로 표시하고 사실 관계와 구분

### 4. 최소 결과 작성

- 질문에 필요한 관계만 작은 표나 목록으로 만든다.
- 각 edge에 source path와 가능한 경우 line을 붙인다.
- dangling reference, 불확실성, 확인하지 못한 영역을 별도로 표시한다.
- 코드에서 story/setting canon을 생성하거나 확정하지 않는다.

## 수정 가능한 범위

- 사용자가 명시적으로 요청한 task-specific map/report 문서
- map 검증을 위한 임시 메모는 repository에 저장하지 않음

기본 동작은 source와 repository 상태의 읽기 전용 조사다.

## 수정 금지 범위

- Godot code, runtime JSON, SSoT와 source metadata
- source skill과 handoff 원본
- `.ua/`, `.understand-anything/`, dashboard, graph cache
- auto-update/commit hook, Node/pnpm/plugin 설치
- branch, staging area, commit 또는 remote
- 누락 ID 자동 생성과 dangling edge 자동 수정

## 중단 조건

- 기준 commit 또는 조사 root가 불명확함
- 예상 밖 tracked/staged 변경으로 기준선이 오염됨
- 질문 답변에 미정 설정 선택이 필요함
- generated graph나 외부 plugin 설치 없이는 진행할 수 없다는 가정이 생김: direct-search fallback으로 다시 범위를 줄임
- source 파일을 수정해야만 관계를 확인할 수 있음

## 검증 절차

1. 보고한 모든 path 존재 확인
2. ID·resource·document edge의 양 끝 확인
3. 기준 commit과 diff 종류 기록
4. dangling/uncertain edge를 0으로 숨기지 않고 별도 집계
5. `.godot/`, cache, source bundle이 결과물에 포함되지 않았는지 확인
6. 생성 문서가 있으면 `git diff --check`와 상대경로 검사
7. direct search만 수행했음을 명시하고 runtime 성공으로 표현하지 않음

## 결과 보고 형식

```text
mode: scan | query | impact
repository/branch/commit:
scope/exclusions:
nodes or files:
verified relationships with evidence:
changed IDs/affected paths:
dangling or uncertain relationships:
generated artifacts:
runtime status: not tested
```

## 다음 스킬로 넘기는 조건

- map에서 설정·SSoT 충돌 발견 → `pn-authority-and-conflict-guard`
- 실패 경계와 재현 조사 필요 → `pn-godot-debug-and-completion`
- map에 근거한 simulation 구현 → `pn-simulation-tdd`
- 결과물 완료 증거 판정 → `pn-verification-gate`
- Git 기록 요청 → `pn-repository-safety`
