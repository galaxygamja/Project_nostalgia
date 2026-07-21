# Project Nostalgia Source Skills 라이선스 감사

- 감사일: 2026-07-20
- 대상: `Project_Nostalgia_Codex_Handoff_v0.1/source_skills/Project_nostalgia_Skills_v0.6/` 아래 27개 `SKILL.md`
- 원칙: 동봉 라이선스와 로컬 출처 metadata만 근거로 판정. 라이선스가 없거나 적용 범위가 불명확하면 사용 가능으로 간주하지 않음.
- 주의: 이 문서는 저장소 정리용 기술 감사이며 법률 자문이 아니다.

## 1. 요약

| 판정 | 수 |
|---|---:|
| 총 스킬 | 27 |
| 동봉 라이선스 종류 확인 | 25 |
| 라이선스 불명/적용 근거 없음 | 2 |
| 공개 GitHub 포함 가능 | 25 |
| 공개 포함 불가 또는 보류 | 2 |
| Project Nostalgia 전용 수정본 제작 가능 | 25 |

라이선스별:

| 라이선스 | 스킬 수 | 기본 판정 |
|---|---:|---|
| MIT | 17 | 수정·재배포 가능, copyright 및 permission notice 유지 |
| Apache-2.0 | 4 | 수정·재배포 가능, license 제공·고지 유지·변경 표시·NOTICE 조건 준수 |
| LGPL-3.0 | 4 | 수정·재배포 가능하나 covered work/source 제공, 고지, relink/combined-work 등 LGPL/GPL 의무 검토 필요 |
| 확인 불가 | 2 | 사용·수정·공개 재배포 보류 |

## 2. 판정 기준

### MIT

- 수정: 허용
- 재배포: 허용
- 핵심 조건: 모든 copy 또는 substantial portion에 copyright notice와 permission notice 포함
- 공개 저장소: 조건 준수 시 가능
- PN 수정본: 가능, 원본 고지와 라이선스 보존

### Apache License 2.0

- 수정: 허용
- 재배포: 허용
- 핵심 조건: license 사본 제공, modified file에 변경 사실 표시, 관련 copyright/patent/trademark/attribution notice 유지, upstream NOTICE가 있다면 NOTICE 의무 준수
- 공개 저장소: 조건 준수 시 가능
- PN 수정본: 가능, 변경 표시와 attribution 체계 필요
- 불확실성: 일부 bundle은 표준 license 본문만 있고 구체 copyright owner/source metadata가 없다. 법적 허용과 별개로 provenance 보강이 필요하다.

### LGPL-3.0

- 수정: 허용
- 재배포: 허용
- 핵심 조건: covered work는 LGPL/GPL 조건, license/copyright notice, corresponding source 및 변경 고지 의무를 준수해야 한다. 다른 코드와 결합하는 방식에 따라 relinking 또는 combined-work 조건 검토가 필요하다.
- 공개 저장소: source와 license를 함께 공개하고 조건을 지키는 경우 가능
- PN 수정본: 가능하나 **원본을 복사·변형한 수정본은 LGPL 계열 의무가 따라갈 수 있으므로 별도 디렉터리와 명확한 provenance가 필요**
- 권고: LGPL 스킬 텍스트/스크립트를 직접 복사하기보다 아이디어를 독립적으로 재구현할 경우에도 표현의 복제 여부를 검토한다.

### 라이선스 불명

저작권 기본 규칙상 명시적 허가를 확인할 수 없으므로 수정·재배포·공개 저장소 포함을 보류한다. 외부 URL에서 라이선스를 추측하지 않는다.

## 3. 스킬별 감사

경로는 bundle root 기준이다.

