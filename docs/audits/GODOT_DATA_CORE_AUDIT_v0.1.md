# Project Nostalgia — godot_data_core 전체 검증 보고서 v0.1

검증 대상: Google Drive의 `godot_data_core` 폴더  
검증 범위: 폴더 구조, JSON 문법, ID 규칙, 필수 필드, 상호 참조, 초기 상태, Godot 진입 파일, 현재 제작물과의 호환성  
검증 방식: Drive 원본 파일을 내려받아 정적 검사 및 교차 참조 검사  
제한: 현재 실행 환경에 Godot 실행 파일이 없어 실제 Godot 에디터 실행·GDScript 컴파일 검사는 수행하지 못했다.

---

## 1. 결론

`godot_data_core`는 데이터 로더·저장소·검사기의 기본 구조가 잘 잡혀 있다.

다만 현재 상태에서는 **검증을 통과하지 못한다.**

주요 이유:

1. 정의되지 않은 ID 참조 17건
2. 인카운터 ID 의미와 반복 정책 불일치 2건
3. 현재 프로젝트에서 새로 정한 단계형 능력·독서 시스템을 표현할 스키마 부재
4. 기존에 제작한 아이템 편집기·스토리·동료 JSON이 data core 형식과 호환되지 않음
5. `.godot` 생성 캐시 폴더가 공유 소스에 포함됨
6. 검사기가 잡지 못하는 참조와 타입 오류 영역이 존재함

`stop_on_validation_error`가 기본값 `true`이므로, 누락 참조가 남아 있는 동안 부트스트랩은 실패 처리된다.

---

## 2. 확인된 폴더 구조

```text
godot_data_core/
├─ project.godot
├─ main.tscn
├─ README.txt
├─ scripts/
│  ├─ main.gd
│  └─ data/
│     ├─ json_loader.gd
│     ├─ data_repository.gd
│     ├─ data_validator.gd
│     └─ data_bootstrap.gd
├─ data/
│  ├─ config/
│  ├─ initial/
│  ├─ timeline/
│  ├─ schedules/
│  ├─ actions/
│  ├─ tasks/
│  ├─ encounters/
│  ├─ characters/
│  ├─ base/
│  ├─ items/
│  ├─ locations/
│  ├─ information/
│  ├─ flags/
│  └─ formulas/
└─ .godot/
```

구조 자체는 데이터 종류가 분리되어 있어 확장하기 좋다.

---

## 3. 통과한 검사

- JSON 파일 20개 모두 문법상 정상
- JSON 최상위 값은 모두 Object
- 등록된 entries ID 중 중복 ID 없음
- 모든 entries 기반 데이터에 현재 검사기가 요구하는 필수 필드 존재
- 모든 ID가 `ABCD_001` 정규식 형식에 부합
- `_000` 예약 번호를 사용한 데이터 없음
- ID 첫 글자와 `data_type`의 기계적 대응은 정상
- `project.godot`의 메인 장면 경로와 `main.tscn`의 스크립트 경로가 실제 구조와 일치
- `game_config.json`이 가리키는 initial state, timetable, ID 규칙 파일이 존재
- 정의된 식량과 전력의 초기값은 각 자원의 최소·최대 범위 안에 있음
- 시설 생산 자원 `RXXX_004`, 임무 대상 `FXXX_001`, 공식 `XXXX_001/002` 등 존재하는 핵심 참조는 정상

---

## 4. 차단 오류: 정의되지 않은 ID 참조 17건

### 4.1 인카운터 7건

```text
IRSC_002
ISSO_001
IRBC_001
ISBO_001
ISBO_002
ISBO_020
IRBC_001  ※ tasks.json에서도 다시 참조
```

발생 위치:

- `encounter_pools.json`
- `clues.json`
- `deductions.json`
- `tasks.json`
- `timetable.json`

중복 참조를 제외한 미정의 인카운터 ID는 6개다.

### 4.2 업무 1건

```text
TCUO_001
```

발생 위치:

- `deductions.json → unlocked_task_ids`

### 4.3 인물 4건

```text
CMMB_001
CMXO_001
CMRB_001
CMAB_001
```

발생 위치:

- `initial_game_state.json → active_character_ids`

현재 `characters.json`에는 다음 두 명만 존재한다.

```text
CMCB_001 책임자
CMEB_001 기술 책임자
```

### 4.4 자원 4건

```text
RXXX_002
RXXX_003
RXXX_005
RXXX_006
```

발생 위치:

- `initial_game_state.json → resource_values`

현재 `resources.json`에는 다음 두 자원만 정의되어 있다.

```text
RXXX_001 식량
RXXX_004 전력
```

### 4.5 결과

현재 검사기 로직 기준 예상 결과:

