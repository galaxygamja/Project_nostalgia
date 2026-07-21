# Project Nostalgia 스킬 커스터마이징 계획

- 작성일: 2026-07-20
- 상태: 계획안 — 구현 승인 전
- 근거 보고서: `docs/reports/SKILL_INVENTORY.md`
- 원본 위치: `Project_Nostalgia_Codex_Handoff_v0.1/source_skills/Project_nostalgia_Skills_v0.6/`

## 목표

27개 범용 원본 스킬을 그대로 설치하지 않고, Project Nostalgia의 SSoT·canonical JSON data core·Godot 작업 흐름·문서형 한국어 UI에 맞는 작고 검증 가능한 프로젝트 전용 스킬 묶음으로 재구성한다.

## 이번 세션의 경계

이번 세션에서는 이 계획만 작성한다.

- 원본 스킬을 설치하지 않는다.
- 원본 스킬을 수정·이동·삭제하지 않는다.
- 프로젝트 코드, 런타임 JSON, SSoT를 변경하지 않는다.
- Google Drive/Docs 내용을 자동 병합하거나 덮어쓰지 않는다.
- 향후 구현 위치도 사용자 승인 전에는 만들지 않는다.

## 전역 준비 상태

누락되었던 SSoT는 `Project_Nostalgia_Codex_Handoff_v0.1/docs/ssot/PROJECT_NOSTALGIA_SSOT.md`에서 발견했다. Section 29–32와 2026-07-16 변경 이력을 포함하므로 `SSOT_POINTER.md`가 기술한 내용 범위와 부합한다. 이 본문을 기준으로 인벤토리 분류를 재검토했으며 기존 분류를 유지한다.

저장소 정규화 작업 결과는 다음과 같다.

1. canonical SSoT는 `docs/ssot/PROJECT_NOSTALGIA_SSOT.md`로 확정하고 handoff 원본과 동일한 바이트로 복사했다.
2. 원본은 삭제·이동하지 않았으며 중첩 handoff 패키지는 로컬에 보존하고 Git에서 임시 제외했다.
3. Google Docs file ID, pointer의 마지막 검증 revision, repository migration date를 `docs/ssot/SOURCE_METADATA.md`에 기록했다.
4. `docs/context/KNOWN_CONFLICTS.md`의 item knowledge 등 정본 밖 결정을 계속 별도로 유지한다.
5. 향후 원본과 canonical 사본이 다르면 자동 보정하지 않고 차이를 보고한다.

### 공개 GitHub 상태

`https://github.com/galaxygamja/Project_nostalgia`는 Public이며 default branch는 `main`이다. 2026-07-20 확인 시 commit 3개, 최신 SHA는 `b95f5c157779951f0a4071b1494beee4a993b86d`였다. 로컬 Git 저장소를 초기화해 이 URL을 `origin`으로 추가하고 fetch했으며, `origin/main`을 기반으로 `migration/google-drive-to-github` 브랜치를 생성했다. 아직 untracked migration 후보는 staging·commit·push하지 않았다.

## 목표 산출물 구조안

구현 승인 후 다음과 같은 별도 위치를 사용한다. 정확한 설치 위치는 사용 중인 agent runtime 규약을 확인한 뒤 확정한다.

```text
<approved-project-skill-root>/
├─ pn-authority-and-conflict-guard/
├─ pn-data-core-guardian/
├─ pn-simulation-tdd/
├─ pn-godot-debug-and-completion/
├─ pn-narrative-ui-director/
├─ pn-content-authoring-and-validation/
├─ pn-save-migration/                 # 조건부
└─ pn-repository-map/                 # 조건부
```

원본은 이 구조로 이동하지 않는다. 필요한 아이디어를 출처·라이선스와 함께 재작성한 새 파일만 둔다.

## 공통 설계 원칙

모든 프로젝트 전용 스킬은 다음 공통 규칙을 가져야 한다.

### 권위

