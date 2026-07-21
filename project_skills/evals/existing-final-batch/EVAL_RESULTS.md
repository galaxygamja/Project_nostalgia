# Project Nostalgia 최종 기존 스킬 배치 평가 결과

- 사례: 36
- PASS: 36
- FAIL: 0
- AMBIGUOUS: 0
- runtime status: 36개 모두 `NOT_RUNTIME_TESTED`

## 결과물별

| result skill | 사례 | positive | negative | handoff | adversarial | boundary |
|---|---:|---:|---:|---:|---:|---:|
| `pn-simulation-tdd` | 12 | 4 | 2 | 2 | 2 | 2 |
| `pn-repository-map` | 12 | 4 | 2 | 2 | 2 | 2 |
| `pn-narrative-ui-director` | 12 | 4 | 2 | 2 | 2 | 2 |

## 정적 판정

- TDD는 승인된 simulation behavior에만 primary이며 unresolved design·prose·final verification을 넘긴다.
- repository map은 direct-search read-only 책임이며 Git 기록, debugging, canon 판단과 구분된다.
- narrative UI는 설정 승인, simulation behavior, final evidence와 단방향 handoff를 사용한다.
- graph/dashboard 설치, validation 비활성화, generic dashboard, fake visual proof 요구를 거부한다.

## 한계

이 결과는 SKILL.md 계약과 기대 scenario를 대조한 정적 명세 판정이다. 실제 Codex trigger, Godot parser/headless/runtime, 1920×1080 visual capture를 실행하지 않았다.

## 검증 기록

- `python project_skills/tools/validate_project_skills.py`: exit 0; skill 7개, Markdown 47개, eval 2개
- 신규 eval: 36/36 PASS, 36/36 `NOT_RUNTIME_TESTED`
- 배치 1 regression: 89/89 PASS, 89/89 `NOT_RUNTIME_TESTED`
- 세 upstream SHA: 3/3 provenance 값 일치
- frontend Apache LICENSE: source/copy byte SHA 일치 `0D542E...E94594`
- 신규 SKILL.md: 146 / 141 / 166줄로 500줄 이하
- `git diff --check`: exit 0
- `skill-creator/scripts/quick_validate.py`: 3개 모두 환경의 `PyYAML` 부재로 import 전 종료; 성공으로 기록하지 않음

프로젝트 validator가 frontmatter/name/필수 section/README/MANIFEST/상대경로/eval schema를 표준 라이브러리만으로 검사했다.