```text
오류: 최소 17개
경고: 최소 1개
bootstrap 결과: 실패
```

경고 1개는 `PXXX_002` 풀에 활성화된 인카운터가 없어 활성 가중치 합이 0인 문제다.

---

## 5. ID 의미 불일치

`id_code_rules.json`에서 인카운터 ID의 네 번째 문자는 반복 정책을 뜻한다.

```text
O = one_time
R = repeatable
C = cooldown
D = daily_once
X = defined_in_data
```

그러나 다음 ID는 네 번째 문자가 `O`인데 실제 반복 정책은 `daily_once`다.

```text
IFBO_001
IFBO_002
```

현재 의미대로라면 다음과 같이 되는 편이 맞다.

```text
IFBD_001
IFBD_002
```

단, ID를 변경하면 `fixed_schedules.json`의 `encounter_id`도 함께 바꿔야 한다.

이 문제는 현재 검사기가 탐지하지 못한다.

---

## 6. 프로젝트 결정과 충돌 가능성이 있는 항목

### 6.1 1000일 설정

현재 코어:

```text
max_days = 1000
day_index 범위 = 0~999
```

이전 프로젝트 대화에서는 100일 제한이 논의되었다.

현재 Single Source of Truth에는 정식 게임 총 일수가 아직 `[미정]`으로 남아 있으므로 자동 수정하면 안 된다.

결정 필요:

```text
A. 실제 게임 길이 100일, 배열도 100일
B. 실제 게임 길이 100일, 기술적 시간표 용량만 1000일
C. 실제 게임 길이도 1000일
```

### 6.2 능력치 표현 방식

현재 `characters.json`:

```json
"skills": {
  "command": 60.0,
  "engineering": 80.0,
  "medical": 10.0
}
```

최근 확정한 UI 및 성장 설계:

```text
기계공학 Lv.3
■ ■ ■ □ □ □ □ □
```

현재 코어는 연속형 0~100 수치만 보유한다.

아직 없는 데이터:

- 능력 정의
- 현재 이산 레벨
- 레벨별 조건
- 조건 진행도
- 독서로 완화 가능한 조건
- 책의 담당 레벨 범위
- 선행 권 규칙
- 현재 기술 수준에 따른 선행 권 면제
- 레벨 해금 효과

따라서 UI에서만 80을 3레벨로 임의 변환하면 안 된다. 먼저 정식 데이터 스키마가 필요하다.

---

## 7. 현재 제작물과의 호환성

### 7.1 아이템 편집기 v0.3

편집기 출력:

```json
{
  "schema_version": "0.3",
  "perception_distortion": {},
  "items": []
}
```

개별 아이템 ID 규칙:

```text
coffee
portable_repair_kit
```

data core 요구 형식:

```json
{
  "schema_version": 1,
  "data_type": "item",
  "entries": [
    {
      "id": "MXXX_001"
    }
  ]
}
```

주요 불일치:

- `data_type` 없음
- `entries` 없음
- ID 정규식 불일치
- core 필수 아이템 필드와 편집기 필드 구조가 다름
- 지식·인식 붕괴·행동 수정 데이터가 core item 검사 규칙에 없음

결론:

**아이템 편집기 v0.3의 결과물을 현재 data core에 그대로 넣으면 등록 또는 검증에 실패한다.**

### 7.2 프로토타입 스토리 v0.1

기존 스토리 파일은 다음 형식을 사용한다.

```json
{
  "schema_version": "0.1",
  "story_id": "prototype_blurred_report"
}
```

data core는 인카운터에 다음 형식을 요구한다.

```json
{
  "schema_version": 1,
  "data_type": "encounter",
  "entries": []
}
```

주요 불일치:

- `data_type` 없음
- `entries` 없음
- `enc_001...` 형식 ID가 `ABCD_001` 규칙에 맞지 않음
- choices, requirements, effects 구조가 core encounter 구조와 다름
- story manifest와 별도 story 데이터 종류가 core에 정의되어 있지 않음

결론:

**기존 프로토타입 스토리는 내용 설계 자료로는 유효하지만 실행용 JSON으로는 재변환해야 한다.**

### 7.3 동료 4명 JSON

기존 파일:

```json
{
  "document_type": "prototype_companions",
  "characters": [
    {
      "id": "hong_ye_seul"
    }
  ]
}
```

data core 요구:

```json
{
  "data_type": "character",
  "entries": [
    {
      "id": "CMAB_001"
    }
  ]
}
```

결론:

**홍예슬·양동하·방준연·김동현 설정은 현재 characters 스키마에 맞춰 이관해야 한다.**

ID는 역할에 따라 후보를 만들 수 있지만 자동 확정하면 안 된다.

