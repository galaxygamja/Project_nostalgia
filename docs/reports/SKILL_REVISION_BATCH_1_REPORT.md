# Project Nostalgia 스킬 개편 배치 1 보고서

- 작업일: 2026-07-20
- 브랜치: `skills/revise-core-batch-1`
- 기준 commit: `11b9fcc954a59b3fcc910fbb3fe3dac70d3ee72b`
- 범위: 승인된 MIT source skill 네 개의 일대일 Project Nostalgia 파생 작업본
- 설치·전역 등록: 하지 않음

## 1. 승인된 mapping

| 책임 영역 | 직접 원본 | 결과물 | 라이선스 | 병합 |
|---|---|---|---|---|
| SSoT 및 설정 충돌 관리 | `writing-plans` | `project_skills/pn-authority-and-conflict-guard/` | MIT | 없음, 일대일 |
| Godot 4.7.1 디버깅 및 완료 검증 준비 | `systematic-debugging` | `project_skills/pn-godot-debug-and-completion/` | MIT | 없음, 일대일 |
| 완료 선언 검증 관문 | `verification-before-completion` | `project_skills/pn-verification-gate/` | MIT | 없음, 일대일 |
| Git 및 저장소 안전 작업 | `understand-diff` | `project_skills/pn-repository-safety/` | MIT | 없음, 일대일 |

다른 source skill 문구·scripts·references를 결과물에 병합하지 않았다. 책임이 다른 절차는 project skill 이름으로 handoff하도록 경계를 작성했다.

## 2. 원본 경로·라이선스·SHA-256

| 원본 | 실제 경로 | 실제 license 원문 | 작업 전 SHA-256 | 작업 후 SHA-256 |
|---|---|---|---|---|
| `writing-plans` | `Project_Nostalgia_Codex_Handoff_v0.1/source_skills/Project_nostalgia_Skills_v0.6/writing-plans/SKILL.md` | `writing-plans/obra_superpowers__LICENSE.txt` (MIT) | `272E1AF349F5062C28DC282B3E21B220D58D683A7314A10C455B7432EC91D845` | `272E1AF349F5062C28DC282B3E21B220D58D683A7314A10C455B7432EC91D845` |
| `systematic-debugging` | `Project_Nostalgia_Codex_Handoff_v0.1/source_skills/Project_nostalgia_Skills_v0.6/systematic-debugging/SKILL.md` | `systematic-debugging/obra_superpowers__LICENSE.txt` (MIT) | `3B20719ECA4F0461CB51A195221320D775DCF03B6859271066A03A5132A6CE7A` | `3B20719ECA4F0461CB51A195221320D775DCF03B6859271066A03A5132A6CE7A` |
| `verification-before-completion` | `Project_Nostalgia_Codex_Handoff_v0.1/source_skills/Project_nostalgia_Skills_v0.6/verification-before-completion/SKILL.md` | `verification-before-completion/obra_superpowers__LICENSE.txt` (MIT) | `EA52D15AABAF72BC6B558EFE2C126F161B53961090DDCD712000273BFE8C7B6C` | `EA52D15AABAF72BC6B558EFE2C126F161B53961090DDCD712000273BFE8C7B6C` |
| `understand-diff` | `Project_Nostalgia_Codex_Handoff_v0.1/source_skills/Project_nostalgia_Skills_v0.6/understand-anything/Understand-Anything/understand-anything-plugin/skills/understand-diff/SKILL.md` | `understand-anything/Understand-Anything/LICENSE` (MIT) | `0D99E1140812A336025C6779899EF0F439AE0FBA115527F98695E57A2BA12245` | `0D99E1140812A336025C6779899EF0F439AE0FBA115527F98695E57A2BA12245` |

`obra/superpowers` license는 Jesse Vincent의 2025 MIT 고지를 포함한다. Understand Anything license는 Yuxiang Lin 및 Infinite Universe, Inc.의 2026 MIT 고지를 포함한다. 확인되지 않은 저작자·연도·URL은 추가하지 않았다.

## 3. 결과물과 개편 내용

### 3.1 `pn-authority-and-conflict-guard`

유지:

- 구현 전 계획
- exact path와 작은 검토 단위
- 검증 계획과 self-review

제거·축소:

- 범용 코드 예시
- 존재하지 않는 `superpowers:*` 의존
- 범용 plan 저장 경로와 자동 실행 handoff

추가:

- canonical SSoT와 `[확정]`/`[작업안]`/`[미정]`
- revision/SHA 확인과 Google Docs 자동 병합 금지
- 기존/제안/차이/영향/변경 종류 보고
- 승인 전 SSoT·코드·JSON 직접 수정 금지

책임 경계: 계획·차이 보고·승인 상태까지만 담당한다.

### 3.2 `pn-godot-debug-and-completion`

유지:

- root cause 전 수정 금지
- 재현과 전체 오류 수집
- working/broken 비교
- 단일 가설·최소 검증

제거·축소:

- 일반 CI/signing 예시
- 원본 부속 reference 및 다른 superpowers skill 의존
- 범용 사례·성과 수치

추가:

- Godot 4.7.1-stable 고정
- parser/project load/runtime/visual 구분
- loader → repository → validator → bootstrap 경계
- 미완성 프로젝트의 알려진 차이와 원본 자동 변환 금지

