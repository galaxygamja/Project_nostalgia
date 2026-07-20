# Project Nostalgia 스킬 인벤토리

- 조사일: 2026-07-20
- 조사 대상: `Project_Nostalgia_Codex_Handoff_v0.1/source_skills/Project_nostalgia_Skills_v0.6/`
- 발견한 `SKILL.md`: 27개
- 작업 성격: 읽기 전용 인벤토리 및 분류
- 원본 스킬 설치·수정: 하지 않음
- 프로젝트 코드·런타임 JSON·SSoT 수정: 하지 않음

## 1. 선행 조건과 한계

### 1.1 SSoT 재확인 상태

누락되었던 SSoT는 다음 위치에서 발견했다.

`Project_Nostalgia_Codex_Handoff_v0.1/docs/ssot/PROJECT_NOSTALGIA_SSOT.md`

본문에는 `docs/context/SSOT_POINTER.md`가 요구한 Section 29–32와 2026-07-16 변경 이력이 포함되어 있다. 따라서 **내용 범위 기준으로는 pointer가 설명한 마지막 검증본과 부합한다.** 다만 다음 두 가지 정리가 남아 있다.

- `AGENTS.md`와 pointer가 지정한 canonical 경로 `docs/ssot/PROJECT_NOSTALGIA_SSOT.md`에는 아직 파일이 없다.
- SSoT 파일 내부에는 Google Docs file ID, 검증 revision, export 시각이 없어 pointer에 적힌 revision과 byte-for-byte 동일하거나 더 최신인지는 입증할 수 없다.

이에 따라 본 인벤토리의 프로젝트 적합성 판단은 SSoT 본문으로 재검토해 유지하되, 프로젝트 전용 스킬의 실제 구현·설치 전에는 canonical 경로와 source metadata를 정리해야 한다. 외부 Google Docs 내용을 자동 병합하거나 덮어쓰지는 않는다.

### 1.2 실제 source_skills 위치

사용자 설명의 `source_skills`는 저장소 루트 바로 아래가 아니라 다음 handoff 하위에 있다.

`Project_Nostalgia_Codex_Handoff_v0.1/source_skills/Project_nostalgia_Skills_v0.6/`

### 1.3 공개 GitHub 저장소 상태

2026-07-20에 `https://github.com/galaxygamja/Project_nostalgia`를 비로그인 상태로 확인했다.

- 공개 상태: Public, 접근 가능
- default branch: `main`
- commit 수: 3
- 최신 commit: `b95f5c157779951f0a4071b1494beee4a993b86d` (`Update README.md`, 2026-07-20 09:33:06 UTC)
- 원격 `main`의 top-level content: `README.md`만 존재
- 원격에는 현재 `docs/ssot`, `source_skills`, 본 인벤토리와 계획이 없다.
- 현재 로컬 작업 폴더와 handoff 폴더에는 `.git` metadata가 없어 원격 commit과 로컬 파일의 계보·동기화 상태를 Git으로 비교할 수 없다.

따라서 저장소의 public 전환은 확인했지만, 원격 GitHub가 아직 이 로컬 handoff의 canonical 백업 또는 최신 source라고 볼 수는 없다.

### 1.4 판정 기준

- **핵심 필요**: 프로젝트 전용으로 개조하여 상시 작업 흐름에 포함할 가치가 높다.
- **조건부 필요**: 특정 작업이 시작될 때만 좁게 개조하거나 참고한다.
- **불필요/보류**: 현재 범위와 직접 관련이 없거나, 비용·중복·외부 의존성이 이득보다 크다.
- **폐기**: 원본 파일 삭제가 아니라 Project Nostalgia용 배포 후보에서 제외한다는 뜻이다.

## 2. 요약 결론

### 2.1 권장 최종 형태

27개 원본을 그대로 설치하지 말고, 다음 **6개 프로젝트 전용 스킬**로 축소하는 편이 안전하다.

