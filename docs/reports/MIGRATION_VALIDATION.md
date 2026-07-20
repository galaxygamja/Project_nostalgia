# Project Nostalgia 저장소 이관 검증 보고서

- 검증일: 2026-07-20
- 작업 루트: `C:\Users\User\projects\Project_Nostalgia`
- 범위: canonical SSoT 정규화, Git/GitHub 이관 준비, ignore·secret·중복 검사
- 수행하지 않은 작업: staging, commit, push, PR, main 수정, SSoT 본문 수정, 프로젝트 코드/런타임 JSON/source_skills 수정

## 1. 작업 루트

`C:\Users\User\projects\Project_Nostalgia`

명령 실행 환경에서는 경로의 사용자명 대소문자가 `C:\Users\User\...`로 반환되었다. Windows 경로의 동일 위치이며 요청된 작업 루트에서 수행했다.

## 2. canonical SSoT 원본 및 대상 경로

- handoff 원본: `Project_Nostalgia_Codex_Handoff_v0.1/docs/ssot/PROJECT_NOSTALGIA_SSOT.md`
- canonical 대상: `docs/ssot/PROJECT_NOSTALGIA_SSOT.md`
- 복사 전 대상 상태: 없음
- 처리: `docs/ssot` 생성 후 `Copy-Item`으로 복사
- SSoT 본문 편집: 없음

대상이 없음을 확인한 뒤에만 복사했다. 기존 파일 덮어쓰기는 발생하지 않았다.

## 3. 복사 전후 SHA-256

| 파일 | SHA-256 |
|---|---|
| handoff 원본 | `F1F0F3AE6FBD8395DCF60ECC8688B32819C19657F40B853E8299D2145DCF4BD3` |
| canonical 대상 | `F1F0F3AE6FBD8395DCF60ECC8688B32819C19657F40B853E8299D2145DCF4BD3` |

결과: **일치**. canonical 파일은 원본과 byte-identical하다.

## 4. SOURCE_METADATA.md 생성 결과

생성 경로: `docs/ssot/SOURCE_METADATA.md`

확인한 값:

- Title: 게임 프로젝트 설정 기준서 — Project_Nostalgia
- Google Docs file ID: `1iU6h5hWr8NbzBb8HBTKTBAxK798cKFDMNgz6gDGlyBs`
- Source URL: `https://docs.google.com/document/d/1iU6h5hWr8NbzBb8HBTKTBAxK798cKFDMNgz6gDGlyBs/edit`
- Repository canonical path: `docs/ssot/PROJECT_NOSTALGIA_SSOT.md`
- Last verified revision: `ALtnJHz5kNX-F5xgGxOjE2MJLd4yywvJ0EEw1YE_hWeCNoCsRB0hI2bw2i7T1Rhik7XcHpTM3V3LbenuNoDfkcAwfKp0Rk-vVg152hCI3ig`
- Export or repository migration date: `2026-07-20`
- Verification scope: Sections 29, 30, 31, 32 confirmed
- Synchronization rule: 원본과 저장소 사본이 다르면 자동 병합·덮어쓰기하지 않고 차이와 승인을 먼저 처리

기존 metadata 파일은 없었으므로 덮어쓰기는 발생하지 않았다.

## 5. Git 저장소 초기화 여부

초기 검사에서 작업 루트에 `.git`이 없었다. 다음을 수행했다.

```powershell
git -C "C:\Users\User\projects\Project_Nostalgia" init
```

결과: 빈 Git 저장소 초기화 성공. 초기 unborn branch 이름은 Git 기본값 `master`였으나, 이 브랜치에 commit하지 않았다.

## 6. origin URL

초기 검사에서 origin이 없었다. 다음 URL을 추가했다.

`https://github.com/galaxygamja/Project_nostalgia.git`

fetch/push URL 모두 동일하다. 기존의 다른 origin을 변경한 일은 없다.

## 7. 원격 기본 브랜치와 origin/main 상태

`git fetch origin` 성공.