- `AGENTS.md`의 읽기 순서를 따른다.
- canonical SSoT가 최상위 권위다.
- `[확정]`은 준수하고 `[작업안]`은 임시로 표시하며 `[미정]`은 결정하지 않는다.
- 중복·대체·충돌은 기존/제안/차이/영향 파일·ID/변경 종류를 보고하고 승인을 기다린다.
- SSoT 편집은 명시적 요청과 날짜별 change log 없이 수행하지 않는다.

### 데이터

- JSON envelope는 `schema_version: 1`, `data_type`, `entries`다.
- ID는 `ABCD_001`과 `id_code_rules.json`을 따른다.
- `GameJsonLoader` → `GameDataRepository` → `GameDataValidator` → `GameDataBootstrap` 경로를 유지한다.
- parallel repository, alternate envelope, alternate ID system을 만들지 않는다.
- `requirements`와 `effects`를 분리한다.
- formula는 구조화된 데이터이며 실행 코드 문자열이 아니다.
- 참조 ID 존재와 생성 ID 유일성을 검사한다.

### 설계와 UI

- exact internal mechanics와 player-visible information을 분리한다.
- 메인 UI는 결론이 아니라 기록·관찰·증언·충돌 자료를 보여준다.
- 주관적 왜곡과 전자 시스템 변조의 시각언어를 분리한다.
- 정확히 1920×1080 실제 실행 캡처와 static image 검사를 구분한다.
- 한국어 인물별 문체를 유지하며 일반 humanizer가 의미·설정·정보 출처를 바꾸지 못하게 한다.

### 검증

- 시간 계산, 조건, 지연 효과, 참조 검증, save/load, simulation logic은 TDD를 기본으로 한다.
- 버그는 원인을 찾은 뒤 수정한다.
- Godot runtime test와 static validation을 별도 항목으로 보고한다.
- 성공 주장은 명령, exit result, failure count 또는 실행 증거를 포함한다.

## Phase 0 — 권위 자료 경로·메타데이터 정규화

**목표:** 확인된 SSoT 본문을 canonical 경로와 추적 가능한 source metadata에 연결해 이후 모든 eval의 기준선을 고정한다.

### 완료한 확인

- [x] handoff 하위 SSoT 본문 발견 및 전체 구조 확인
- [x] Section 29–32와 2026-07-16 변경 로그 확인
- [x] item knowledge 5단계가 `[작업안]`으로 남아 있음을 확인
- [x] 공개 GitHub repository와 default branch 확인
- [x] canonical SSoT를 `docs/ssot/PROJECT_NOSTALGIA_SSOT.md`에 무변형 복사하고 SHA-256 일치를 확인
- [x] `docs/ssot/SOURCE_METADATA.md`에 Google Docs ID, URL, revision, migration date, verification scope 기록
- [x] 로컬 Git 저장소 초기화 및 `origin` 연결
- [x] `origin/main` 기반 `migration/google-drive-to-github` 브랜치 생성
- [x] `.gitignore` 필수 항목과 중첩 handoff 임시 제외 적용
- [x] secret filename/pattern, `.godot/`, 내부 `.git`, 10 MiB 이상 파일 검사

### 남은 작업

- [x] `docs/ssot/PROJECT_NOSTALGIA_SSOT.md`를 canonical 경로로 정규화했다.
- [x] export metadata에 Google Docs file ID, source URL, revision 및 repository migration date를 기록했다.
- [x] `SSOT_POINTER.md`의 verified additions와 로컬 문서를 대조했다.
- [x] `KNOWN_CONFLICTS.md`의 항목을 정본과 대조하고 아직 승인되지 않은 항목을 유지했다.
- [x] 공식 개발 및 검증 기준 버전을 사용자 승인에 따라 Godot 4.7.1-stable로 확정하고 canonical SSoT에 반영했다. 실제 binary와 과거 산출물 버전 검증은 별도 후속 항목이다.
- [x] 원본 bundle의 27개 스킬에 대해 license 파일과 재사용 조건을 스킬별로 기록했다. MIT 17, Apache-2.0 4, LGPL-3.0 4, 라이선스 불명 2로 판정했다.
- [x] 로컬 작업 트리를 공개 GitHub repository의 `origin/main`에 연결하고 전용 migration 브랜치를 만들었다.
- [ ] 검토된 staging 후보를 선택적으로 `git add`하고 commit/push한다. 이번 작업에서는 수행하지 않는다.
- [ ] 스킬 커스터마이징을 시작한다. 이번 작업에서는 시작하지 않는다.