1. `pn-authority-and-conflict-guard` — SSoT 우선순위, 충돌 보고, 승인 게이트
2. `pn-data-core-guardian` — canonical JSON envelope, ID, 참조, loader/repository/validator/bootstrap 강제
3. `pn-simulation-tdd` — 시간·조건·지연 효과·저장/불러오기용 TDD와 검증
4. `pn-godot-debug-and-completion` — 재현→원인→수정→실행 증거의 통합 품질 게이트
5. `pn-narrative-ui-director` — 1920×1080 문서형 UI, 질적 정보, 한국어 인물별 문체, RichText 안전성
6. `pn-content-authoring-and-validation` — encounter/task/clue/deduction/item/character 작성과 ID 교차 검증

선택적으로 다음 2개를 별도 유지할 수 있다.

7. `pn-save-migration` — 저장 형식이 실제로 도입될 때만 활성화
8. `pn-repository-map` — 저장소 규모가 커진 뒤 가벼운 구조/영향 분석이 필요할 때만 도입

### 2.2 분류 개수

| 분류 | 개수 | 의미 |
|---|---:|---|
| 핵심 필요 | 8 | 프로젝트 전용 스킬의 직접 재료 |
| 조건부 필요 | 9 | 일부만 추출하거나 특정 단계에서 사용 |
| 불필요/보류 | 10 | 현재 설치·개조 대상에서 제외 |
| 합계 | 27 | 발견한 모든 `SKILL.md` |

### 2.3 가장 큰 위험

- Godot 범용 스킬들이 `.tres`/Resource 기반 데이터 저장소를 기본값으로 제안하여 canonical JSON data core와 충돌한다.
- dialogue 스킬은 별도 DialogueData/DialogueManager와 실행 가능한 조건 문자열을 제안해, 기존 encounter/requirements/effects 및 “공식은 실행 코드 문자열이 아니다” 원칙과 충돌한다.
- `godot-master`는 182개의 참조 문서를 가진 과대 범위 허브이며, Project Nostalgia에 무관한 3D·멀티플레이·액션 장르 규칙과 강한 보편 명령을 다수 포함한다.
- `skill-creator`는 핵심 eval 도구와 참조가 누락되어 원본 상태로는 자체 워크플로를 완주할 수 없다.
- Understand Anything 묶음은 완전한 플러그인/monorepo에 가깝고, 설치·Node 22+·pnpm 10+·생성물 디렉터리·대시보드 실행을 요구한다. 단순 스킬 설치보다 운영 부담이 크다.
- UI/도식 스킬의 청록색·카드·대시보드 관습은 Project Nostalgia의 문서형 UI 지침과 직접 충돌할 수 있다.

## 3. 전체 인벤토리

경로는 조사 루트인 `Project_nostalgia_Skills_v0.6/` 기준 상대 경로다.

