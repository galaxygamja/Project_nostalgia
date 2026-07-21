# Project Nostalgia source skill 라이선스 재감사

- 재감사일: 2026-07-21
- branch: `audit/reverify-remaining-skill-licenses`
- 기준 commit: `63f144dcdf399b1cf52ec8d2cc7a2d1f3039c7c0`
- source root: `Project_Nostalgia_Codex_Handoff_v0.1/source_skills/Project_nostalgia_Skills_v0.6/`
- 발견한 `SKILL.md`: 27개
- source 수정: 없음

## 1. 판정 기준

- `VERIFIED_DIRECT`: 개별 skill 디렉터리의 LICENSE와 SKILL의 직접 연결 또는 같은 배포 단위가 확인됨
- `VERIFIED_BY_EXPLICIT_BUNDLE_SCOPE`: 상위 package/manifest가 하위 skill을 포함하고 license를 명시함
- `INCOMPLETE_PROVENANCE`: license 종류는 보이지만 source·권리자·배포 단위 근거가 부족함
- `LICENSE_SCOPE_UNCLEAR`: 인접 license가 해당 skill에 적용된다는 연결이 불명확함
- `LICENSE_UNKNOWN`: license grant를 찾지 못함
- `EXCLUDED`: 이번 Goal의 명시적 정책으로 직접 파생하지 않음

개별 디렉터리 LICENSE를 다른 sibling으로 확대하지 않았고, monorepo scope는 package metadata로 확인했다. LGPL 재료는 이번 Goal에서 직접 파생하지 않는다는 사용자 규칙을 최종 적용했다.

## 2. 최종 집계

| 분류 | 수 |
|---|---:|
| `VERIFIED_DIRECT` | 12 |
| `VERIFIED_BY_EXPLICIT_BUNDLE_SCOPE` | 9 |
| `INCOMPLETE_PROVENANCE` | 0 |
| `LICENSE_SCOPE_UNCLEAR` | 0 |
| `LICENSE_UNKNOWN` | 2 |
| `EXCLUDED` | 4 |
| 합계 | 27 |

라이선스 본문 기준 분포는 MIT 17, Apache-2.0 4, LGPL-3.0 파일 동봉 4, license 없음 2다. `EXCLUDED` 4개는 LGPL 파일의 최종 법적 적용 범위를 확정한 표현이 아니라, 이번 Goal의 직접 파생 금지 정책을 반영한 작업 분류다.

## 3. 전체 source skill 판정

경로는 source root 기준이다.

