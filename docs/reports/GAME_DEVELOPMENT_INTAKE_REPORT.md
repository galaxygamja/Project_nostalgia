# Game Development 정식 반입 보고서

- 조사·반입일: 2026-07-20
- 원본 로컬 경로: `game_development/`
- 작업 브랜치: `chore/import-game-development`
- 기준 commit: `040f7980fc2eb8a4c53f1f17c3855efe0d6189e8`
- 작업 방식: 기존 파일 byte를 수정하지 않는 정적 감사 및 선택적 Git 반입
- Godot 공식 기준: 4.7.1-stable

## 1. 반입 판정

실제 최상위 구조는 예상과 정확히 일치한다.

```text
game_development/
├─ godot_data_core/
├─ game_json_templates/
└─ json_authoring_guidelines.json
```

예상 밖의 최상위 파일·디렉터리는 없었다. 전체 일반 파일 85개를 반입 대상으로 확인했으며 안전 검사에서 제외해야 할 파일은 발견되지 않았다.

| 항목 | 결과 |
|---|---:|
| 반입 대상 일반 파일 | 85개 |
| 제외 파일 | 0개 |
| 총 크기 | 208,896 bytes |
| 디렉터리 | 36개 |
| 최대 파일 | `json_authoring_guidelines.json`, 49,902 bytes |
| 10 MiB 이상 파일 | 0개 |

## 2. 디렉터리와 파일 종류

```text
game_development/
├─ godot_data_core/
│  ├─ project.godot
│  ├─ main.tscn
│  ├─ README.txt
│  ├─ data/README.txt
│  ├─ scripts/
│  │  ├─ main.gd (+ UID)
│  │  ├─ data/                 # loader/repository/validator/bootstrap (+ UID)
│  │  ├─ runtime/              # state/time/schedule
│  │  └─ game_loop_v1/         # loop/action/resource/end prototype
│  └─ tests/                   # runtime/core loop test scripts
├─ game_json_templates/
│  ├─ JSON_파일_설명서.txt
│  ├─ config/, initial/, timeline/
│  ├─ base/, characters/, actions/, schedules/, tasks/
│  ├─ formulas/, encounters/, items/, locations/, flags/, information/
│  └─ 각 종류의 실제 JSON·양식 JSON·설명 TXT
└─ json_authoring_guidelines.json
```

확장자별:

| 종류 | 수량 |
|---|---:|
| `.gd` | 14 |
| `.gd.uid` (`.uid`) | 5 |
| `.tscn` | 1 |
| `project.godot` | 1 |
| `.json` | 41 |
| `.txt` | 23 |

JSON 41개는 `game_json_templates` 아래 40개(실제 데이터 20 + 양식 20)와 루트 authoring guideline 1개다.

## 3. 반입 전 안전 검사

| 검사 | 결과 |
|---|---|
| 중첩 `.git` | 0 |
| `.godot/` cache | 0 |
| temp/backup/OS 임시 파일 | 0 |
| `.log` | 0 |
| 실행 파일·script executable | 0 |
| ZIP/압축 파일 | 0 |
| secret filename 후보 | 0 |
| private key/GitHub token/AWS key/generic secret pattern | 0 |
| 사용자 계정 경로 | 0 |
| Windows/Unix 절대 경로 | 0 |
| 10 MiB 이상 파일 | 0 |
| `LICENSE`/`COPYING`/`NOTICE` | 0 |
| import/editor/generated cache directory | 0 |
| 동일 SHA-256 중복 파일 group | 0 |

외부 라이선스 파일이나 별도 저작권 고지는 자료 안에서 발견되지 않았다. 이는 제3자 권리가 없다는 법률 판정이 아니라, 로컬 반입본에 별도 license/notice 파일이 없다는 기술적 관찰이다.

제외할 파일이 없어 `.gitignore`는 변경하지 않았다. 기존 `.gitignore`의 `.godot/`, `*.tmp`, `*.log`, OS 임시 파일 규칙을 보존한다.

## 4. Godot 프로젝트 구조 검사

프로젝트 루트:

`game_development/godot_data_core/`

`project.godot` 핵심 설정:

| 설정 | 값 |
|---|---|
| `config_version` | 5 |
| `application/config/name` | `Game Data Core` |
| `run/main_scene` | `res://main.tscn` |
| feature tag | `4.7` |
| viewport | 900×540 |
| renderer | `gl_compatibility` |
| autoload | 없음 |
| plugin/addons | 없음 |