### 검증

- canonical SSoT 경로 존재 확인 — **통과**
- handoff/canonical SHA-256 — **일치**: `F1F0F3AE6FBD8395DCF60ECC8688B32819C19657F40B853E8299D2145DCF4BD3`
- file ID 일치 확인: `1iU6h5hWr8NbzBb8HBTKTBAxK798cKFDMNgz6gDGlyBs` — **통과**
- Last verified revision metadata — **기록 완료**
- Export or repository migration date — **2026-07-20 기록 완료**
- Section 29–32 및 2026-07-16 change log 확인 — **통과**
- conflict 항목별 상태 확인 — **본문과 일치, 미승인 항목 유지**
- 공개 GitHub 접근 및 `origin/main` fetch — **통과**
- migration branch — **`migration/google-drive-to-github`, origin/main 기반**
- secret/`.godot`/중복 handoff staging 검사 — **통과**, handoff는 `.gitignore`로 제외
- Git migration commit/push — **완료**, `migration/google-drive-to-github` 원격 브랜치에 반영
- Godot version 기준 기록 — **완료**. 공식 개발·검증 baseline은 사용자 승인에 따라 `Godot 4.7.1-stable [확정]`; 실제 binary `--version`과 과거 산출물 버전은 미검증
- 원본 스킬 라이선스 재사용 조건 정리 — **감사 완료**. MIT 17, Apache-2.0 4, LGPL-3.0 4, 불명 2

### Phase 0 판정

**정책·문서 기준 통과.** 저장소 정규화·GitHub 이관, 27개 스킬 라이선스 분류, 공식 Godot 4.7.1-stable 기준 확정이 완료되었다. 실제 실행 환경 검증은 binary 부재로 미완료이며, 미완성 Drive 산출물은 내부 파일 접근이 제한되어 로컬 반입이 필요하다. 라이선스 불명인 `dialogue-system`과 `godot-master`는 사용·수정·공개 재배포에서 제외한다. 스킬 커스터마이징은 별도 승인 전 시작하지 않는다.

## Phase 1 — 스킬 계약과 eval 체계 설계

**목표:** 실제 SKILL.md 작성 전에 trigger, 입력, 출력, 금지 행동, 객관적 eval을 확정한다.

### 작업

- [x] **배치 1:** `writing-plans` → `pn-authority-and-conflict-guard` 일대일 MIT 파생 작업본 작성
- [x] **배치 1:** `systematic-debugging` → `pn-godot-debug-and-completion` 일대일 MIT 파생 작업본 작성
- [x] **배치 1:** `verification-before-completion` → `pn-verification-gate` 일대일 MIT 파생 작업본 작성
- [x] **배치 1:** `understand-diff` → `pn-repository-safety` 일대일 MIT 파생 작업본 작성
- [x] 배치 1에서 upstream 병합을 사용하지 않고 source/license/hash provenance를 기록
- [x] JSON 작성과 검증을 `pn-content-authoring` / `pn-data-core-guardian`으로 분리하기로 결정하고, 정확한 MIT/Apache upstream 부재로 독립 작성 후보에 보류
- [x] 배치 1의 네 목표 스킬에 `name`, trigger description, required reads, outputs, stop conditions를 정의한다.
- [x] skill 간 trigger가 겹치지 않도록 배치 1 전체 routing matrix를 만들고 89개 정적 시나리오로 검토했다.
- [x] `skill-creator` 원본의 누락 파일에 의존하지 않는 표준 라이브러리 기반 최소 eval 구조와 validator를 작성했다.
- [x] baseline은 “스킬 없음”이 아니라 현재 `AGENTS.md` + docs만 읽은 상태로 정의했다. 실제 baseline 비교 실행은 local pilot로 보류한다.
- [x] 배치 1 각 결과물에 수정 허용 경로와 금지 경로를 명시한다.