| # | skill | SKILL SHA-256 | license 근거와 SHA-256 | 최종 분류 | 핵심 근거 |
|---:|---|---|---|---|---|
| 1 | `algorithmic-art` | `3BC4092C09804853186524C826BC0621B940BB6122C05B84496DFF95388E6EEF` | `algorithmic-art/LICENSE.txt` `BC6B3AF2F331CBC7FB0DA1344EFB2CBE5877A31498B4D70DBC7000F3405A1362` | `VERIFIED_DIRECT` | frontmatter 직접 연결; Apache-2.0; © 2026 Anthropic, PBC. |
| 2 | `baoyu-article-illustrator` | `CE1C7BFE9B93E5AFAC1DBEAC95A03F8ABF8C102AEECC34A33D8F13DC10E64ACD` | `baoyu-article-illustrator/baoyu-skills__LICENSE.txt` `601839401F6CE68B7A8AEC0F7BA247AB8EF0848113378220BEC4B2615CC84EE7` | `VERIFIED_DIRECT` | MIT; © 2026 Jim Liu; SKILL homepage가 upstream을 명시 |
| 3 | `baoyu-diagram` | `55A2D050C3A2FAEA8721D1CEC31749DFAFA7E7D346A586E99E757F77A3526860` | `baoyu-diagram/baoyu-skills__LICENSE.txt` `601839401F6CE68B7A8AEC0F7BA247AB8EF0848113378220BEC4B2615CC84EE7` | `VERIFIED_DIRECT` | 개별 디렉터리에 MIT와 © 2026 Jim Liu 고지 동봉; 정확한 upstream subpath는 미기록 |
| 4 | `humanizer` | `243AECDAFECB5E11C2D45E2E088B7876E3F6EEE34AA50C53F624D8468039AFA8` | `blader_humanizer/blader_humanizer__LICENSE.txt` `4AC4810254AB36D45419141AEB8E69BF50652CFAFE5B2DAB947D06D44E5CBF96` | `VERIFIED_DIRECT` | frontmatter MIT; © 2025 Siqi Chen |
| 5 | `canvas-design` | `A1F288079624402F30682753C1D43920B6664785698D21D3E7AA197450A6448B` | `canvas-design/LICENSE.txt` `BC6B3AF2F331CBC7FB0DA1344EFB2CBE5877A31498B4D70DBC7000F3405A1362` | `VERIFIED_DIRECT` | frontmatter 직접 연결; Apache-2.0; © 2026 Anthropic, PBC. |
| 6 | `frontend-design` | `1608EA77FBB6FC30D13A97D12CFA8EBF31358D40F0DD97BEED24829D6B3F45DD` | `frontend-design/LICENSE.txt` `0D542E0C8804E39AA7F37EB00DA5A762149DC682D7829451287E11B938E94594` | `VERIFIED_DIRECT` | frontmatter 직접 연결; Apache-2.0; 로컬 권리자·연도·upstream URL은 미기록 |
| 7 | `godot-resource-data-patterns` | `DD32E1DB77A8A11AC6E2FE94D84332D79D47F4123204A91796761E42F22A81A5` | `Godot Resource Data Patterns/GD-Agentic-Skills__LICENSE.txt` `E3A994D82E644B03A792A930F574002658412F62407F5FEE083F2555C5F23118` | `EXCLUDED` | LGPL-3.0 표준문 동봉이나 skill 권리자·upstream·적용 선언 미기록; Goal에서 LGPL 직접 파생 금지 |
| 8 | `dialogue-system` | `1BC4883FE5D3F94E343924F2FD34D946CBFB1CC685156571426765B3DADBD9C9` | 없음 | `LICENSE_UNKNOWN` | `mcpmarket-version: 1.0.0` 외 source·권리자·license 없음 |
| 9 | `godot-master` | `00846578F404CA2924B8E8E0402C54592C52D41D6F548250F38B4BCE8846CB48` | 없음 | `LICENSE_UNKNOWN` | SKILL + 1,322 보조 파일에 적용되는 license/provenance 없음 |
| 10 | `godot-save-load-systems` | `1533CF05D76A7883A39B08D3452054D6306A70B7CE0474E551A2F8CDB3E3B655` | `godot-save-load-systems/GD-Agentic-Skills__LICENSE.txt` `E3A994D82E644B03A792A930F574002658412F62407F5FEE083F2555C5F23118` | `EXCLUDED` | LGPL 동봉·적용 선언 미기록; Goal 정책상 제외 |
| 11 | `godot-state-machine-advanced` | `8BEB9B5AC4C23D96CEFFF40D55098847436652062CBBA6A0891714645EA39653` | `godot-state-machine-advanced/GD-Agentic-Skills__LICENSE.txt` `E3A994D82E644B03A792A930F574002658412F62407F5FEE083F2555C5F23118` | `EXCLUDED` | LGPL 동봉·적용 선언 미기록; Goal 정책상 제외 |
| 12 | `godot-ui-rich-text` | `25B2505D6E7759E886DEB995395F9BB19985029DD06776F5BC24988B93DBA338` | `godot-ui-rich-text/GD-Agentic-Skills__LICENSE.txt` `E3A994D82E644B03A792A930F574002658412F62407F5FEE083F2555C5F23118` | `EXCLUDED` | LGPL 동봉·적용 선언 미기록; Goal 정책상 제외 |
| 13 | `requesting-code-review` | `1017CCDD5BC61FAB67C654CF118CBDB520464B313073A0A6B9A6B9AA647A3AD6` | `requesting-code-review/obra_superpowers__LICENSE.txt` `A37E0E9697144819E1D965176AC4AE5BC3FA02D11E7812036BBCADF6DAFE2400` | `VERIFIED_DIRECT` | MIT; © 2025 Jesse Vincent; 개별 skill 배포 단위에 동봉 |
| 14 | `skill-creator` | `DCD4803E61E913E6FC27294184CD3A71F09F5E924FF20C8A9A20173E7B3C2BCF` | `skill-creator/LICENSE.txt` `BC6B3AF2F331CBC7FB0DA1344EFB2CBE5877A31498B4D70DBC7000F3405A1362` | `VERIFIED_DIRECT` | 개별 디렉터리 Apache-2.0; © 2026 Anthropic, PBC.; frontmatter license 필드는 없음 |
| 15 | `systematic-debugging` | `3B20719ECA4F0461CB51A195221320D775DCF03B6859271066A03A5132A6CE7A` | `systematic-debugging/obra_superpowers__LICENSE.txt` `A37E0E9697144819E1D965176AC4AE5BC3FA02D11E7812036BBCADF6DAFE2400` | `VERIFIED_DIRECT` | Phase A에서 재검증 완료 |
| 16 | `test-driven-development` | `B5B4717B8B761CCE15A6CFE9022E33FD959E0894C0C39D72C9CB49C23486C10E` | `test-driven-development/obra_superpowers__LICENSE.txt` `A37E0E9697144819E1D965176AC4AE5BC3FA02D11E7812036BBCADF6DAFE2400` | `VERIFIED_DIRECT` | MIT; © 2025 Jesse Vincent; 개별 skill 배포 단위에 동봉 |
| 17 | `understand` | `F5AEFE356DE4B98D07D1EB622FE72EEE218994AA297029427F417D7278D248CC` | `understand-anything/Understand-Anything/LICENSE` `39C324F3C75AE857351F805F49E98EC06D2CD6F8313DF4A56BDED5D769B27E72` | `VERIFIED_BY_EXPLICIT_BUNDLE_SCOPE` | root package MIT와 repository URL이 하위 plugin을 포함 |
| 18 | `understand-chat` | `BD982A64EE1691733DD4684FB1F6DFC833E28ADA6C73A8C1DB4611113FBC0A23` | 같은 monorepo LICENSE | `VERIFIED_BY_EXPLICIT_BUNDLE_SCOPE` | © 2026 Yuxiang Lin; © 2026 Infinite Universe, Inc. |
| 19 | `understand-dashboard` | `7C0B3A9DB4E4F0D254B33A41096BF3A3338C6F32D0CC39B6552F6B7B63D06A8E` | 같은 monorepo LICENSE | `VERIFIED_BY_EXPLICIT_BUNDLE_SCOPE` | root `package.json` license/repository 명시 |
| 20 | `understand-diff` | `0D99E1140812A336025C6779899EF0F439AE0FBA115527F98695E57A2BA12245` | 같은 monorepo LICENSE | `VERIFIED_BY_EXPLICIT_BUNDLE_SCOPE` | Phase A에서 재검증 완료 |
| 21 | `understand-domain` | `BB4C9B652616CBF03913333783837DD87D158700EFD5BAD80144120D6555F8CE` | 같은 monorepo LICENSE | `VERIFIED_BY_EXPLICIT_BUNDLE_SCOPE` | root package scope |
| 22 | `understand-explain` | `E8C10DCAE7E9BA7ECA136B4B27290F0362D5D0E0388209FF7DC33C50390544B9` | 같은 monorepo LICENSE | `VERIFIED_BY_EXPLICIT_BUNDLE_SCOPE` | root package scope |
| 23 | `understand-figma` | `4CAD5F9F74D6DF58D185C276B7646A1AC841168FE44E1B19771F1FA23C93EF65` | 같은 monorepo LICENSE | `VERIFIED_BY_EXPLICIT_BUNDLE_SCOPE` | root package scope; Figma input/API 권리는 별도 |
| 24 | `understand-knowledge` | `BF3FDD448FCEACE2CF9948228D6DB3B9D899A2E7468795F1D5E00F2270AC8D85` | 같은 monorepo LICENSE | `VERIFIED_BY_EXPLICIT_BUNDLE_SCOPE` | root package scope; 입력 content 권리는 별도 |
| 25 | `understand-onboard` | `B1782DCCA6CD548CCEBAABC674159C72A045893DDDB61DE5DBB3F2B9E0822EF1` | 같은 monorepo LICENSE | `VERIFIED_BY_EXPLICIT_BUNDLE_SCOPE` | root package scope |
| 26 | `verification-before-completion` | `EA52D15AABAF72BC6B558EFE2C126F161B53961090DDCD712000273BFE8C7B6C` | `verification-before-completion/obra_superpowers__LICENSE.txt` `A37E0E9697144819E1D965176AC4AE5BC3FA02D11E7812036BBCADF6DAFE2400` | `VERIFIED_DIRECT` | Phase A에서 재검증 완료 |
| 27 | `writing-plans` | `272E1AF349F5062C28DC282B3E21B220D58D683A7314A10C455B7432EC91D845` | `writing-plans/obra_superpowers__LICENSE.txt` `A37E0E9697144819E1D965176AC4AE5BC3FA02D11E7812036BBCADF6DAFE2400` | `VERIFIED_DIRECT` | Phase A에서 재검증 완료 |