정적 참조 결과:

- `project.godot`: 존재
- `res://main.tscn`: 존재
- scene: 1개
- scene external resource: 1개, `res://scripts/main.gd`, 존재
- GDScript: 14개
- literal `preload`/`load` reference: 8개, 모두 존재
- `.gd.uid`: 5개, 모두 대응 `.gd` 존재
- UID가 없는 `.gd`: 9개(runtime 3, game loop 4, tests 2)

UID가 없는 9개 script는 현재 source 관계를 기록한 결과이며 이번 반입에서 UID를 생성하지 않았다. 확인된 scene/load path 누락은 0개다.

## 5. JSON 정적 검사

대상:

`game_development/game_json_templates/**/*.json`

| 검사 | 결과 |
|---|---:|
| 전체 template JSON | 40 |
| JSON parse 성공 | 40 |
| parse 실패 | 0 |
| 실제 data JSON | 20 |
| 양식 JSON | 20 |
| 실제 data의 `schema_version` 누락 | 0 |
| 실제 data의 `data_type` 누락 | 0 |
| `entries` 문서 | 16 |
| singleton 문서 | 4 |
| entry ID | 28 |
| 중복 ID | 0 |
| `ABCD_001` 형식 위반 | 0 |

Singleton 네 종류:

- `game_config`
- `id_code_rules`
- `initial_game_state`
- `timetable`

현재 `GameDataValidator`가 명시한 single/array reference field와 initial-state ID-key map을 정적으로 순회했다.

- 확인한 reference occurrence: 47
- 누락 reference occurrence: 17
- 누락 unique ID: 15

누락 occurrence:

| ID | 위치 |
|---|---|
| `IRSC_002` | encounter pool |
| `ISSO_001` | encounter pool |
| `IRBC_001` | encounter pool, task outcome (2회) |
| `ISBO_001` | clue source |
| `ISBO_002` | clue source, deduction unlock (2회) |
| `TCUO_001` | deduction unlocked task |
| `CMMB_001`, `CMXO_001`, `CMRB_001`, `CMAB_001` | initial active characters |
| `ISBO_020` | timetable scheduled encounter |
| `RXXX_002`, `RXXX_003`, `RXXX_005`, `RXXX_006` | initial resource map |

누락 reference를 수정하거나 새 ID를 만들지 않았다. 이 결과는 기존 `GODOT_DATA_CORE_AUDIT_v0.1.md`의 17건과 일치한다.

## 6. 문자 인코딩

대상 85개 파일 모두 UTF-8 또는 UTF-8 BOM 입력으로 정상 판독되었다.

- UTF-8 판독 성공: 85
- 판독 오류: 0
- encoding 변환: 하지 않음

Git이 line-ending을 다루는 것과 별개로 원본 working-tree 파일 내용을 이번 작업에서 열어 저장하거나 재포맷하지 않았다. commit 전 source file SHA와 staged blob SHA를 대조한다.

## 7. 감사 문서와 실제 자료의 차이

### 이전 compatibility audit와 일치

- 프로젝트 루트와 `project.godot`
- project setting
- 14 GDScript, 5 UID, 1 scene
- addons와 `.godot/` 부재
- 20 actual JSON parse 및 28 entry ID

### 과거 `GODOT_DATA_CORE_AUDIT_v0.1.md`와 차이

과거 audit은 `godot_data_core/data/` 아래 실제 20 JSON과 `.godot/` cache가 포함된 구조를 기록했다. 현재 반입본은:

- `godot_data_core/data/`에 `README.txt`만 존재
- 실제 JSON은 형제 `game_json_templates/`에 존재
- `.godot/` cache 없음
- runtime/game-loop/test GDScript가 추가되어 총 14개

따라서 현재 project를 기본 `res://data` 설정으로 실행하면 필수 20개 파일 누락이 예상된다. 이번 반입은 이를 고치지 않는다.

### 버전 증거

- `project.godot` feature: `4.7`
- README target: Godot 4.7.1
- 공식 개발·검증 기준: Godot 4.7.1-stable
- 실제 `--version`/parser/runtime 증거: 없음

## 8. 유지한 알려진 문제

이번 반입에서 다음을 수정하지 않았다.

