---
name: pn-repository-safety
description: Use before and during Git work in Project Nostalgia to verify branch, baseline, diff, selective staging, commit, and push without including untracked sources, secrets, caches, or unrelated files.
---

# Project Nostalgia Repository Safety

## 목적

`understand-diff`의 changed-file, freshness, affected-scope와 structured risk analysis 원칙을 유지하면서, 별도 knowledge graph 없이 Project Nostalgia의 Git 작업을 안전하게 기록한다.

이 스킬은 파일 내용이나 게임 설계를 작성하지 않는다. branch/status/remote/diff/staging/commit/push 상태 확인만 담당한다.

## 호출 조건

- 작업 시작 전 기준 branch/commit을 확인할 때
- 다른 컴퓨터 또는 session에서 작업을 재개할 때
- 변경 파일과 영향 범위를 검토할 때
- 선택적 staging, commit, push 직전과 직후
- untracked source bundle·Drive import·cache가 함께 있는 작업 트리
- migration/audit/skill 작업용 별도 branch를 만들 때

## 호출하지 말아야 하는 조건

- 게임 코드·JSON·문서 내용을 설계하거나 작성할 때
- SSoT 충돌 판단: `pn-authority-and-conflict-guard`
- Godot 오류의 원인 조사: `pn-godot-debug-and-completion`
- 완료 주장의 test/runtime 증거 판정: `pn-verification-gate`

## 필수 입력

- 기대 base branch와 exact commit
- 목표 작업 branch
- 허용 staging 경로와 금지 경로
- expected remote URL과 upstream
- commit message와 push target
- 보존해야 할 untracked/ignored 자료
- secret/size/cache 검사 범위

## 수행 순서

### 1. 작업 시작 상태 확인

1. `git fetch origin`으로 remote refs를 갱신한다.
2. 현재 branch와 `git rev-parse HEAD`를 확인한다.
3. `git status --short --branch`로 tracked/untracked 상태를 분리한다.
4. `git remote -v`와 upstream을 확인한다.
5. 기대 base commit과 실제 remote/local commit을 비교한다.
6. 다른 컴퓨터에서 이어받는 경우 ahead/behind와 remote divergence를 확인한 뒤 변경을 시작한다.

기대 commit이 다르거나 필수 최신 문서가 없으면 임의로 `main`에서 시작하지 않는다. 기존 같은 이름 branch를 force-reset하거나 삭제하지 않고 상태를 보고한다.

### 2. 안전한 branch 사용

- migration, audit, skill batch, 대규모 변경은 별도 branch에서 수행한다.
- `main`에 직접 commit하지 않는다.
- branch 생성 전 같은 local/remote 이름이 있는지 확인한다.
- 기존 branch가 있으면 자동 초기화하지 않는다.
- destructive reset, checkout overwrite, force push를 기본 해결책으로 사용하지 않는다.

### 3. 변경 목록과 영향 범위 분석

다음 결과를 섞지 않는다.

- committed branch diff: 승인된 base commit/branch와 `HEAD`
- unstaged tracked diff
- staged diff
- untracked files
- ignored files

changed path마다 분류한다.

- 직접 변경 목적
- 관련 문서/코드/data 영향
- SSoT/schema/ID 영향 여부
- generated/cache/binary/source snapshot 여부
- 이번 commit 허용 여부

`.ua` knowledge graph나 dashboard는 요구하지 않는다. 실제 repository tree, Grep, imports, references와 canonical docs를 사용해 필요한 범위만 조사한다.

### 4. selective staging

- 사용자가 승인한 개별 파일 또는 좁은 디렉터리만 `git add -- <path>`로 stage한다.
- `git add .`와 `git add -A`를 기본 금지한다.
- untracked 파일을 자동 stage하지 않는다.
- source skill/handoff, `game_development/`, `.godot/`, runtime JSON, Godot 코드, SSoT, secret, unrelated 자료는 해당 task가 명시 승인하지 않으면 stage하지 않는다.
- 10 MiB 이상 파일, binary, nested `.git`, environment/credential/private-key 후보를 확인한다.