Understand Anything root `package.json` SHA-256은 `21DC6A4039B49A85159056128BADBF435415F7910C4DCEC73454761A3C888EBB`이며 `license: MIT`와 `Egonex-AI/Understand-Anything` repository를 명시한다.

## 4. 특별 대상 판정

- `algorithmic-art`, `canvas-design`: Apache-2.0과 Anthropic 2026 고지가 직접 확인됐다. 기존 “권리자 불명”은 오류다.
- `skill-creator`: 같은 Apache/Anthropic 고지가 확인됐다. frontmatter에 license 필드가 없다는 provenance 강도 차이는 유지한다.
- `frontend-design`: SKILL은 LICENSE를 직접 가리키지만 LICENSE에 권리자·연도·upstream URL은 없다. 추측하지 않는다.
- Godot 4개: 동일 LGPL 표준문 외에 해당 skill 권리자와 정확한 upstream을 확인하지 못했다. 이번 Goal에서는 직접 파생하지 않는다.
- `dialogue-system`, `godot-master`: license grant가 없으므로 원문·scripts·references를 사용하지 않는다.

## 5. 배치 1 반영 확인

배치 1 네 source SHA와 각 `SOURCE_AND_LICENSE.md`는 4/4 일치한다. Understand Anything 원본 LICENSE SHA는 `39C3...7E72`, 저장소 정규화 사본은 `24C4...02BC`이며 텍스트가 같고 줄바꿈만 다르다.