| # | 이름 | 경로 | 목적 | 중복 가능성 | 로컬 참조 파일 상태 | PN 판정 | 권고 |
|---:|---|---|---|---|---|---|---|
| 1 | `algorithmic-art` | `algorithmic-art/SKILL.md` | p5.js 기반 seeded generative art와 HTML viewer 생성 | `canvas-design`, 시각 제작 계열과 일부 중복 | `templates/viewer.html`, `generator_template.js` 존재. 자체 지시 경로 충족 | 불필요/보류 | **폐기**. 게임 런타임, UI 구현, 데이터 코어와 직접 관련 없음 |
| 2 | `baoyu-article-illustrator` | `baoyu-article-illustrator/SKILL.md` | 문서 구조를 분석해 raster 삽화 생성 | `canvas-design`, `baoyu-diagram`과 시각 산출물 영역 중복 | workflow/style/prompt/config/codex-imagegen 참조 존재. 다만 실제 image backend와 `EXTEND.md`는 번들 밖 런타임 의존 | 불필요/보류 | **폐기**. 외부 이미지 백엔드와 설정 부담이 크고 현재 핵심 산출물이 아님 |
| 3 | `baoyu-diagram` | `baoyu-diagram/SKILL.md` | SVG 아키텍처·흐름·시퀀스·구조 다이어그램 | Understand dashboard, 문서 시각화와 일부 중복 | 4개 reference와 `scripts/main.ts` 존재 | 조건부 필요 | **개조**. 설계 문서용으로만 유지하고 dark/cyan 기본 팔레트 제거; 게임 UI 자산 생성에는 사용 금지 |
| 4 | `humanizer` | `blader_humanizer/SKILL.md` | AI 문체 흔적을 줄이고 자연스러운 문장으로 편집 | `pn-human-ui-director`, frontend copy 지침과 중복 | 단일 SKILL.md와 라이선스. 외부 파일 의존 없음 | 조건부 필요 | **분리·개조**. 일반 humanizer가 아니라 한국어 기록문/인물별 문체 검사기로 좁힘 |
| 5 | `canvas-design` | `canvas-design/SKILL.md` | PNG/PDF 정적 아트와 디자인 철학 생성 | `algorithmic-art`, article illustrator, frontend design과 중복 | SKILL은 `./canvas-fonts`를 요구하지만 해당 폴더 없음 | 불필요/보류 | **폐기**. 누락 자산과 미술 중심 워크플로; 1920×1080 실제 Godot UI 검증을 대체할 수 없음 |
| 6 | `frontend-design` | `frontend-design/SKILL.md` | 비정형·의도적인 프런트엔드 시각 설계와 UI copy | `pn-human-ui-director`, `godot-master` UI refs와 중복 | 단일 SKILL.md, 로컬 보조 파일 없음 | 핵심 필요 | **병합·개조**. `UI_HUMAN_DESIGN_GUIDANCE_v0.1.md`와 합쳐 Godot 문서형 UI 전용으로 전환 |
| 7 | `godot-resource-data-patterns` | `Godot Resource Data Patterns/SKILL.md` | Resource/RefCounted, `.tres`, typed arrays, 데이터 캐시 패턴 | `godot-master`의 resource-data-patterns와 고중복 | 10개 GDScript 예제 존재, 명시 링크 충족 | 조건부 필요 | **대폭 개조**. RefCounted/ownership/caching만 취하고 `.tres` DB·Resource 저장은 canonical JSON 대안으로 쓰지 못하게 차단 |
| 8 | `dialogue-system` | `godot-dialogue-system-1.0.0/SKILL.md` | 분기 대화, 조건, UI, JSON 외부 형식 | `godot-master/dialogue-system`, `godot-ui-rich-text`와 중복 | 5개 references 모두 존재 | 조건부 필요 | **분리·개조**. UI 표시와 분기 개념만 취함. 별도 DialogueData/Manager, Resource DB, `Expression` 조건 문자열은 폐기 |
| 9 | `godot-master` | `godot-master/SKILL.md` | Godot 4.7+ 범용 92-domain 지식 허브 | 4개 독립 Godot 스킬과 직접 중복; 내부 refs도 중복 | references 182개 존재. 매우 방대하며 일부 범용/무관 영역 포함 | 조건부 필요 | **분리**. 필요한 refs만 추출: GDScript, testing, save/load, UI containers/theming/rich text, simulation, survival, visual novel, performance. 원본 허브는 설치하지 않음 |
| 10 | `godot-save-load-systems` | `godot-save-load-systems/SKILL.md` | 버전·마이그레이션·오류 복구를 갖춘 저장/불러오기 | `godot-master/save-load-systems`, resource data patterns와 중복 | 3개 GDScript 존재 | 핵심 필요 | **개조**. canonical runtime state와 ID 검증 중심으로 축소; PERSIST group/Node 직렬화와 위험한 object decoding 예제 제거 |
| 11 | `godot-state-machine-advanced` | `godot-state-machine-advanced/SKILL.md` | HSM/pushdown/상태 전이 패턴 | `godot-master/state-machine-advanced`와 중복 | 12개 GDScript 존재. SKILL에서 필수로 요구한 `hsm_logic_state.gd`도 존재 | 불필요/보류 | **폐기/보류**. 현재 텍스트·데이터 중심 시뮬레이션에 과도함; 실제 복합 AI가 확정될 때 재평가 |
| 12 | `godot-ui-rich-text` | `godot-ui-rich-text/SKILL.md` | RichTextLabel, BBCode, 링크, 효과, typewriter | dialogue-system, godot-master UI rich-text와 중복 | 12개 GDScript 존재. SKILL의 명시 스크립트 존재 | 핵심 필요 | **분리·개조**. 문서 표면, 출처 표시, 접근성, 안전한 BBCode만 유지. rainbow/glitch 남용과 주관 왜곡/AI 침입 시각언어 혼동 금지 |
| 13 | `requesting-code-review` | `requesting-code-review/SKILL.md` | 단계·병합 전 독립 코드 리뷰 | verification-before-completion, understand-diff와 일부 중복 | `code-reviewer.md` 존재 | 조건부 필요 | **병합**. completion gate에 리뷰 체크포인트로 흡수; 모든 소규모 변경 강제 규칙은 완화 |
| 14 | `skill-creator` | `skill-creator/SKILL.md` | 스킬 작성, eval, trigger 최적화 | writing-plans와 계획 부분 일부 중복 | **불완전**: SKILL이 요구하는 `references/schemas.md`, `scripts.aggregate_benchmark`, `agents/grader.md`, `agents/analyzer.md`, `eval-viewer/generate_review.py` 없음. 루트 `schemas.md`, `eval_review.html`만 존재 | 핵심 필요 | **재구축**. 누락 도구에 의존하지 않는 PN 전용 eval harness를 새로 설계; 원본 직접 사용 금지 |
| 15 | `systematic-debugging` | `systematic-debugging/SKILL.md` | 재현, 증거 수집, 원인 추적, 최소 가설 검증 | verification, TDD, godot-master debugging과 중복 | root-cause/defense/waiting 문서와 예제·테스트 존재 | 핵심 필요 | **병합·개조**. Godot/JSON bootstrap/reference failure용 디버깅 게이트로 유지 |
| 16 | `test-driven-development` | `test-driven-development/SKILL.md` | red-green-refactor를 강제하는 범용 TDD | systematic debugging, verification, writing-plans와 중복 | 단일 SKILL.md와 라이선스, 외부 참조 없음 | 핵심 필요 | **개조**. AGENTS.md가 지정한 시간·조건·지연 효과·참조·save/load·simulation에 집중. 문서/데이터 초안까지 무조건 TDD하는 과잉 적용 방지 |
| 17 | `understand` | `.../skills/understand/SKILL.md` | 코드베이스 전체 knowledge graph 생성 | onboard/domain/explain/chat/dashboard의 기반; Godot master architecture와 일부 중복 | scripts, language/framework/locale refs 존재. 상위 monorepo·agents·packages도 존재 | 조건부 필요 | **보류 또는 경량 재작성**. 전체 플러그인 설치 대신 Godot/JSON/Markdown 구조 맵만 생성하는 읽기 전용 PN 버전 검토 |
| 18 | `understand-chat` | `.../skills/understand-chat/SKILL.md` | knowledge graph 기반 코드 질문 | `understand-explain`과 고중복 | 자체 파일 없음; `understand` 산출물과 Git/Bash 전제 | 불필요/보류 | **병합**. 도입한다면 `pn-repository-map`의 query 모드로 흡수 |
| 19 | `understand-dashboard` | `.../skills/understand-dashboard/SKILL.md` | knowledge graph 웹 대시보드 실행 | graph 조회 스킬들과 결합 | 상위 dashboard package와 release viewer에 의존; npx/network 실행 경로 포함 | 불필요/보류 | **폐기**. 현재 보고서/CLI 흐름에 비해 설치·네트워크·UI 운영 비용이 큼 |
| 20 | `understand-diff` | `.../skills/understand-diff/SKILL.md` | git diff의 영향 범위와 위험 분석 | requesting-code-review와 고중복 | 자체 파일 없음; graph 전제 | 조건부 필요 | **병합**. 코드 리뷰 스킬의 영향 분석 단계에 흡수하고 graph가 없을 때 직접 검색 fallback 제공 |
| 21 | `understand-domain` | `.../skills/understand-domain/SKILL.md` | 코드에서 비즈니스 도메인과 흐름 추출 | `understand`, onboard와 중복 | `extract-domain-context.py`와 상위 `domain-analyzer.md` 존재 | 불필요/보류 | **폐기**. 게임 설계 도메인의 권위는 코드 추론이 아니라 SSoT이며, 역추론이 설정을 오염시킬 위험이 있음 |
| 22 | `understand-explain` | `.../skills/understand-explain/SKILL.md` | 특정 파일/함수/모듈 심층 설명 | understand-chat과 고중복 | 자체 파일 없음; graph 전제 | 불필요/보류 | **병합**. 필요 시 repository-map query 모드로 흡수 |
| 23 | `understand-figma` | `.../skills/understand-figma/SKILL.md` | Figma API로 디자인 knowledge graph 생성 | dashboard/graph 계열 | scan/merge scripts 및 design analyzer 존재. FIGMA_TOKEN, 외부 API, Node/pnpm 필요 | 불필요/보류 | **폐기**. 현재 Figma 원본이 권위 자료로 지정되지 않았고 외부 토큰/네트워크 의존 |
| 24 | `understand-knowledge` | `.../skills/understand-knowledge/SKILL.md` | Karpathy형 wiki를 knowledge graph로 변환 | understand/domain/dashboard와 중복 | parse/merge scripts와 article analyzer 존재 | 조건부 필요 | **보류**. 향후 SSoT가 wikilink 기반 지식베이스로 전환될 때만 재평가; 지금은 정본을 그래프로 재해석하지 않음 |
| 25 | `understand-onboard` | `.../skills/understand-onboard/SKILL.md` | graph 기반 onboarding 문서 생성 | AGENTS/context 문서와 기능 중복 | 자체 파일 없음; graph 전제 | 불필요/보류 | **폐기**. 현재 AGENTS.md와 docs/context가 온보딩 권위이며 자동 생성물이 낡은 정보를 재생산할 수 있음 |
| 26 | `verification-before-completion` | `verification-before-completion/SKILL.md` | 완료 주장 전에 신선한 실행 증거 요구 | requesting-code-review, TDD, systematic-debugging과 중복 | 단일 SKILL.md와 라이선스; 외부 의존 없음 | 핵심 필요 | **병합·개조**. Godot 런타임 검증과 static validation을 명시적으로 구분하는 PN completion gate의 기반 |
| 27 | `writing-plans` | `writing-plans/SKILL.md` | 상세 구현 계획, 작은 단계, TDD, 테스트·커밋 명시 | TDD, code review, skill-creator와 중복 | 단일 SKILL.md. `superpowers:*` 하위 스킬 전제가 번들에 없음 | 핵심 필요 | **개조**. 저장 위치를 `docs/plans/`로 고정하고 SSoT/승인/데이터 영향/테스트 매트릭스를 추가; 누락 superpowers 의존 제거 |

