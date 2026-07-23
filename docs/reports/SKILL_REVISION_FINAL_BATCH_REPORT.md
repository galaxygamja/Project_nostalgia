# Project Nostalgia 최종 기존 스킬 개편 보고서

- 작업일: 2026-07-21
- branch: `skills/revise-existing-final-batch`
- 기준 commit: `ef81cea038aea3488d4d7e704874d9d6b2570b37`
- 결과물: 3개
- 설치·전역 등록: 하지 않음

## 1. 결과물

### `pn-simulation-tdd`

- upstream: `test-driven-development` / MIT / © 2025 Jesse Vincent
- 범용 “모든 변경” 규칙을 시간·조건·지연 효과·schedule·save/load·reference simulation으로 좁혔다.
- 48 slots/day를 행동 수로 오인하지 않고 absolute slot/day boundary 테스트를 명시했다.

### `pn-repository-map`

- upstream: `understand` / MIT / © 2026 Yuxiang Lin, Infinite Universe, Inc.
- architecture/relationship 분석은 유지하고 `.ua`, Node/pnpm, graph pipeline, dashboard, hooks를 제거했다.
- Godot/JSON/document/diff의 direct `rg` 조사와 commit freshness를 사용한다.

### `pn-narrative-ui-director`

- upstream: `frontend-design` / Apache-2.0
- deliberate palette/type/layout/copy와 self-critique를 Godot 4.7.1 문서형 UI에 적용했다.
- evidence provenance, qualitative disclosure, 네 인물 문체, distortion/tampering 분리와 1920×1080 runtime proof를 추가했다.
- upstream 권리자·연도·URL은 로컬에 없어 추측하지 않았다.

## 2. 라이선스 경계

- 세 결과물은 일대일 mapping이며 upstream을 병합하지 않았다.
- LGPL 또는 license-unknown 원본의 문구·scripts·references를 사용하지 않았다.
- frontend Apache LICENSE 사본은 source와 byte-identical하게 보존한다.
- 배치 1 provenance의 MIT 전문 위치 문구를 실제 구조에 맞게 정정했다.

## 3. SSoT·schema·ID·Godot 영향

- SSoT 영향: 없음
- schema/ID 영향: 없음
- Godot code/runtime JSON 영향: 없음
- project-local skill draft와 문서만 변경

## 4. 검증 범위

- 새 skill frontmatter/name/필수 section
- README/MANIFEST와 실제 디렉터리 일치
- source SHA와 license 사본
- 결과물당 12개 scenario
- 배치 1 89개 regression
- Markdown 상대경로와 `git diff --check`

실제 Codex trigger와 Godot runtime은 설치·실행하지 않았으므로 미검증이다.

실행 결과:

- project validator: exit 0; skill 7, Markdown 47, eval 2
- 신규 scenario: PASS 36 / FAIL 0 / AMBIGUOUS 0
- 배치 1 regression: PASS 89 / FAIL 0 / AMBIGUOUS 0
- source SHA: 3/3 일치
- frontend LICENSE byte copy: 일치
- 신규 SKILL.md: 모두 500줄 이하
- `git diff --check`: exit 0
- skill-creator quick validator: `PyYAML` 부재로 미완료

## 5. 보류

- `pn-save-migration`: 안전한 MIT/Apache 일대일 upstream 없음
- 독립 JSON authoring/validation: 이번 Goal 생성 금지
- project-local pilot: Phase R readiness 판정 뒤 별도 실행 대상