- 원격 기본 브랜치: `main`
- `origin/HEAD`: `origin/main`
- `origin/main`: 존재
- `origin/main` SHA: `b95f5c157779951f0a4071b1494beee4a993b86d`
- 공개 원격의 현재 tracked file: `README.md`

## 8. 현재 로컬 브랜치와 HEAD

- 현재 브랜치: `migration/google-drive-to-github`
- HEAD: `b95f5c157779951f0a4071b1494beee4a993b86d`
- upstream: `origin/main`
- origin/main 대비: ahead 0, behind 0

main에 checkout하거나 commit하지 않았다.

## 9. migration 브랜치 생성 결과

생성 전 확인:

- 같은 이름의 로컬 브랜치: 없음
- 같은 이름의 원격 브랜치: 없음
- root `README.md`: checkout 전 없음

실행:

```powershell
git -C "C:\Users\User\projects\Project_Nostalgia" switch -c migration/google-drive-to-github --track origin/main
```

결과: `origin/main` 기반 새 브랜치 생성 성공. 원격 README가 worktree에 materialize되었고 기존 로컬 README를 덮어쓰지 않았다.

## 10. working tree 상태

최종 검증 시:

```text
## migration/google-drive-to-github...origin/main
?? .gitignore
?? AGENTS.md
?? docs/
?? prompts/
```

- tracked: 원격에서 온 `README.md`만 존재
- staged: 없음
- cached diff: 비어 있음
- migration 후보는 모두 untracked 상태

## 11. .gitignore 변경 내용

루트 `.gitignore`가 없어서 생성했다. 포함된 규칙:

```gitignore
.godot/
*.tmp
*.log
.DS_Store
Thumbs.db

# Preserve the imported handoff bundle locally without staging duplicate files.
/Project_Nostalgia_Codex_Handoff_v0.1/
```

필수 5개 규칙은 `git check-ignore -v`로 각각 작동함을 확인했다.

## 12. 중첩 handoff 폴더 처리 결과

폴더: `Project_Nostalgia_Codex_Handoff_v0.1`

요구된 필수 파일 비교:

| 파일 | 루트 | handoff | SHA-256 일치 |
|---|---:|---:|---:|
| `AGENTS.md` | 있음 | 있음 | 예 |
| `docs/context/PROJECT_CONTEXT.md` | 있음 | 있음 | 예 |
| `prompts/FIRST_CODEX_SESSION.md` | 있음 | 있음 | 예 |
| `docs/ssot/PROJECT_NOSTALGIA_SSOT.md` | 있음 | 있음 | 예 |

전체 handoff 파일 비교:

- 루트에 동일 파일 존재: 11개
- 루트에 같은 경로지만 내용이 다른 파일: 0개
- 루트에 아직 없는 handoff 파일: 1,931개
- 그중 대부분: `source_skills` 원본 1,928개와 handoff manifest/scripts

따라서 “전체 패키지가 루트와 중복”이라는 조건은 충족되지 않았다. 이동이나 삭제는 정보 손실 위험이 있어 수행하지 않았다. 안전한 방법 2를 선택해 **로컬 보존 + `.gitignore` 임시 제외**로 처리했다. `git check-ignore`로 제외를 확인했다.

## 13. 비밀정보 검사 결과

파일명 검색:

- `.env`: 없음
- `.env.*`: 없음
- `*.pem`: 없음
- `*.key`: 없음
- `credentials.json`: 없음
- `secrets.json`: 없음
- `service-account*.json`: 없음

루트 staging 후보(`AGENTS.md`, `docs`, `prompts`)에 대해 대표 secret 패턴도 검색했다.

- private key header: 없음
- `github_pat_...`: 없음
- `ghp_...`: 없음
- Google API key 형태: 없음
- AWS access key 형태: 없음
- 일반 `sk-...` 형태: 없음

발견된 비밀정보 위험: **없음**. 단, staging 전에 동일 검사를 다시 수행하는 것이 안전하다.

## 14. staging에 포함할 후보

현재 `git ls-files --others --exclude-standard` 결과를 기준으로 다음을 후보로 분류한다. 아직 add하지 않았다.