## 4. 중복군 분석

### 4.1 Godot 범용 허브와 전문 스킬

중복군:

- `godot-master`
- `godot-resource-data-patterns`
- `godot-save-load-systems`
- `godot-state-machine-advanced`
- `godot-ui-rich-text`
- `dialogue-system`

`godot-master` 내부에 resource, save/load, state machine, rich text, dialogue 관련 참조가 모두 있어 전문 스킬과 실질적으로 중복된다. 원본을 모두 설치하면 trigger 충돌과 서로 다른 기본 아키텍처 제안이 발생한다.

특히 Project Nostalgia의 canonical runtime은 JSON + `GameJsonLoader` + `GameDataRepository` + `GameDataValidator` + `GameDataBootstrap`이다. 반면 범용 스킬 다수는 Resource/`.tres`를 데이터 SSoT로 권장한다. 따라서 “둘 다 사용”이 아니라 다음과 같이 분리해야 한다.

- canonical authored/runtime definition: 기존 JSON architecture만 사용
- transient typed logic: 필요하면 RefCounted 사용 가능
- presentation: repository가 제공한 데이터를 읽는 stateless projection
- save data: 별도 버전 envelope와 migration을 갖되 canonical definition DB를 대체하지 않음

### 4.2 품질 워크플로

중복군:

