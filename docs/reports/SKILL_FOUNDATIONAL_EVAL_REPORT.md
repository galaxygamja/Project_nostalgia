# Project Nostalgia 기반 스킬 평가 보고서

- 작성일: 2026-07-21
- 브랜치: `skills/eval-foundational-batch-1`
- 시작 기준 commit: `2a9a42be9fc4c4da0bbc35c6fe96b5128c19e0f7`
- 범위: 배치 1 스킬 4개의 직접 upstream 라이선스 재검증, 정적·시나리오 평가, 확인된 모호성의 최소 수정
- 설치·전역 등록: 하지 않음
- Phase B: 시작하지 않음

## 1. 결론

배치 1의 네 직접 upstream은 모두 실제 동봉 MIT LICENSE의 적용 범위가 확인되며, 수정·배포를 포함한 직접 파생이 허용된다. 필수 저작권과 permission notice는 각 결과물의 provenance 문서, 루트 third-party notice, 저장소 LICENSE 사본에 보존되어 있다.

89개 정적 시나리오 명세는 PASS 89, AMBIGUOUS 0, FAIL 0이다. 모든 사례의 runtime 상태는 `NOT_RUNTIME_TESTED`다. 실제 Codex 자동 trigger 동작이나 Godot runtime 통과를 주장하지 않는다.

## 2. 직접 upstream 라이선스 재검증

| upstream | 결과물 | 동봉 LICENSE | 적용 범위 근거 | 저작권 | 파생 판정 |
|---|---|---|---|---|---|
| `writing-plans` | `pn-authority-and-conflict-guard` | skill 폴더의 `obra_superpowers__LICENSE.txt` | `SKILL.md`와 같은 배포 단위에 직접 동봉 | 2025 Jesse Vincent | 허용 |
| `systematic-debugging` | `pn-godot-debug-and-completion` | skill 폴더의 `obra_superpowers__LICENSE.txt` | `SKILL.md` 및 동봉 자료와 같은 배포 단위 | 2025 Jesse Vincent | 허용 |
| `verification-before-completion` | `pn-verification-gate` | skill 폴더의 `obra_superpowers__LICENSE.txt` | `SKILL.md`와 같은 배포 단위에 직접 동봉 | 2025 Jesse Vincent | 허용 |
| `understand-diff` | `pn-repository-safety` | `Understand-Anything/LICENSE` | monorepo 루트 MIT 선언, root `package.json`의 `license: MIT`, 하위 plugin/skill override 없음 | 2026 Yuxiang Lin; 2026 Infinite Universe, Inc. | 허용 |

MIT 본문은 software와 associated documentation을 제한 없이 use, copy, modify, merge, publish, distribute, sublicense, sell할 수 있게 하므로 네 문서형 skill의 일대일 직접 파생을 허용한다. 조건은 저작권 고지와 permission notice 보존이며 현재 고지 구조가 이를 충족한다.

`licenses/understand-anything/LICENSE`는 동봉 원본과 줄바꿈만 다르다. 원본은 CRLF, 저장소 사본은 LF이며 정규화한 본문과 고지는 동일하다. 이 차이는 라이선스 내용이나 적용 범위의 불명확성으로 판정하지 않았다.

## 3. 원본 보존과 provenance

네 upstream `SKILL.md`의 현재 SHA-256은 각 `SOURCE_AND_LICENSE.md` 기록과 모두 일치한다. source skill, handoff 원본, `game_development/`, SSoT, runtime JSON, Godot 코드는 수정하지 않았다.

직접 mapping은 다음과 같이 유지된다.

1. `writing-plans` → `pn-authority-and-conflict-guard`
2. `systematic-debugging` → `pn-godot-debug-and-completion`
3. `verification-before-completion` → `pn-verification-gate`
4. `understand-diff` → `pn-repository-safety`

다른 원본의 문구·scripts·references를 병합하지 않았다.

## 4. 평가 구성