- `.gitignore`
- `AGENTS.md`
- `docs/audits/GODOT_DATA_CORE_AUDIT_v0.1.md`
- `docs/audits/SKILLS_v0.6_VALIDATION.md`
- `docs/context/ARTIFACT_INVENTORY.md`
- `docs/context/KNOWN_CONFLICTS.md`
- `docs/context/PROJECT_CONTEXT.md`
- `docs/context/SSOT_POINTER.md`
- `docs/context/UI_HUMAN_DESIGN_GUIDANCE_v0.1.md`
- `docs/plans/PROJECT_NOSTALGIA_SKILL_CUSTOMIZATION_PLAN.md`
- `docs/reports/SKILL_INVENTORY.md`
- `docs/reports/MIGRATION_VALIDATION.md`
- `docs/ssot/PROJECT_NOSTALGIA_SSOT.md`
- `docs/ssot/SOURCE_METADATA.md`
- `prompts/FIRST_CODEX_SESSION.md`
- `prompts/UI_REVISION_PROMPT_v0.2.md`

주의: 이 보고서는 작성 시점에 untracked라서 앞선 `ls-files` 캡처에는 아직 나타나지 않았으나 staging 후보에 포함한다.

## 15. staging에서 제외할 후보

- `/Project_Nostalgia_Codex_Handoff_v0.1/` 전체 — 중첩 패키지 및 source_skills 원본 보존, 임시 ignore
- `.godot/` — 생성 캐시
- `*.tmp`, `*.log`, `.DS_Store`, `Thumbs.db` — 생성/OS 파일
- 비밀정보 패턴 파일 — 현재 발견되지 않았으나 발견 시 내용 확인 전 staging 금지

`source_skills`는 중첩 handoff 제외 규칙에 의해 staging되지 않으며 로컬 원본은 그대로 보존된다.

## 16. 실행한 명령과 핵심 출력

아래는 실제 수행 명령과 핵심 결과다. 전용 file tools로 수행한 Read/Write/Edit/Glob/Grep도 함께 사용했으며, 여기에는 shell/PowerShell 명령을 중심으로 기록한다.

### 16.1 경로·Git 사전 검사

```powershell
Test-Path C:\Users\User\projects\Project_Nostalgia\.git
Test-Path C:\Users\User\projects\Project_Nostalgia\Project_Nostalgia_Codex_Handoff_v0.1\.git
```

핵심 출력:

```text
ROOT_GIT_EXISTS=False
HANDOFF_GIT_EXISTS=False
```

### 16.2 SSoT 복사와 hash 검증

```powershell
Get-FileHash -Algorithm SHA256 <handoff-source>
New-Item -ItemType Directory -Path <root>\docs\ssot -Force
Copy-Item -LiteralPath <handoff-source> -Destination <canonical-target>
Get-FileHash -Algorithm SHA256 <canonical-target>
```

핵심 출력:

```text
SOURCE_EXISTS=True
TARGET_EXISTS=False
METADATA_EXISTS=False
SOURCE_SHA256=F1F0F3AE6FBD8395DCF60ECC8688B32819C19657F40B853E8299D2145DCF4BD3
TARGET_SHA256=F1F0F3AE6FBD8395DCF60ECC8688B32819C19657F40B853E8299D2145DCF4BD3
HASH_MATCH=True
```

### 16.3 Git 초기화·origin·fetch

```powershell
git -C <root> init
git -C <root> remote add origin https://github.com/galaxygamja/Project_nostalgia.git
git -C <root> fetch origin
git -C <root> remote show origin
git -C <root> branch -a
git -C <root> status --short --branch
```

핵심 출력:

```text
Initialized empty Git repository
origin ... Project_nostalgia.git (fetch/push)
[new branch] main -> origin/main
HEAD branch: main
No commits yet on master
```

### 16.4 migration branch