---

## 8. UI 프롬프트 v0.1과 data core의 관계

UI 프롬프트의 시각·상호작용 요구는 유지할 수 있다.

다만 다음 문구를 추가한 v0.2가 필요하다.

```text
- godot_data_core를 복사하거나 별도 스키마를 새로 만들지 않는다.
- 모든 실행용 JSON은 schema_version 1, data_type, entries 구조를 따른다.
- UI는 GameDataRepository를 통해 데이터를 조회한다.
- 정확한 내부 수치는 데이터에 존재할 수 있지만 질적 표시 변환 계층을 거쳐 출력한다.
- 능력·독서 시스템은 스키마 확정 전까지 임시 UI 데이터로 분리하고 core 데이터인 것처럼 저장하지 않는다.
- .godot 폴더는 결과 ZIP에서 제외한다.
```

현재 v0.1을 그대로 보내면 제작자가 새로운 데이터 구조를 만들어 core와 이중화할 가능성이 높다.

---

## 9. 검사기 자체의 빈틈

현재 `data_validator.gd`가 검사하지 않는 영역:

1. `unlock_flags`, `required_flags`, `excluded_flags`가 실제 flag key인지
2. 초기 `flags` 값의 타입이 flag 정의의 `value_type`과 맞는지
3. effect의 `target` 문자열 속 ID가 실제 존재하는지
4. `task_completion_ids` 참조
5. 스킬 이름과 스킬 값의 허용 범위
6. 시설 상태·인물 override·초기 자원값의 범위
7. 공식 leaf의 constant 타입과 variable 허용 목록
8. 연산자별 필요한 인수 개수
9. ID 코드가 허용 문자일 뿐 아니라 실제 데이터 의미와 일치하는지
10. singleton 문서가 종류별로 정확히 하나인지
11. `game_config.id_pattern`과 `id_code_rules.id_pattern`이 같은지
12. `duration_range`가 Dictionary가 아닌 잘못된 타입인지
13. 정수 필드에 소수나 문자열이 들어갔는지
14. encounter choice와 page 내부 필수 필드
15. timetable의 `max_days`, `slots_per_day`를 config에서 읽지 않고 999/47로 하드코딩함

이 빈틈들은 데이터가 늘어나기 전에 보강하는 것이 좋다.

---

## 10. 소스 관리 문제

`.godot/` 폴더가 Drive 공유 소스에 들어 있다.

`.godot`은 에디터 캐시와 가져오기 결과가 들어가는 생성 폴더이므로 공유 기준 소스에서 제외하는 편이 안전하다.

권장:

```text
제외: .godot/
유지: *.gd.uid
유지: project.godot
유지: *.tscn
```

README에 적힌 것처럼 현재 재귀 파일 검색은 개발 환경에는 적합하지만, 내보낸 빌드에서는 파일 목록이 달라질 수 있다. 출시용으로는 데이터 manifest 또는 명시적 경로 목록이 필요하다.

---

## 11. 수정 우선순위

### 1순위 — 실행 차단 제거

- 누락 ID 17건 정의 또는 참조 제거
- `PXXX_002` 활성 인카운터 추가 또는 풀 비활성 처리
- `IFBO_001/002` ID 의미 수정

### 2순위 — 스키마 단일화

- 아이템 편집기 출력을 `data_type: item / entries` 형식으로 변경
- 동료 4명을 core character 형식으로 이관
- 흐린 보고서 스토리를 core encounter/task/clue/deduction 형식으로 이관

### 3순위 — 성장 시스템 추가

추천 신규 데이터 종류 작업안:

```text
skill_definition
skill_level_requirement
reading_material
reading_progress
```

또는 기존 character/item/task를 확장하는 방식과 비교 후 확정한다.

### 4순위 — 검사기 강화

- flag key 검사
- effect target 검사
- skill/book 참조 검사
- ID 의미 검사
- config 기반 시간 범위 검사
- singleton 중복 검사

### 5순위 — UI 제작

UI는 core repository를 읽는 표시 계층으로 제작한다. 내부 숫자를 직접 보여주지 않고 질적 문구로 변환한다.

---

## 12. 수정하지 않은 사항

이번 검증에서는 원본 Drive 폴더와 파일을 수정하지 않았다.

특히 다음은 사용자 확인 없이 변경하면 안 된다.

- 100일과 1000일 중 어느 쪽을 채택할지
- 기존 캐릭터 ID를 동료 4명에게 어떻게 배정할지
- 능력 최대 레벨을 8로 확정할지
- skill·book 스키마를 신규 data_type으로 만들지 기존 문서에 합칠지
- 누락 참조를 실제 콘텐츠로 채울지 예시에서 제거할지