| # | 스킬 | 원본 경로 | 원본 프로젝트/출처 | LICENSE | 종류 | 수정 | 재배포 | 고지 유지 조건 | 공개 GitHub 포함 | PN 수정본 | 확인 불가능/주의 |
|---:|---|---|---|---|---|---|---|---|---|---|---|
| 1 | `algorithmic-art` | `algorithmic-art/SKILL.md` | Anthropic, PBC.; upstream URL 미기록 | `algorithmic-art/LICENSE.txt` | Apache-2.0 | 허용 | 허용 | license, 기존 관련 고지, 변경 표시, NOTICE 존재 시 반영 | 조건부 가능 | 가능 | LICENSE에 Copyright 2026 Anthropic, PBC. 확인 |
| 2 | `baoyu-article-illustrator` | `baoyu-article-illustrator/SKILL.md` | Jim Liu, `github.com/JimLiu/baoyu-skills` | `baoyu-skills__LICENSE.txt` | MIT | 허용 | 허용 | Jim Liu copyright + MIT permission notice | 가능 | 가능 | image backend별 별도 라이선스는 본 감사 밖 |
| 3 | `baoyu-diagram` | `baoyu-diagram/SKILL.md` | baoyu-skills; 동일 bundle naming, SKILL에 직접 homepage 없음 | `baoyu-skills__LICENSE.txt` | MIT | 허용 | 허용 | Jim Liu copyright + MIT permission notice | 가능 | 가능 | 정확한 upstream subpath는 로컬에서 직접 확인 안 됨 |
| 4 | `humanizer` | `blader_humanizer/SKILL.md` | Siqi Chen; folder label `blader_humanizer` | `blader_humanizer__LICENSE.txt` | MIT | 허용 | 허용 | Siqi Chen copyright + MIT permission notice | 가능 | 가능 | upstream URL 없음 |
| 5 | `canvas-design` | `canvas-design/SKILL.md` | Anthropic, PBC.; upstream URL 미기록 | `canvas-design/LICENSE.txt` | Apache-2.0 | 허용 | 허용 | Apache 조건, 변경 표시, 관련 고지/NOTICE | 조건부 가능 | 가능 | LICENSE에 Copyright 2026 Anthropic, PBC. 확인; `canvas-fonts` 누락 |
| 6 | `frontend-design` | `frontend-design/SKILL.md` | 로컬 출처명/URL 미기록 | `frontend-design/LICENSE.txt` | Apache-2.0 | 허용 | 허용 | Apache 조건, 변경 표시, 관련 고지/NOTICE | 조건부 가능 | 가능 | 구체 copyright owner/upstream URL 불명 |
| 7 | `godot-resource-data-patterns` | `Godot Resource Data Patterns/SKILL.md` | bundle label `GD-Agentic-Skills`; upstream URL 미기록 | `GD-Agentic-Skills__LICENSE.txt` | LGPL-3.0 | 허용 | 조건부 허용 | LGPL/GPL 고지, license, modified source/corresponding source 및 결합 조건 | 조건 준수 시 가능 | 조건부 가능 | copyright holder와 정확한 upstream URL 불명; 결합 방식 법률 검토 필요 |
| 8 | `dialogue-system` | `godot-dialogue-system-1.0.0/SKILL.md` | metadata `mcpmarket-version: 1.0.0`; 정확한 package/source URL 없음 | 없음 | 확인 불가 | 보류 | 보류 | 확인 불가 | **보류** | **보류** | 라이선스와 권리자 모두 확인 불가 |
| 9 | `godot-master` | `godot-master/SKILL.md` | 로컬 provenance 없음; Godot 공식 링크는 skill 자체 출처 증명이 아님 | 없음 | 확인 불가 | 보류 | 보류 | 확인 불가 | **보류** | **보류** | 182 refs/대량 scripts 포함, license 적용 근거 없음 |
| 10 | `godot-save-load-systems` | `godot-save-load-systems/SKILL.md` | `GD-Agentic-Skills` bundle | `GD-Agentic-Skills__LICENSE.txt` | LGPL-3.0 | 허용 | 조건부 허용 | LGPL/GPL 조건과 source 제공 | 조건 준수 시 가능 | 조건부 가능 | 정확한 upstream/권리자 불명 |
| 11 | `godot-state-machine-advanced` | `godot-state-machine-advanced/SKILL.md` | `GD-Agentic-Skills` bundle | `GD-Agentic-Skills__LICENSE.txt` | LGPL-3.0 | 허용 | 조건부 허용 | LGPL/GPL 조건과 source 제공 | 조건 준수 시 가능 | 조건부 가능 | 정확한 upstream/권리자 불명 |
| 12 | `godot-ui-rich-text` | `godot-ui-rich-text/SKILL.md` | `GD-Agentic-Skills` bundle | `GD-Agentic-Skills__LICENSE.txt` | LGPL-3.0 | 허용 | 조건부 허용 | LGPL/GPL 조건과 source 제공 | 조건 준수 시 가능 | 조건부 가능 | 정확한 upstream/권리자 불명 |
| 13 | `requesting-code-review` | `requesting-code-review/SKILL.md` | obra/superpowers, Jesse Vincent | `obra_superpowers__LICENSE.txt` | MIT | 허용 | 허용 | Jesse Vincent copyright + MIT notice | 가능 | 가능 | upstream URL은 로컬 라이선스에 없음 |
| 14 | `skill-creator` | `skill-creator/SKILL.md` | Anthropic, PBC.; upstream URL 미기록 | `skill-creator/LICENSE.txt` | Apache-2.0 | 허용 | 허용 | Apache 조건, 변경 표시, 관련 고지/NOTICE | 조건부 가능 | 가능 | LICENSE에 Copyright 2026 Anthropic, PBC. 확인; frontmatter license 필드와 필수 eval resources 누락 |
| 15 | `systematic-debugging` | `systematic-debugging/SKILL.md` | obra/superpowers, Jesse Vincent | `obra_superpowers__LICENSE.txt` | MIT | 허용 | 허용 | Jesse Vincent copyright + MIT notice | 가능 | 가능 | upstream URL은 로컬 라이선스에 없음 |
| 16 | `test-driven-development` | `test-driven-development/SKILL.md` | obra/superpowers, Jesse Vincent | `obra_superpowers__LICENSE.txt` | MIT | 허용 | 허용 | Jesse Vincent copyright + MIT notice | 가능 | 가능 | upstream URL은 로컬 라이선스에 없음 |
| 17 | `understand` | `.../skills/understand/SKILL.md` | Egonex-AI/Understand-Anything; Yuxiang Lin, Infinite Universe, Inc. | 상위 `Understand-Anything/LICENSE` | MIT | 허용 | 허용 | 두 copyright notice + MIT notice | 가능 | 가능 | 상위 monorepo license 적용; third-party package license는 별도 유지 필요 |
| 18 | `understand-chat` | `.../skills/understand-chat/SKILL.md` | Egonex-AI/Understand-Anything | 상위 `Understand-Anything/LICENSE` | MIT | 허용 | 허용 | 동일 | 가능 | 가능 | 동일 |
| 19 | `understand-dashboard` | `.../skills/understand-dashboard/SKILL.md` | Egonex-AI/Understand-Anything | 상위 `Understand-Anything/LICENSE` | MIT | 허용 | 허용 | 동일 | 가능 | 가능 | dashboard dependencies는 각 dependency license 별도 |
| 20 | `understand-diff` | `.../skills/understand-diff/SKILL.md` | Egonex-AI/Understand-Anything | 상위 `Understand-Anything/LICENSE` | MIT | 허용 | 허용 | 동일 | 가능 | 가능 | 동일 |
| 21 | `understand-domain` | `.../skills/understand-domain/SKILL.md` | Egonex-AI/Understand-Anything | 상위 `Understand-Anything/LICENSE` | MIT | 허용 | 허용 | 동일 | 가능 | 가능 | 동일 |
| 22 | `understand-explain` | `.../skills/understand-explain/SKILL.md` | Egonex-AI/Understand-Anything | 상위 `Understand-Anything/LICENSE` | MIT | 허용 | 허용 | 동일 | 가능 | 가능 | 동일 |
| 23 | `understand-figma` | `.../skills/understand-figma/SKILL.md` | Egonex-AI/Understand-Anything | 상위 `Understand-Anything/LICENSE` | MIT | 허용 | 허용 | 동일 | 가능 | 가능 | Figma API/content 권리는 별도 |
| 24 | `understand-knowledge` | `.../skills/understand-knowledge/SKILL.md` | Egonex-AI/Understand-Anything | 상위 `Understand-Anything/LICENSE` | MIT | 허용 | 허용 | 동일 | 가능 | 가능 | 입력 knowledge content 권리는 별도 |
| 25 | `understand-onboard` | `.../skills/understand-onboard/SKILL.md` | Egonex-AI/Understand-Anything | 상위 `Understand-Anything/LICENSE` | MIT | 허용 | 허용 | 동일 | 가능 | 가능 | 동일 |
| 26 | `verification-before-completion` | `verification-before-completion/SKILL.md` | obra/superpowers, Jesse Vincent | `obra_superpowers__LICENSE.txt` | MIT | 허용 | 허용 | Jesse Vincent copyright + MIT notice | 가능 | 가능 | upstream URL은 로컬 라이선스에 없음 |
| 27 | `writing-plans` | `writing-plans/SKILL.md` | obra/superpowers, Jesse Vincent | `obra_superpowers__LICENSE.txt` | MIT | 허용 | 허용 | Jesse Vincent copyright + MIT notice | 가능 | 가능 | 참조하는 일부 superpowers skills는 bundle에 없음 |