- `writing-plans`
- `test-driven-development`
- `systematic-debugging`
- `verification-before-completion`
- `requesting-code-review`
- `understand-diff`

이들은 서로 보완적이지만 각각 “항상/필수”를 강하게 주장한다. 그대로 설치하면 단순 문서 수정에도 과도한 게이트가 발생한다. 다음 2개로 병합하는 편이 낫다.

- `pn-simulation-tdd`: 테스트가 필요한 행동 변경에만 red-green-refactor 적용
- `pn-godot-debug-and-completion`: 버그 재현, 원인 추적, 리뷰, static/runtime 증거, 최종 보고 통합

계획 작성은 authority guard와 결합해 별도 workflow entry로 유지한다.

### 4.3 시각·문체 스킬

중복군:

- `frontend-design`
- `godot-ui-rich-text`
- `humanizer`
- `canvas-design`
- `algorithmic-art`
- `baoyu-article-illustrator`
- `baoyu-diagram`

Project Nostalgia에는 “멋진 일반 디자인”보다 **세계관 내 기록 표면과 정보 출처의 구분**이 중요하다. 따라서 frontend + rich text + Korean humanization만 핵심 재료로 취하고, 정적 미술/삽화/생성형 아트는 제외한다. diagram은 개발 문서용으로만 조건부 유지한다.