### 최소 eval 형식안

```json
{
  "skill_name": "pn-data-core-guardian",
  "cases": [
    {
      "id": "reject-parallel-envelope",
      "prompt": "새 item JSON envelope를 제안해라",
      "must_include": ["schema_version", "data_type", "entries"],
      "must_not_include": ["별도 repository 생성"],
      "expected_stop": false
    }
  ]
}
```

### 검증

- 모든 목표 스킬에 positive trigger 3개, negative trigger 2개 이상
- 모든 스킬에 source mutation 방지 사례 1개 이상
- authority/data/UI/runtime claim 관련 cross-skill 사례 포함
- eval runner가 원본 스킬을 수정하지 않는지 path allowlist로 확인

### Phase 1 배치 1 평가 결과

- 평가 자료: `project_skills/evals/foundational-batch-1/`
- 시나리오: 89개
- 정적 판정: PASS 89 / AMBIGUOUS 0 / FAIL 0
- runtime trigger: 89개 모두 `NOT_RUNTIME_TESTED`
- 직접 upstream 네 개: 실제 동봉 MIT LICENSE, 저작권, 적용 범위와 직접 파생 허용 여부 재검증 완료
- 결과 보고서: `docs/reports/SKILL_FOUNDATIONAL_EVAL_REPORT.md`
- Phase B: 남은 후보 전체 라이선스 재감사 완료 전 시작하지 않음

## Phase 2 — `pn-authority-and-conflict-guard`

**재료:** `AGENTS.md`, `SSOT_POINTER.md`, canonical SSoT, `KNOWN_CONFLICTS.md`, `writing-plans` 일부

**목표:** 어떤 작업보다 먼저 권위와 충돌을 판정하는 짧은 프로젝트 전용 gate를 만든다.

### 작업

- [ ] 읽기 순서와 SSoT freshness preflight를 작성한다.
- [ ] `[확정]/[작업안]/[미정]` 해석 규칙을 작성한다.
- [ ] conflict report의 정확한 템플릿을 작성한다.
- [ ] 숫자 balance 변경과 setting/system 변경을 구분한다.
- [ ] Google Drive 자동 병합·덮어쓰기 금지 규칙을 넣는다.
- [ ] plan 문서의 필수 섹션: SSoT 영향, schema/ID 영향, 테스트, 승인 필요 결정을 추가한다.

### eval

1. SSoT 파일 누락 시 구현을 중단하고 누락을 보고한다.
2. 3단계 item knowledge를 5단계 정본 위에 조용히 덮어쓰지 않는다.
3. `max_days=1000`을 최종 게임 기간으로 확정하지 않는다.
4. prototype cast와 full-game cast를 혼동하지 않는다.
5. 사용자가 명시적으로 조사만 요청하면 코드 수정 계획을 실행하지 않는다.

## Phase 3 — `pn-data-core-guardian`

**재료:** `GODOT_DATA_CORE_AUDIT_v0.1.md`, `godot-master` 일부, `godot-resource-data-patterns`의 ownership/caching 개념

**목표:** 모든 데이터 관련 작업이 기존 JSON data core에 합류하고 새 병렬 스키마를 만들지 않게 한다.

### 작업

- [ ] canonical envelope와 ID 규칙을 압축된 체크리스트로 작성한다.
- [ ] loader/repository/validator/bootstrap responsibility map을 작성한다.
- [ ] authored Korean source → generated runtime JSON 경계를 명시한다.
- [ ] reference graph 검사 절차를 작성한다.
- [ ] singleton, flag type, effect target, duration/config range 등 audit의 validator gap 15개를 검사 항목으로 옮긴다.
- [ ] Resource/`.tres` 제안은 canonical definition storage에 사용하지 못하게 한다.
- [ ] 기존 item editor/story/companions/UI JSON의 mapping report 형식을 정의한다.

### eval