secret content를 출력하지 말고 filename/pattern 또는 `git grep --cached --quiet` 같은 비노출 검사 방식을 우선한다.

### 5. staged diff gate

commit 전에 확인한다.

1. `git diff --cached --name-status`
2. `git diff --cached --stat`
3. `git diff --cached --check`
4. `git diff --cached`의 실제 내용
5. staged secret/cache/large file 검사
6. 허용 경로 목록과 exact set 비교

예상 범위를 벗어난 path, 삭제, rename, binary 또는 secret 후보가 있으면 commit하지 않는다. 자동 unstage/reset으로 숨기지 말고 상태를 보고한다.

### 6. commit과 push 검증

- 승인된 메시지로 새 commit을 만든다. 기존 commit amend는 별도 승인 없이는 하지 않는다.
- hooks를 우회하지 않는다.
- commit 후 SHA와 `git show --stat --name-status HEAD`를 확인한다.
- force 없이 정확한 branch를 origin에 push한다.
- push 후 upstream과 local/remote SHA가 같은지 확인한다.
- remote가 보여주는 PR URL은 PR 생성 결과가 아니다. 요청 없이는 PR을 만들지 않는다.

### 7. 작업 종료 상태

- `git status --short --branch`를 기록한다.
- 남은 untracked/ignored 자료를 구체적으로 보고한다.
- tracked dirty, ahead/behind, staged 잔여가 있는지 구분한다.
- commit/push를 실행하지 못했으면 그 사실과 원인을 명시한다.

## 수정 가능한 범위

- Git index와 승인된 branch/commit/ref
- task에서 명시한 Git metadata 작업

파일 콘텐츠의 작성·설계는 다른 스킬의 책임이다.

## 수정 금지 범위

- `main` 직접 commit
- force push 또는 기존 branch 강제 초기화
- 승인 없는 branch 삭제
- source/handoff/game_development/.godot/unrelated untracked 자동 staging
- secret 출력 또는 commit
- 사용자 승인 없이 파일 삭제·이동·복구
- diff 범위를 맞추기 위한 destructive reset

## 중단 조건

- 기대 base commit/branch/remote와 실제 상태가 다름
- 같은 이름 branch가 이미 있고 안전한 계보가 불명확함
- tracked working tree가 예상과 다르게 dirty함
- staged path가 allowlist와 다름
- source snapshot, SSoT, runtime data/code의 미승인 변경 발견
- secret 또는 대용량 binary 후보 발견
- push가 force나 history rewrite를 요구함

## 검증 절차

- [ ] fetch 후 branch/HEAD/remote/upstream 확인
- [ ] base와 ahead/behind 확인
- [ ] committed/unstaged/staged/untracked/ignored diff 구분
- [ ] selective path staging만 사용
- [ ] staged names/stat/check/content 검토
- [ ] secret/cache/large file 검사
- [ ] commit SHA와 실제 포함 파일 확인
- [ ] non-force push와 remote tracking SHA 확인
- [ ] 종료 working tree와 남은 자료 보고
- [ ] 최종 완료 주장은 `pn-verification-gate` 결과와 일치

## 결과 보고 형식

```text
상태: 안전 | 중단 | commit 완료 | push 완료 | 부분 완료
branch/HEAD/base:
remote/upstream/ahead-behind:
tracked 변경:
staged 변경:
untracked/ignored:
허용 경로 대조:
secret/cache/large-file 검사:
commit SHA/message/files:
push target/result/remote SHA:
금지 작업 수행 여부:
남은 working tree:
차단 조건:
```

## 다음 스킬로 넘기는 조건

- 설정/SSoT 충돌 발견 → `pn-authority-and-conflict-guard`
- Godot/test/data failure 원인 조사 → `pn-godot-debug-and-completion`
- commit 전 전체 요구사항·증거 판정 → `pn-verification-gate`
- 콘텐츠나 코드 작성 → task에 맞는 별도 스킬 또는 승인된 구현 절차