1. `res://data` runtime JSON 누락
2. `game_loop_v1`과 canonical repository 미연결
3. continuous character skills와 discrete level 설계 차이
4. 900×540 viewport와 1920×1080 기준 차이
5. 코드의 100일 기본값과 1000일 지원 상한 불일치
6. 누락 reference 17 occurrence
7. IFBO 계열 ID 의미 문제

1000일은 예상 엔딩 시점이 아니라 시간 시스템이 지원해야 하는 상한이다. 엔딩은 일반적으로 그 전에 발생할 수 있다. 100일 기본값과의 차이는 엔딩 기간 충돌이 아니라 기본 설정 전달 및 지원 상한 불일치이며 별도 승인 없이 변경하지 않는다.

## 9. 반입 제외 목록

제외 파일 수: **0**.

기본 제외 유형은 발견되지 않았다. 향후 editor 실행으로 `.godot/`이 생성되더라도 root `.gitignore` 규칙으로 commit하지 않는다.

## 10. SHA-256 manifest

아래 path는 `game_development/` 기준 상대경로다. hash는 반입 전 원본 bytes의 SHA-256 대문자 표기다.

| 상대경로 | bytes | SHA-256 |
|---|---:|---|
| `game_json_templates/JSON_파일_설명서.txt` | 35390 | `9999F5259E778D2261B9113FD3A812A4AA8915E0B7964310DCB56D465C5523CE` |
| `game_json_templates/actions/actions.json` | 1138 | `C4DB23C099F5CC9998B5406311E28EBCD126F457FF68B752B3BD2644E804656A` |
| `game_json_templates/actions/actions_설명.txt` | 1277 | `61460B7FDD41702491A5F89B3FCE94185369A00D2B8E8AD5165EC2B6FBE5B699` |
| `game_json_templates/actions/actions_양식.json` | 391 | `4A117AB87CFF7A7C9B6A40DDC9AD0574866AF939AFEFD49269496E44E2C968E4E` |
| `game_json_templates/base/facilities.json` | 565 | `31BEEBC8147FB067335DA6770ECCDA6844C147ECD1737E08E13A7A36C97C7514` |
| `game_json_templates/base/facilities_설명.txt` | 1232 | `F66A4DD2B37D33C2915E38C7230D0A00D10DC4469033FA0C3BB46E69AE462220` |
| `game_json_templates/base/facilities_양식.json` | 507 | `ED192A374C6F58C199F471A6161A3875956B34D8582E379FBC44F3A41D7D8E4E` |
| `game_json_templates/base/resources.json` | 725 | `B81116B996770AFD090DBD59E7CD5E5C3C5B2460028DA497B43F5666ED25856E` |
| `game_json_templates/base/resources_설명.txt` | 1177 | `FCDBD254B16ACE7B9573D7BAAEC690E998462A4A475326F0BAD0978DA4322575` |
| `game_json_templates/base/resources_양식.json` | 404 | `1210A28B7C0A8565CEF66A8E2F34B52A181767C958BAA3D4126ABCF7F5D0EC8A` |
| `game_json_templates/characters/characters.json` | 1514 | `7F9F444093110E8390BB2C898B6FD0376DA4F9125CF8D359C61487F1FD5B64FD` |
| `game_json_templates/characters/characters_설명.txt` | 1431 | `CAF0096CF5D341FC28BCB1CFCAD52FD21B440B8A50692DF75819E2C8B2197769` |
| `game_json_templates/characters/characters_양식.json` | 768 | `00CDBE6FDDFA3430B32FC8A369E56419A3D1B36920CD6094F683FB449D562B31` |
| `game_json_templates/characters/status_effects.json` | 522 | `0580A7C76AA211EBB8FEB4A1E72FF823601A67332AF50F14D788BB64CC2A1A09` |
| `game_json_templates/characters/status_effects_설명.txt` | 1103 | `C1F918150ABE880650423480978B03976F5612504C976357D82740DDB0CF33DF` |
| `game_json_templates/characters/status_effects_양식.json` | 386 | `B0C267A52A954DE9E8D46D660E6C7AB6D30CE6F3A2538EE7B73B756D364CEB4B` |
| `game_json_templates/characters/traits.json` | 582 | `D4E7F783329BA3838FE33025EE32B247107EB592066D05CD4D51ED6FC2372658` |
| `game_json_templates/characters/traits_설명.txt` | 997 | `3B0F180ADBD1CB6BF21B64284F76F5CB8F3411F5003099A2C8BDC3521DA485A6` |
| `game_json_templates/characters/traits_양식.json` | 384 | `9457E1770E9E93F51E32D2B5A89A894BC28E7722851406F8744BD4945E42DB78` |
| `game_json_templates/config/game_config.json` | 442 | `A0595E63967D5A8D114FCD3A06D1E224B4490CFF566287454F5C456F8661B4E5` |
| `game_json_templates/config/game_config_설명.txt` | 1103 | `87FD7D097E07F27112CB3F9C04BCBFA553E652CF2A4D3943376AA9E38542A574` |
| `game_json_templates/config/game_config_양식.json` | 441 | `7E59CA983804749C3404111FEE71DB6CE1CEC7003CE4C100B1276CB7287F203C` |
| `game_json_templates/config/id_code_rules.json` | 3988 | `40C3604BDD863AB359045371B504DA08506E25EA6687B932D67724AFAEC7C5A0` |
| `game_json_templates/config/id_code_rules_설명.txt` | 1492 | `0B865C679ADE10502D596EFBDA637E48D6DB3B7D513D44745BDA7361A57EC452` |
| `game_json_templates/config/id_code_rules_양식.json` | 449 | `D0365A227CBCA0E8CA2557EBFDB30F3015F6F68FB5FFACC4061CBAB64ACE3AFC` |
| `game_json_templates/encounters/encounter_pools.json` | 963 | `CA1BE70874295F2544EBAE13B7FA4696E4395647D785F59A0A95CA660057BB33` |
| `game_json_templates/encounters/encounter_pools_설명.txt` | 1806 | `562AED9A0892B6163551771DBB7B36BBDE377DB7E1BDF278F9C72801DC7FB91D` |
| `game_json_templates/encounters/encounter_pools_양식.json` | 405 | `7B36B9CE3324DC6D5657537F779847DD8FB53EC4912BB11EC094CD1749857FC7` |
| `game_json_templates/encounters/encounters.json` | 2291 | `D0CBD7C97BC50220AB6273ABD19AF13FDC534DE91163D2FF696B96990CE79D4E` |
| `game_json_templates/encounters/encounters_설명.txt` | 1811 | `91FA5DFBF37350754975ABC2DD1EF8C2C4496418B6B9D21779570C0740125CDD` |
| `game_json_templates/encounters/encounters_양식.json` | 742 | `261CCC4AFEA9EE075CE6845AA5339C325C66F7C3EEA2C06E686520FE28FE0214` |
| `game_json_templates/flags/flags.json` | 796 | `8A6917D704779960E18DA4086AE5AEE5AB0249E21D8D0AB0A65C70E8F25145D0` |
| `game_json_templates/flags/flags_설명.txt` | 1201 | `7E165CA454648CB96CBA18501111EDF9AE10761C99ABD20195F4A4682A62F455` |
| `game_json_templates/flags/flags_양식.json` | 266 | `8E2A0905BD9AB7D25C6967ADB9EB511C1672D252E879F87200A67613667B6877` |
| `game_json_templates/formulas/formulas.json` | 2218 | `14B5C6AB892DCDC1FC5D08750558C5060A4F182F8894AF84FECAD98CA3545BE6` |
| `game_json_templates/formulas/formulas_설명.txt` | 1863 | `ACD32BC92828480E152CC58B7985C9C6DE95AD10629523DA08219DD4AD688BBB` |
| `game_json_templates/formulas/formulas_양식.json` | 520 | `66378D721F5959A729AAD1B90B16BCA0BAEAE1F5AD722A1669D957D1DD988D5F` |
| `game_json_templates/information/clues.json` | 646 | `C11A7817FAA245B220D7A2103546910414BF7F033CCE52939B9090C6B824F0F3` |
| `game_json_templates/information/clues_설명.txt` | 806 | `C920268D11BE77B512F530141BA47AA7EBF3ECE26868621F117E83C25274868D` |
| `game_json_templates/information/clues_양식.json` | 224 | `66CD746A2C1B63F1BE925DDDCDAD0FC441E7942518601F851591F0DF662081B9` |
| `game_json_templates/information/deductions.json` | 651 | `985A1BEE00FA9C9B9E264CE76CFF1F0F631DB1FF6174DCD21935D23763209491` |
| `game_json_templates/information/deductions_설명.txt` | 1299 | `1AE1735BED8A6308B081348096F8E5001B06C896C6B51C58A1E8988F9C97B141` |
| `game_json_templates/information/deductions_양식.json` | 358 | `5839CA12772923934A4A76C45723CCA3AC54DC7FE91BD8376D4EB808A0C612E3` |
| `game_json_templates/initial/initial_game_state.json` | 1114 | `DCACAFEE21F4A5D4FC07C97BAA1605B7F07EB89E2B70B5D234EA53BE6D5D79C0` |
| `game_json_templates/initial/initial_game_state_설명.txt` | 1599 | `05768A230CA4E2D68B05920745FAB3898F377CB49FDE1540711F95A17CED03CA` |
| `game_json_templates/initial/initial_game_state_양식.json` | 448 | `419FBEBE60FD990C8DA68C27382758D6854CAF84BE129A88E98935DA9FF2B24A` |
| `game_json_templates/items/items.json` | 396 | `6F32E0921B9050C2DC76AD949CB0C04C564DA3BF52059BE3CF899C48D6053628` |
| `game_json_templates/items/items_설명.txt` | 1126 | `E54812D98ACCBAD2BEB8555BCF184059DC1CC3A218C32A14CF553673F2FAB4C4` |
| `game_json_templates/items/items_양식.json` | 351 | `C85AA2E50EE78B018F0F15F9C1B563813E9604E2595CCC5799CBB7127641D9D3` |
| `game_json_templates/locations/locations.json` | 914 | `5BDAF6FCA33D39730F17A20F073E0494D4692C51DBE029550387424FFD4A6ECD` |
| `game_json_templates/locations/locations_설명.txt` | 1041 | `5E5F6C7047D79171D838B0ECFC3E89DEE481A642C5C96732F180D1EB4EC79F8B` |
| `game_json_templates/locations/locations_양식.json` | 335 | `E470878D891F3AA900B1FFBBB87926FF6030B2DB302D65D63EECFB881EF60556` |
| `game_json_templates/schedules/fixed_schedules.json` | 676 | `310DD9BEC692F2E87A04B50A66978BD16D57E67AF2E28109657D2236848C2C34` |
| `game_json_templates/schedules/fixed_schedules_설명.txt` | 1326 | `ADD9D50C141C7985245E7F583108101850D6126C838F679B4A4E9AC64BA21C76` |
| `game_json_templates/schedules/fixed_schedules_양식.json` | 367 | `F22EE6E7CCB0EAE947A460763C5232FD7F3DFB67FFB726E6369471D7A604B811` |
| `game_json_templates/tasks/tasks.json` | 1570 | `08EB74DCC7F896EFF052B6402F185FB4D1F1DD5196F469E5841E4DD74FAFA835` |
| `game_json_templates/tasks/tasks_설명.txt` | 2104 | `CBCDA09E3E4B8F26DC0698568F174C5476E5184FBBED907398D012818F7AE3B2` |
| `game_json_templates/tasks/tasks_양식.json` | 722 | `C62CCAD8005727D718B1FDEA9D37E1B138B3D9E71B3B32092A024ADF6C95E84F` |
| `game_json_templates/timeline/timetable.json` | 680 | `702D52443058921E272020547E83054F90F7F12A66564037CBBA04E35003FC65` |
| `game_json_templates/timeline/timetable_설명.txt` | 1358 | `84C18D20234ABCCC3FD1D384519B733E1DBB2F9F4311473A1610B1F1634648DA` |
| `game_json_templates/timeline/timetable_양식.json` | 492 | `4C2638FA729EB09D0D75CC810C8EDAD532BCC2C4FEDF342E3ECD76DDEEA992C7` |
| `godot_data_core/README.txt` | 2495 | `0F972B9B590775AFFF89ECA385FD42210EE8B1C666B63F24D2F9CCEEEF6F6473` |
| `godot_data_core/data/README.txt` | 341 | `9F892EC4B6A1C9D447517830E187DDB77F665D19011DEB49A00CC03D9B3095F3` |
| `godot_data_core/main.tscn` | 167 | `4FE6A7BFA7496897011B0E149E2AB197650D47657D2D01D68B5604CF1D59B626` |
| `godot_data_core/project.godot` | 564 | `2947E1224064D2B6F27E20DD9F4723B284C42FE400BAA4D3448D71BED0F2F7B1` |
| `godot_data_core/scripts/data/data_bootstrap.gd` | 3828 | `2A3959A6F36E637D0533CFFEDEC628F712CF29AF26B8B2EB9B5361B69A7CEECA` |
| `godot_data_core/scripts/data/data_bootstrap.gd.uid` | 20 | `6F3286790C0CE40C1BCE396902A6624FC8E8B797BA623EB906C9CE44BA78E191` |
| `godot_data_core/scripts/data/data_repository.gd` | 6611 | `29B93EA46E33558AA9EC4D912AF333D62C1FCE4C33F7345D588D0C43E8D2B686` |
| `godot_data_core/scripts/data/data_repository.gd.uid` | 20 | `A41E37A3200C66661742B825B46872898AA5F11C81BF010D740D39A1B4734C37` |
| `godot_data_core/scripts/data/data_validator.gd` | 28199 | `187DC5420077ABD762DF82FD293EB1D9E69006E4FD3226ED63BBC1E14E4DE8DF` |
| `godot_data_core/scripts/data/data_validator.gd.uid` | 19 | `F4E750E1F0EA3C7D52C603BA6E678939660875BC66323D1200F3BAE10CBCE855` |
| `godot_data_core/scripts/data/json_loader.gd` | 3730 | `ACCBD5213662C7497C6370DE2EE81E7455DB7AD7E29A71D245705E8280985FAB` |
| `godot_data_core/scripts/data/json_loader.gd.uid` | 20 | `67FB60A42D5EBD592F66A989F93F2BA538FA4B7249975B3F277394B792284A13` |
| `godot_data_core/scripts/game_loop_v1/action_resolver_v1.gd` | 1896 | `58FD720C9CAE3D4FF50604AE786B45FFA9A5CC58A8843E41A25BA851F6413FD4` |
| `godot_data_core/scripts/game_loop_v1/end_condition_registry_v1.gd` | 499 | `5359E6781A5C279039846231E3C7B62E0EFE99C5F71DE0AA836212D44C00F171` |
| `godot_data_core/scripts/game_loop_v1/game_loop_v1.gd` | 5163 | `7A51E901BAB3696198C1458C666C8BF6CFB0AD708C65A012F0ADCD57C15E8C2A` |
| `godot_data_core/scripts/game_loop_v1/resource_tick_processor_v1.gd` | 849 | `39B0E7F776DF96F57E62A76D7FDBF760F8785FECDC8550CA0F173F96AC31A532` |
| `godot_data_core/scripts/main.gd` | 1214 | `A6DCF23F33538896CE30A4ADA78DF23469F275F5B304EE5BF98247F03B753AC6` |
| `godot_data_core/scripts/main.gd.uid` | 20 | `89DFBA966591E2067C0C4FCEEE7C8DA083CAEF3A42B3E54845E61DFCDF9FC8A4` |
| `godot_data_core/scripts/runtime/game_state.gd` | 2282 | `9E25160CA1663A864725324627FC16DE64706C1465F81ADDDD9C1E306DA02D26` |
| `godot_data_core/scripts/runtime/schedule_manager.gd` | 2380 | `F1361C0DFF23A1A830828108D51A785E0E48592B400B9C6C0530018F2C87C8D0` |
| `godot_data_core/scripts/runtime/time_manager.gd` | 2796 | `4B266415666C0C0BA9304B924B6379B2D4B8DEC4A70CEF3B4E80E4E5AE23079A` |
| `godot_data_core/tests/game_loop_v1_test.gd` | 1015 | `3AD1C61F38A37F6A2EADB8219D819D8A2CCA65733B0D6A6BDDA994574CE917F7` |
| `godot_data_core/tests/runtime_core_test.gd` | 973 | `DA2FF8516E5EDAE55B0BF0C8BAAA5A7C5F8D18D6C2B25AFB9C2A895533B2F0D0` |
| `json_authoring_guidelines.json` | 49902 | `BCC0F6265BA2ED2E078925E8B023F5EC6E7C1946E4519F5783B47E088B06A6EE` |

## 11. 다음 검증 항목

1. 정확한 Godot 4.7.1-stable binary의 `--version` 확인
2. 별도 승인된 작업에서 parser/headless project load
3. runtime JSON 배치 방침 결정 후 bootstrap 실행
4. 누락 reference 17건과 IFBO semantic conflict의 설계 승인
5. 1000일 support ceiling을 runtime config에 전달하는 방식 승인
6. game loop와 canonical repository 통합 계획
7. 1920×1080 UI project setting 및 실제 capture 검증

이번 반입은 보존과 추적 가능성 확보만 수행하며 위 문제를 수정하지 않는다.