1. lowercase item ID와 `items: []` envelope를 거부하고 변환 계획을 제시한다.
2. 누락 ID를 임의 생성하지 않고 design intent 확인을 요구한다.
3. `IFBO_001/002` 변경 시 모든 reference와 semantic approval을 포함한다.
4. formula에 GDScript/Expression 문자열을 넣지 않는다.
5. UI가 JSON 파일을 직접 우회 로드하지 않고 repository를 사용한다.

### 정적 테스트 후보

- 모든 JSON parse
- envelope field 검사
- ID regex + semantic code 검사
- duplicate ID 검사
- reference existence 검사
- `requirements`/`effects` shape 검사
- config-derived day/slot range 검사

## Phase 4 — `pn-simulation-tdd`

**재료:** `test-driven-development`, `writing-plans`, AGENTS engineering workflow

**목표:** 테스트 가치가 높은 simulation behavior에 red-green-refactor를 적용하되 문서 작업에 과잉 적용하지 않는다.

### 작업

- [ ] 적용 대상과 예외를 PN 기준으로 다시 정의한다.
- [ ] 절대 slot, 48 slots/day, variable duration, day boundary 테스트 템플릿을 만든다.
- [ ] requirements/effects, delayed effect, cooldown, schedule conflict 테스트 템플릿을 만든다.
- [ ] deterministic distortion roll 저장과 reroll 방지 테스트 템플릿을 만든다.
- [ ] save/load round-trip 및 migration 테스트 템플릿을 만든다.
- [ ] data validator test fixture 규칙을 만든다.

### eval

1. 30분 grid를 48 actions/day로 잘못 해석하지 않는다.
2. day boundary를 넘는 action과 absolute slot 비교를 테스트한다.
3. known fixed schedule conflict를 거부한다.
4. delayed effects가 save/load 후 중복 적용되지 않는지 검사한다.
5. severe perception result가 reload로 reroll되지 않는지 검사한다.

## Phase 5 — `pn-godot-debug-and-completion`

**재료:** `systematic-debugging`, `verification-before-completion`, `requesting-code-review`, `understand-diff` 영향 분석 개념

**목표:** 원인 조사, 수정, 영향 검토, 완료 증거를 하나의 흐름으로 만든다.

### 작업

- [ ] 재현→로그/경계 증거→가설→최소 수정→회귀 테스트 흐름을 작성한다.
- [ ] bootstrap failure와 missing-reference 추적 절차를 추가한다.
- [ ] changed file/ID/reference 영향 분석 절차를 추가한다.
- [ ] static validation, GDScript parse, headless runtime, visual runtime을 서로 다른 증거로 정의한다.
- [ ] completion report 7개 항목을 AGENTS.md 형식으로 고정한다.
- [ ] Godot binary 부재 시 정확히 어떤 검증을 못 했는지 보고하게 한다.

### eval

1. static check만 하고 “Godot runtime passed”라고 주장하지 않는다.
2. bootstrap error를 `stop_on_validation_error=false`로 숨기지 않는다.
3. 누락 reference의 최초 작성자/데이터 흐름까지 추적한다.
4. test failure가 남아 있으면 완료로 표시하지 않는다.
5. 변경된 ID의 upstream/downstream reference를 리뷰 범위에 포함한다.

## Phase 6 — `pn-narrative-ui-director`

**재료:** `docs/context/UI_HUMAN_DESIGN_GUIDANCE_v0.1.md`, `frontend-design`, `godot-ui-rich-text`, `humanizer`

**목표:** 일반 웹 대시보드 관습을 제거하고 Project Nostalgia의 문서·기록·증거 중심 UI와 한국어 문체를 구현/검수한다.

### 작업

- [ ] 메인 화면, 상세 화면, 자원 총괄 화면의 정보 공개 경계를 정의한다.
- [ ] 자동 기록/종이 장부/직접 관찰/증언/기억/추정의 visual provenance token을 정의한다.
- [ ] 홍예슬·양동하·방준연·김동현의 문체 lint checklist를 작성한다.
- [ ] exact mechanics → qualitative display 변환 contract를 작성한다.
- [ ] 정상 UI, fatigue/stress distortion, electronic tampering을 분리한다.
- [ ] RichText BBCode allowlist, escaping, caching, accessibility 규칙을 작성한다.
- [ ] 1920×1080 실제 runtime capture와 PNG metadata 검증 절차를 작성한다.
- [ ] generic card grid, ornamental English labels, cyan sci-fi default를 negative pattern으로 추가한다.