- 총 89개 사례
- authority primary 22
- Godot debugging primary 20
- verification primary 22
- repository safety primary 25
- boundary 29
- adversarial 20
- composite handoff 15
- 각 스킬 negative trigger 3개

평가 기준선은 `AGENTS.md`와 canonical 문서만 읽은 기본 agent 상태다. 실제 baseline/skill-enabled 출력 비교는 수행하지 않았고 local pilot로 보류했다.

## 5. 수정한 스킬과 행동 변화

| 스킬 | 최소 수정 결과 |
|---|---|
| authority guard | 일반 계획과 wording-only 작업을 제외하고 authority·상태·충돌·승인 범위로 trigger 축소; 승인 범위 확대 금지와 precedence 명시 |
| Godot debugging | 실제 실패·예상 밖 동작으로 trigger 축소; 일반 Q&A 제외; 원인 확인 후 승인된 최소 수정만 허용 |
| verification gate | 기능 증거 판정에 집중; Git 기록 책임 제거; 증거 stale 조건과 반환 조건 명시 |
| repository safety | Git 상태·기록 작업으로 trigger 축소; 의미 기반 리뷰 제외; verification과의 단방향 반환 조건 명시 |

공통으로 최종 게임 기간 `[미정]`과 현재 반입 data contract의 1000일 기술 지원 상한을 구분했다.

## 6. 정적 검증

검증 대상:

- frontmatter와 디렉터리/name 일치
- 필수 section과 provenance 파일
- Markdown 상대경로
- README/MANIFEST와 실제 skill 디렉터리
- eval JSON parse, 필수 필드, ID 중복, skill 참조, primary/금지 충돌
- 원본 SHA-256과 LICENSE 고지
- working/staged diff와 금지 경로

실행 결과:

- `python project_skills/tools/validate_project_skills.py` — exit 0; skill 디렉터리 4개, Markdown 33개, eval 1개, 오류 0
- eval JSON parse·집계 — 89 cases, PASS 89, `NOT_RUNTIME_TESTED` 89
- `git diff --check` — exit 0
- upstream SHA-256 — 4/4 provenance 일치
- `git fetch origin` — exit 0; HEAD와 기준 remote SHA 모두 `2a9a42be9fc4c4da0bbc35c6fe96b5128c19e0f7`
- target remote branch — 확인 시 존재하지 않음

`skill-creator/scripts/quick_validate.py`는 `PyYAML`이 설치되지 않아 `ModuleNotFoundError: yaml`로 import 단계에서 종료됐다. 이 보조 검사를 통과했다고 기록하지 않는다. 동일한 frontmatter/name/필수 구조 및 배치 전용 경로·eval 검사는 표준 라이브러리 기반 프로젝트 validator에서 통과했다.

## 7. SSoT·schema·ID 영향

- SSoT 영향: 없음
- runtime schema 영향: 없음
- ID 생성·변경: 없음
- Godot 프로젝트 동작 변경: 없음

## 8. 미검증 및 남은 위험

- 실제 Codex trigger/runtime eval 미수행
- baseline 대비 정확도·비용 비교 미수행
- Godot 4.7.1 parser/headless/runtime/1920×1080 visual 미수행
- Phase B 후보 전체 라이선스 재감사 미완료
- project-local 설치 및 pilot 미수행

## 9. Phase 판정

Phase A 문서·정적 평가 범위는 완료 가능 상태다. 검증과 선택적 Git 기록 후에도 Phase B는 시작하지 않는다. Phase B 진입 조건은 남은 후보 전체의 실제 LICENSE·NOTICE·적용 범위·파생 조건 재감사와 별도 결과 확인이다.

## 10. 사용자 결정이 필요한 후속 항목

1. project-local pilot 수행 여부
2. 실제 Codex runtime trigger 평가 방식
3. 전체 라이선스 재감사 이후 Phase B 진입 여부
4. Godot 4.7.1 binary 준비 및 runtime 검증 시점