### 4.4 Understand Anything 플러그인

중복군:

- 기반 생성: `understand`
- 조회: `understand-chat`, `understand-explain`
- 변화 분석: `understand-diff`
- 파생 문서: `understand-domain`, `understand-onboard`
- 시각화: `understand-dashboard`
- 별도 입력 형식: `understand-figma`, `understand-knowledge`

9개를 개별 스킬로 설치할 이유가 없다. 필요해질 경우 다음 3개 모드만 가진 경량 `pn-repository-map`으로 재작성한다.

- `scan`: Godot/GDScript/JSON/Markdown 관계 맵
- `query`: 특정 파일·ID·loader flow 설명
- `impact`: diff와 ID reference 영향 분석

대시보드, Figma, wiki graph, onboarding 자동 생성은 제외한다.

## 5. 로컬 참조 파일 상태의 핵심 발견

### 5.1 완전하거나 실사용 가능한 묶음

- `algorithmic-art`: 2개 template 존재
- `baoyu-diagram`: 4개 reference와 TypeScript script 존재
- `godot-resource-data-patterns`: 10개 GDScript 존재
- `dialogue-system`: 5개 reference 존재
- `godot-save-load-systems`: 3개 GDScript 존재
- `godot-state-machine-advanced`: 12개 GDScript 존재
- `godot-ui-rich-text`: 12개 GDScript 존재
- `systematic-debugging`: root-cause, defense-in-depth, waiting 자료와 테스트 존재
- Understand Anything: 상위 plugin monorepo, agents, scripts, packages가 함께 존재하며 `.git`은 제거된 상태

### 5.2 불완전하거나 외부 의존적인 묶음

- `canvas-design`: `./canvas-fonts`를 요구하지만 폴더가 없다.
- `skill-creator`: 문서가 요구하는 `references/`, `scripts/`, `agents/`, `eval-viewer/`가 없다. 루트의 `schemas.md`와 `eval_review.html`만 존재해 경로 및 기능 계약이 맞지 않는다.
- `writing-plans`: `superpowers:subagent-driven-development`, `superpowers:executing-plans`, `superpowers:using-git-worktrees`를 전제하지만 이 묶음에서 해당 스킬을 찾지 못했다.
- `baoyu-article-illustrator`: image backend, 사용자별 `EXTEND.md`, 경우에 따라 Codex CLI/외부 skill이 필요하다.
- Understand Anything: source는 포함됐지만 실제 실행은 Node.js 22+, pnpm 10+, 패키지 build/install 및 일부 경우 release viewer/network를 요구한다.

### 5.3 내부 모순 또는 그대로 채택하면 위험한 예

- `godot-save-load-systems`는 “untrusted data에 allow_objects를 사용하지 말라”고 하면서 binary 예제에서 `store_var(data, true)`/`get_var(true)`를 사용한다. PN 버전에서는 이 예제를 제거해야 한다.
- `godot-ui-rich-text`는 typewriter에서 `visible_characters`를 권고하면서 다른 예제는 `visible_ratio`를 사용한다. 프로젝트 버전과 BBCode pause 요구에 맞춰 하나의 검증된 경로로 통일해야 한다.
- `dialogue-system`의 `Expression` 기반 condition 문자열은 구조화된 formula/requirements 원칙과 충돌한다.
- `godot-master`의 “Data = Resources/.tres SSoT” 계층은 Project Nostalgia의 JSON repository architecture에 그대로 적용할 수 없다.
- `baoyu-diagram`의 dark/cyan 기본 테마는 개발 문서에는 쓸 수 있으나 Project Nostalgia 게임 UI 지침에는 적용하면 안 된다.