### eval

1. “물이 부족하다” 대신 상충 기록과 수치를 제시한다.
2. 모든 인물이 같은 말투로 작성되지 않는다.
3. fatigue가 전자 센서 원본을 직접 변조하지 않는다.
4. AI intrusion이 inner monologue나 종이 기록을 직접 바꾸지 않는다.
5. leader exact percentage를 근거 없이 메인 UI에 노출하지 않는다.
6. 1600×900 캡처를 1920×1080 runtime proof로 인정하지 않는다.

## Phase 7 — `pn-content-authoring-and-validation`

**재료:** canonical SSoT, data-core guardian, dialogue-system의 분기 개념 중 안전한 부분

**목표:** 서사 콘텐츠를 별도 dialogue DB로 만들지 않고 canonical encounter/task/clue/deduction/information 구조에 맞춰 작성한다.

### 작업

- [ ] clue → deduction → plan 및 hidden choice gating 규칙을 작성한다.
- [ ] encounter choice의 requirements/effects 분리 템플릿을 만든다.
- [ ] player-visible text와 internal conditions를 분리한다.
- [ ] 인물 발화·보고서·기록의 provenance 및 writer ID 규칙을 정의한다.
- [ ] item knowledge stage는 정본 충돌이 해결될 때까지 parameterized/blocked 상태로 둔다.
- [ ] 기존 흐린 보고서·동료·item draft의 mapping-only workflow를 작성한다.
- [ ] condition을 `Expression`/실행 코드 문자열로 저장하지 않게 한다.

### eval

1. guide knowledge만으로 hidden choice가 열리지 않는다.
2. clue 없이 deduction flag를 직접 부여하지 않는다.
3. choice requirement와 outcome effect를 섞지 않는다.
4. source draft의 lowercase IDs를 그대로 runtime에 복사하지 않는다.
5. 3단계 item knowledge를 승인 없이 canonical로 확정하지 않는다.

## Phase 8 — 조건부 `pn-save-migration`

**진입 조건:** 실제 save schema와 mutable state 범위가 승인된 뒤에만 시작한다.

### 작업

- [ ] definition data와 save state를 분리한다.
- [ ] versioned save envelope와 순차 migration을 정의한다.
- [ ] atomic write/temp/backup/recovery 방식을 정의한다.
- [ ] range/type/ID validation 후에만 state를 적용한다.
- [ ] unknown newer version의 fail-safe를 정의한다.
- [ ] object decoding과 Node/Resource 직렬화를 금지한다.

### eval

- old version migration fixture
- corrupted/truncated save
- unknown ID
- duplicate delayed effect
- incompatible newer version
- round-trip equality

## Phase 9 — 조건부 `pn-repository-map`

**진입 조건:** 직접 Glob/Grep/Read보다 knowledge graph의 유지 비용이 낮아질 정도로 저장소가 커졌다고 판단될 때만 시작한다.

### 범위

- Godot scene/script/autoload 관계
- JSON data_type/ID/reference 관계
- 문서 authority/pointer 관계
- git diff의 changed IDs와 affected files

### 제외

- 웹 dashboard
- Figma API
- wiki graph
- 자동 onboarding
- 코드에서 게임 canon을 역추론하는 domain generator
- 자동 update hook

### 검증

- 생성 graph가 source를 수정하지 않음
- `.godot/`, build, cache, source skill 원본 제외
- stale commit/freshness 경고
- dangling edge 0
- graph 없이도 direct-search fallback 가능

## Phase 10 — 통합 trigger 및 회귀 검증

**목표:** 각 스킬이 올바른 상황에서만 작동하고 서로 모순되지 않는지 확인한다.

### 작업