## 4. 공개 저장소 포함 판정

### 포함 가능: 25개

- MIT 17개
- Apache-2.0 4개
- LGPL-3.0 4개

이는 “아무 조건 없이 복사 가능”을 뜻하지 않는다. 각 license/notice, 변경 표시, source 제공 및 LGPL 결합 조건을 만족하는 배치 구조가 먼저 필요하다.

### 포함 불가 또는 보류: 2개

- `dialogue-system`
- `godot-master`

명시적인 license grant를 확인할 때까지 Project Nostalgia 공개 저장소에 원문 또는 수정본을 포함하지 않는다. 아이디어/사실 자체와 저작권 보호 표현은 구분해야 하며, 독립 재작성 여부도 provenance 검토가 필요하다.

## 5. Project Nostalgia 수정본 제작 조건

### 권장 attribution 구조

향후 승인 후 다음 구조를 사용한다.

```text
third_party/
  LICENSES/
    <upstream>-LICENSE.txt
    NOTICE.md
project_skills/
  <pn-skill>/
    SKILL.md
    SOURCE.md   # upstream path, version/hash, modifications, license
```

각 수정본의 `SOURCE.md`에는 최소 다음을 기록한다.

- 원본 이름과 경로
- 확인 가능한 upstream URL
- 원본 bundle/version/hash
- license 종류와 license 파일 경로
- 수정일 및 변경 요약
- copyright/attribution
- LGPL일 경우 corresponding source와 배포 방식