첫 시도에서 PowerShell 식 안에 세미콜론을 넣은 문법 오류가 발생했다. 저장소 변경 전 parse 단계에서 실패했으며, 명령을 올바른 PowerShell 5.1 구문으로 고쳐 재실행했다.

```powershell
git -C <root> show-ref --verify --quiet refs/heads/migration/google-drive-to-github
git -C <root> show-ref --verify --quiet refs/remotes/origin/migration/google-drive-to-github
git -C <root> switch -c migration/google-drive-to-github --track origin/main
```

핵심 출력:

```text
LOCAL_MIGRATION_BRANCH_EXISTS=False
REMOTE_MIGRATION_BRANCH_EXISTS=False
ROOT_README_EXISTS=False
Switched to a new branch 'migration/google-drive-to-github'
HEAD=b95f5c157779951f0a4071b1494beee4a993b86d
```

### 16.5 handoff 중복·대용량·내부 Git 검사

```powershell
Get-ChildItem <handoff> -File -Recurse
Get-FileHash -Algorithm SHA256 <root-file>, <handoff-file>
Get-ChildItem <root> -Directory -Force -Recurse -Filter .git
Get-ChildItem <root> -File -Force -Recurse | Where-Object Length -ge 10MB
```

핵심 출력:

```text
Required four files: all MATCH=True
SAME_AT_ROOT=11
DIFFERENT_AT_ROOT=0
MISSING_AT_ROOT=1931
Nested .git: root .git only
Large files >= 10 MiB: none
```

### 16.6 ignore·staging·branch 검증

```powershell
git -C <root> check-ignore -v <test-paths>
git -C <root> ls-files --others --exclude-standard
git -C <root> status --short --ignored
git -C <root> diff --cached --stat
git -C <root> diff --cached
git -C <root> rev-parse HEAD
git -C <root> rev-parse origin/main
git -C <root> rev-list --left-right --count origin/main...HEAD
git -C <root> status --porcelain=v2 --branch
```

핵심 출력:

```text
handoff ignored by .gitignore:8
.godot and required file patterns ignored
cached diff: empty
branch.head migration/google-drive-to-github
branch.upstream origin/main
branch.ab +0 -0
HEAD == origin/main == b95f5c157779951f0a4071b1494beee4a993b86d
```

## 17. 실패하거나 건너뛴 작업

### 실패 후 수정

- migration branch 검사 명령 첫 시도: PowerShell 5.1 parse error. Git 명령은 실행되지 않았으며 side effect 없음. 구문 수정 후 성공.

### 의도적으로 건너뜀

- `git add .`: 금지에 따라 미실행
- 선택적 `git add`: 보고·승인 전이므로 미실행
- commit: 미실행
- push: 미실행
- PR: 미생성
- main checkout/수정: 미수행
- force push/reset: 미수행
- handoff 삭제/이동: 전체 중복이 아니므로 미수행
- 실제 Godot 버전 확인: 이번 Phase 0에서 임의 완료 처리하지 않음
- 원본 스킬별 라이선스 재사용 조건 정리: 미완료
- 스킬 커스터마이징: 미시작

## 18. 사용자의 추가 승인이 필요한 항목

1. 위 staging 후보를 개별 경로로 `git add`할지
2. staged diff를 검토한 뒤 migration commit을 생성할지
3. migration branch를 origin에 push할지
4. 중첩 handoff를 장기적으로 archive로 이동할지, 계속 로컬 ignore할지
5. `source_skills`를 향후 별도 archive/source distribution으로 관리할지
6. 실제 Godot 버전 확인을 위한 project artifact 이관 또는 Godot 설치 검증
7. 원본 스킬별 라이선스와 attribution 정리 작업 시작

## Phase 0 결론

- **저장소 정규화·GitHub 이관 준비 하위 범위:** 통과
- **전체 스킬 커스터마이징 Phase 0:** 부분 완료
- 남은 차단 조건:
  - 실제 Godot 버전 확인
  - 원본 스킬별 라이선스 재사용 조건 정리
  - staging/commit/push는 별도 승인 필요
- 스킬 커스터마이징 시작 여부: 아직 시작하지 않음