책임 경계: 조사와 최소 수정 준비까지만 담당하며, 완료 주장은 verification gate로 넘긴다.

### 3.3 `pn-verification-gate`

유지:

- evidence before claims
- 주장별 직접 명령
- fresh/full output, exit code와 failure count
- 부분 검사 일반화 금지

제거·축소:

- 감정적·범용 rationalization 반복
- 특정 agent delegation 예시
- 무관한 build/lint 사례

추가:

- 완료/부분 완료/차단됨 상태
- Godot와 JSON 검증 계층
- working/staged/commit/push 분리
- source hash·금지 경로·secret 확인

책임 경계: 자동 수정 없이 증거와 최종 상태만 판정한다.

### 3.4 `pn-repository-safety`

유지:

- changed files 우선 확인
- 기준 commit freshness와 diff 범위 구분
- affected scope/risk 구조화

제거·축소:

- `.ua` knowledge graph 필수 의존
- graph node/edge 분석
- dashboard 및 diff overlay
- Node/pnpm/plugin 설치

추가:

- fetch/branch/remote/upstream/base gate
- selective staging과 `git add .`/`git add -A` 금지
- source snapshot, `game_development/`, `.godot/`, secret 보호
- staged diff와 non-force push 검증

책임 경계: 파일 내용을 설계하지 않고 Git 상태·기록만 담당한다.

## 4. 공통 Project Nostalgia 규칙

역할 범위에 맞게 네 스킬에 다음을 반영했다.

- Godot 4.7.1-stable 기준과 자동 upgrade 금지
- SSoT 상태와 known conflict 승인 gate
- 정적 검사와 runtime 검사 분리
- 누락 reference/ID 임의 생성 금지
- source snapshot과 canonical 자료 구분
- 1000일은 예상 엔딩 기간이 아니라 시스템 지원 상한
- 코드의 100일 기본값은 엔딩 기간 충돌이 아니라 config 전달 및 지원 상한 불일치 후보

## 5. 고지 구조

생성:

- `THIRD_PARTY_NOTICES.md`
- `licenses/obra-superpowers/LICENSE`
- `licenses/understand-anything/LICENSE`
- 각 결과물의 `SOURCE_AND_LICENSE.md`

동일한 obra license를 사용하는 세 upstream은 한 license 사본으로 보존하고 각 결과물에서 이를 참조한다. Understand Anything MIT 원문은 별도 사본으로 보존한다.

## 6. 정적 검증 결과

- 결과물 폴더: 승인된 네 개만 존재 — 통과
- 각 `SKILL.md` 및 `SOURCE_AND_LICENSE.md`: 4/4 존재 — 통과
- frontmatter `name`/`description`: 4/4 존재하고 승인 이름과 일치 — 통과
- 필수 section 11종과 handoff 조건: 4/4 포함 — 통과
- Markdown 상대경로: 검사한 14개 Markdown에서 broken link 0 — 통과
- 원본 SHA-256: 네 개 모두 작업 전후 일치 — 통과
- license 사본: 내용 일치. `obra-superpowers`는 byte-identical, Understand Anything은 원본 CRLF를 LF로 정규화한 텍스트 동일 사본 — 통과
- handoff/source skill, `game_development/`, `docs/ssot/`: tracked diff 0 — 통과
- 정확한 Godot 4.7.1 runtime: binary 부재로 미검증
- staged allowlist, secret/cache/large-file 및 최종 diff: commit 직전 별도 검사

## 7. Runtime 검증

정확한 Godot 4.7.1-stable binary가 확인되지 않았으므로 다음은 미검증이다.

- Godot parser
- headless project load
- runtime tests
- 1920×1080 visual capture

이번 산출물은 Markdown skill 문서이며 static 구조·provenance 검사만 수행한다. runtime 통과를 주장하지 않는다.

## 8. JSON 스킬 보류

JSON 작성과 검증을 분리한다.

- 작성: `pn-content-authoring`
- 검증 및 참조 무결성: `pn-data-core-guardian`

의미상 정확히 대응하는 MIT/Apache source skill이 없어 이번 파생 배치에서는 만들지 않는다. `skill-creator`를 JSON domain upstream으로 사용하지 않는다. 향후 canonical SSoT, templates, guideline과 actual data core를 근거로 하는 독립 작성은 별도 사용자 승인 대상이다.

## 9. 남은 충돌과 다음 배치

자동 해결하지 않고 남긴 항목:

- 100일 코드 기본값과 1000일 시스템 지원 상한
- continuous skills와 discrete level design
- 900×540과 1920×1080
- item knowledge 5단계 `[작업안]`과 후기 3단계
- `game_loop_v1`과 repository 미연결
- `res://data` 누락
- IFBO semantic ID 및 missing references

다음 배치 권장 범위:

1. 네 스킬의 trigger overlap과 eval 설계
2. `pn-content-authoring` 독립 작성 명세
3. `pn-data-core-guardian` 독립 작성 명세
4. 실제 Godot 4.7.1 binary 준비 후 debug/verification skill의 runtime eval

독립 JSON 스킬 작성과 project skill 설치·전역 등록에는 별도 사용자 승인이 필요하다.