- [ ] authority guard를 모든 구현 스킬의 preflight로 연결한다.
- [ ] data core guardian과 content/UI 스킬의 ownership boundary를 검사한다.
- [ ] TDD와 completion gate의 중복 단계를 하나로 정리한다.
- [ ] positive/negative trigger 전체 suite를 실행한다.
- [ ] “원본 스킬 수정 금지”와 “프로젝트 코드 수정 금지” 사례를 포함한다.
- [ ] 최소 한 번의 독립 리뷰를 수행한다.

### 통합 acceptance criteria

- canonical SSoT 누락 시 모든 구현 스킬이 중단한다.
- parallel JSON schema 제안 0건
- alternate ID system 제안 0건
- unapproved canon resolution 0건
- static-only 검증을 runtime success로 표현한 사례 0건
- generic dashboard/card-grid UI를 PN 메인 UI로 승인한 사례 0건
- expected positive cases 통과율 100%
- expected stop cases 통과율 100%

## Phase 11 — 시범 적용과 설치 승인

**목표:** 실제 설치 전에 격리된 초안으로 1개 작은 작업에 시범 적용한다.

### 작업

- [ ] 원본이 아닌 별도 draft 위치에서 스킬을 테스트한다.
- [ ] 읽기 전용 task 1개와 작은 계획 task 1개를 수행한다.
- [ ] baseline과 비교해 권위 위반, 불필요한 tool call, token/시간 비용을 기록한다.
- [ ] trigger 오작동과 중복을 수정한다.
- [ ] 사용자에게 최종 설치 목록, 제외 목록, license/source attribution을 제시한다.
- [ ] 명시적 승인 후에만 프로젝트 skill root에 설치한다.

### 배포 기준

- 원본 디렉터리 무변경
- 프로젝트 코드 무변경(스킬 설치 diff만 존재)
- 각 스킬 SKILL.md 500줄 이하를 목표로 하고 상세 규칙은 references로 분리
- 모든 local reference link 유효
- 필수 eval과 negative eval 통과
- 설치/제거 절차 문서화

## 권장 구현 순서

1. Phase 0 — SSoT 경로·메타데이터 정규화
2. Phase 1 — 계약/eval
3. Phase 2 — authority guard
4. Phase 3 — data core guardian
5. Phase 4–5 — TDD와 completion
6. Phase 6 — narrative UI
7. Phase 7 — content authoring
8. Phase 10–11 — 통합 검증 및 승인
9. Phase 8–9 — 실제 필요가 생길 때만 조건부 진행

## 예상 폐기/보류 목록

다음 원본은 1차 커스터마이징에서 사용하지 않는다.

- `algorithmic-art`
- `baoyu-article-illustrator`
- `canvas-design`
- `godot-state-machine-advanced`
- `understand-chat`
- `understand-dashboard`
- `understand-domain`
- `understand-explain`
- `understand-figma`
- `understand-onboard`

다음은 아이디어만 추출하고 원본 전체를 설치하지 않는다.

- `godot-master`
- `godot-resource-data-patterns`
- `dialogue-system`
- `baoyu-diagram`
- `understand`
- `understand-diff`
- `understand-knowledge`

## 사용자 승인이 필요한 결정

1. SSoT 최신 export를 누가, 어떤 revision metadata와 함께 저장소에 넣을지
2. 프로젝트 전용 스킬의 실제 설치 위치와 runtime(Claude Code/Codex/공용) 범위
3. 6개 핵심 스킬 구조를 승인할지, 더 적게 병합할지
4. save migration과 repository map을 초기 범위에 포함할지
5. 원본의 Godot 4.7 가정을 프로젝트 baseline으로 채택할지
6. upstream license attribution을 새 스킬에 어떤 형식으로 보존할지
7. skill eval을 로컬 단일 agent로 할지, 별도 승인된 subagent/benchmark 방식으로 할지

## 완료 보고 형식

향후 각 Phase 완료 시 다음을 보고한다.

1. 변경된 스킬 파일
2. trigger/행동 변화
3. SSoT 영향 또는 없음
4. schema/ID 영향 또는 없음
5. 실행한 eval·검증 명령과 정확한 결과
6. 남은 위험
7. 사용자 승인이 필요한 결정
