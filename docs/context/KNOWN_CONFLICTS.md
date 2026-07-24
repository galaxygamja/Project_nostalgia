# Known Conflicts, Gaps, and Decisions Requiring Approval

Codex must not silently resolve these.

## 1. Item knowledge stages

The current Google Docs SSoT still contains a provisional five-stage line:

`미확인 → 용도 파악 → 사용 경험 있음 → 전문가 확인 → 정밀 분석`

A later user-approved design uses three display stages:

`미확인 → 식별됨 → 전문가`

The later design removes separate “사용 경험 있음” and “관련 경험” stages. This overlaps the existing SSoT text. Do not overwrite the SSoT automatically; present the difference and request explicit approval before canonical replacement.

## 2. Total game duration

- SSoT: full-game total days remain `[미정]`.
- Current core: `max_days=1000`, day 0–999.
- An earlier discussion considered 100 days.

Do not choose 100 or 1000 as final canon without approval. Prototype duration is separately fixed at 3 days.

## 3. Time slots versus action slots

- SSoT rejects a fixed number of daily actions.
- Current simulation discussion uses 30-minute units and 48 internal slots per day.

These can coexist: slots are time resolution, not a daily action allowance. Do not redesign this into “48 actions per day.”

## 4. Skill representation

- Current core character skills are continuous 0–100 floats.
- Later approved design uses discrete levels with condition-based promotion and books that reduce requirements.

The core lacks canonical skill definitions, level conditions, progress state, book bands, prerequisite exceptions, and unlock effects. A schema change requires a proposal and migration plan before implementation.

## 5. Missing core references

The data-core audit found 17 missing-reference occurrences. With `stop_on_validation_error=true`, bootstrap is blocked until these are resolved. Do not invent replacement IDs without inspecting design intent.

## 6. Fixed-schedule semantic IDs — resolved 2026-07-24

The user approved the `daily_once` interpretation. Canonical authoring and generated
runtime data use `IFBD_001` and `IFBD_002`; the fourth-character `D` matches the
`daily_once` policy. All known schedule and guideline references were updated together.

## 7. Existing content packages are not runtime compatible

The following are drafts or separate schemas and must not be copied directly into `godot_data_core`:

- item editor v0.3 output,
- prototype companions JSON,
- prototype story package,
- current UI temporary `ui_data.json`.

They require explicit mapping to the canonical envelope and ID rules.

## 8. UI prompt versions

`PN_UI_제작_프롬프트_v0.1.md` predates the canonical core and can lead to a parallel schema. `PN_UI_수정_프롬프트_v0.2.md` and the human-design skill are more recent, but all UI work must explicitly use `godot_data_core` and the qualitative display layer.

## 9. Prototype cast versus full-game cast

The four prototype companions are fixed for the prototype. The final full-game cast and exact final number remain undecided.

## 10. Runtime verification

The existing UI v0.2 passed custom static checks and ZIP integrity checks only. No Godot executable test occurred. Any new claim of runtime success must include the Godot version, command, exit result, and captured output/screenshot.