## 6. Phase B 라이선스 관문

라이선스와 승인된 일대일 결과물 이름을 함께 만족하는 후보는 다음 세 개다.

1. `test-driven-development` → `pn-simulation-tdd`
2. `understand` → `pn-repository-map`
3. `frontend-design` → `pn-narrative-ui-director`

`godot-save-load-systems` → `pn-save-migration`은 LGPL 직접 파생 금지로 제외한다. 나머지 verified source는 승인된 결과물 이름 부재, 역할 불연속 또는 배치 1 중복 때문에 보류한다.

## 7. 미해결 provenance 한계

- `frontend-design` 권리자·연도·upstream URL 미기록
- 일부 개별 MIT skill의 정확한 upstream subpath/URL 미기록
- Godot 4개는 LGPL 파일과 source 저작권·적용 범위 연결이 불완전
- 외부 API, font, npm dependency, 입력 content의 권리는 각 사용 시 별도 확인

이 한계는 기록된 범위 밖 사실을 추측하지 않는 조건으로 유지한다.

## 8. 조사·검증 기록

- 읽기 전용 subagent 3개 사용: MIT/Apache 근거, LGPL/unknown 근거, 기존 문서 대조
- subagent 파일 수정·생성·Git 작업: 0
- 메인 재확인: source `SKILL.md` 27개, frontmatter name 27개 unique
- `python project_skills/tools/validate_project_skills.py`: exit 0; skill 디렉터리 4개, Markdown 36개, eval 1개
- `git diff --check`: exit 0
- Phase L 금지 경로 tracked diff: 0
- secret pattern 및 10 MiB 초과 Phase L 문서: 0
- Godot/runtime 검증: 수행 대상 아님