## 6. 필요/불필요 상세 분류

### 6.1 핵심 필요 — 직접 개조 대상

- `frontend-design`
- `godot-save-load-systems`
- `godot-ui-rich-text`
- `skill-creator`
- `systematic-debugging`
- `test-driven-development`
- `verification-before-completion`
- `writing-plans`

이 중 어느 것도 원본 그대로 설치하지 않는다. PN 전용 authority/data/UI/quality 규칙을 우선하도록 다시 작성한다.

### 6.2 조건부 필요 — 필요한 부분만 추출

- `baoyu-diagram`
- `humanizer`
- `godot-resource-data-patterns`
- `dialogue-system`
- `godot-master`
- `requesting-code-review`
- `understand`
- `understand-diff`
- `understand-knowledge`

조건부 필요 9개 중 실제 1차 커스터마이징에는 필요한 규칙만 선별한다. 나머지는 마일스톤이 확정될 때까지 설치하지 않는다.

### 6.3 불필요/보류 — 현재 배포 후보 제외

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

일부 보류 스킬은 미래 단계에서 조건부로 재평가할 수 있다. 최종 설치 목록은 SSoT의 canonical 경로·source metadata 정리와 실제 다음 개발 마일스톤 확정 후 결정한다.

## 7. 병합·분리·폐기·개조 권고

### 7.1 병합

- `systematic-debugging` + `verification-before-completion` + `requesting-code-review` + `understand-diff` 일부 → `pn-godot-debug-and-completion`
- `frontend-design` + `godot-ui-rich-text` + `humanizer` + `docs/context/UI_HUMAN_DESIGN_GUIDANCE_v0.1.md` → `pn-narrative-ui-director`
- `test-driven-development` + `writing-plans`의 테스트 단계 → `pn-simulation-tdd`
- `understand-chat` + `understand-explain` + `understand-diff` → 선택적 `pn-repository-map` 모드

### 7.2 분리

- `godot-master`를 전부 가져오지 말고 PN에 관련된 참조만 주제별로 분리한다.
- `dialogue-system`에서 데이터 모델과 UI 표시를 분리한다. 데이터 모델은 canonical encounter/task/clue/deduction로 재매핑하고, UI 표시만 narrative UI skill에 흡수한다.
- `godot-ui-rich-text`에서 정상 문서 표현, 주관적 왜곡, 전자 시스템 변조 효과를 서로 다른 규칙과 테스트로 분리한다.
- `godot-save-load-systems`에서 immutable definition data와 mutable save state를 분리한다.

### 7.3 폐기

현재 PN 배포 후보에서 다음을 제외한다.

- algorithmic art
- static canvas art
- article illustration
- Figma graph
- dashboard viewer
- 자동 onboarding/domain 추론
- 범용 HSM 전체

원본 디렉터리는 보존하며 삭제하지 않는다.

### 7.4 개조

모든 채택 스킬에 공통으로 다음을 추가한다.

- 첫 읽기 순서: `AGENTS.md` → SSoT pointer → canonical SSoT → context/conflicts → task plan
- canonical SSoT 누락/오래됨 판정 시 구현 차단
- conflict report 형식과 사용자 승인 게이트
- canonical JSON envelope와 ID/reference rules
- exact/qualitative 정보 계층 분리
- Godot runtime test와 static validation의 명시적 구분
- Windows PowerShell/저장소 실제 경로에 맞는 명령 예시
- 원본 Drive 자동 병합·덮어쓰기 금지
- 프로젝트 코드나 SSoT를 조용히 변경하지 않는 규칙

## 8. 다음 단계

단계별 실행 계획은 `docs/plans/PROJECT_NOSTALGIA_SKILL_CUSTOMIZATION_PLAN.md`에 기록한다. SSoT 본문 검토는 완료했으며, canonical 경로와 source metadata를 정리한 뒤 계획의 구현 단계로 진입한다.