### 직접 복사보다 독립 재작성 권고

Project Nostalgia의 6개 목표 스킬은 여러 upstream을 병합한다. license compatibility와 provenance를 단순화하려면:

1. 요구사항과 일반 아이디어를 추출한다.
2. 원본 문장을 복사하지 않고 프로젝트 규칙을 기준으로 새로 작성한다.
3. 그래도 실질적으로 파생된 경우 attribution을 보수적으로 유지한다.
4. LGPL 원본 코드/표현을 직접 포함하는 경우 LGPL 조건을 적용한다.
5. license 불명 2개는 표현·스크립트를 사용하지 않는다.

## 6. 확인 불가능한 공통 항목

- 일부 Apache/LGPL bundle의 정확한 upstream URL 및 copyright owner
- archive가 upstream 원본과 완전히 동일한지 여부
- 개별 파일에 서로 다른 제3자 라이선스가 혼재하는지 여부
- 생성 이미지, fonts, external APIs, npm dependencies 등 skill 외부 자산의 권리
- 법적 의미에서 여러 license 텍스트를 한 PN 스킬로 병합할 때의 최종 derivative-work 판정

## 7. Phase 0 판정

“원본 스킬별 라이선스 재사용 조건 정리”는 **감사 완료**로 표시할 수 있다. 다만 실제 커스터마이징 시작 전 다음 차단 조건이 남는다.

1. license 불명 2개를 입력 재료에서 제외하거나 upstream license를 추가 확인
2. Apache/LGPL 스킬의 정확한 upstream provenance 보강
3. attribution/NOTICE 배치 구조 승인
4. LGPL 재료를 직접 복사할지 독립 재작성할지 결정
5. 실제 Godot 버전 확인

source_skills 원본은 수정하지 않았다.

## 8. 2026-07-21 재감사 갱신

이 문서의 초기 “공개 포함 가능 25개/PN 수정본 가능 25개”는 라이선스 본문 분포와 당시 가능성 평가다. 현재 작업 판정은 `SKILL_LICENSE_REAUDIT.md`가 대체한다.

- 최종 source 수: 27
- `VERIFIED_DIRECT`: 12
- `VERIFIED_BY_EXPLICIT_BUNDLE_SCOPE`: 9
- `LICENSE_UNKNOWN`: 2
- 이번 Goal 정책상 `EXCLUDED`: LGPL 파일 동봉 Godot 4개
- Phase B eligible: `test-driven-development`, `understand`, `frontend-design`
- unknown source와 LGPL source의 원문·scripts·references는 이번 Goal 결과물에 사용하지 않는다.

현재 attribution 구조는 `licenses/`, `THIRD_PARTY_NOTICES.md`, 각 `SOURCE_AND_LICENSE.md`다. 과거 제안 구조보다 실제 저장소 구조를 우선한다.
