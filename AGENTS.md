# Project Nostalgia — Codex Repository Instructions

## First read order

1. `docs/context/SSOT_POINTER.md`
2. The repository's canonical SSoT file after migration, normally `docs/ssot/PROJECT_NOSTALGIA_SSOT.md`
3. `docs/context/PROJECT_CONTEXT.md`
4. `docs/context/KNOWN_CONFLICTS.md`
5. `docs/audits/GODOT_DATA_CORE_AUDIT_v0.1.md`
6. The task-specific plan under `docs/plans/`, when present

This file is a map, not the full encyclopedia. Follow the linked documents.

## Authority and conflict protocol

- The SSoT is the highest authority for worldbuilding, systems, UI, content, characters, story, endings, and implementation intent.
- `[확정]` is mandatory. `[작업안]` is provisional. `[미정]` must not be silently decided.
- Never overwrite or merge an existing definition merely because a new proposal looks better.
- When new content overlaps or conflicts with existing content, stop before editing and report:
  1. existing rule,
  2. proposed rule,
  3. exact difference,
  4. files and IDs affected,
  5. whether this is a numeric balance change or a setting/system change.
- Wait for explicit user approval before replacing an existing definition.
- Do not edit the canonical SSoT unless the task explicitly requests it. Any approved SSoT edit must append a dated change-log entry.

## Canonical runtime data rules

- `godot_data_core` is the canonical runtime data architecture.
- Runtime JSON envelope:
  - `schema_version: 1`
  - `data_type`
  - `entries`
- IDs use the compositional form `ABCD_001` and must follow `id_code_rules.json`.
- Load data through `GameJsonLoader`, register through `GameDataRepository`, validate through `GameDataValidator`, and initialize through `GameDataBootstrap`.
- Do not create a parallel repository, alternate ID system, or second JSON envelope.
- Human-authored Korean source is the editing source of truth for repeatable content. Generated JSON is runtime output.
- Separate `requirements` from `effects`.
- Separate player-visible information from exact internal mechanics.
- Formulas must be structured data, not executable code strings.
- Verify every referenced ID exists and every generated ID is unique.

## Time model

- The prototype spans 3 in-game days.
- The current simulation resolution is 30 minutes: 48 slots per day.
- Cooldowns and schedule conflicts compare absolute slots.
- This is an internal time grid, not a fixed daily action-count system.
- Actions and movement consume variable amounts of time and may span multiple slots.
- The player can re-plan after actions or disruptions.

## Core game constraints

- Text-heavy hardcore base survival and management.
- The player is one physically and mentally limited base leader.
- The leader's condition changes perceived text, numbers, choices, memory, and time perception.
- Difficulty must be hard but fair: warnings, causes, and responses must exist.
- Checking, delegation, and rest must be meaningful responses.
- Directly doing everything must not be the dominant strategy.
- Hidden choices require in-world clues/deductions/plans; player foreknowledge alone is insufficient.

## Subjective distortion versus AI manipulation

- Fatigue/stress distortion is subjective perception.
- AI manipulation affects only electronic/network-accessible external systems through a plausible intrusion path.
- AI cannot directly rewrite inner monologue, subjective status UI, paper records, isolated analog gauges, or face-to-face speech.
- Serious distortion requires warning signs and countermeasures.
- Do not randomly lie to the player without investigable evidence.

## UI constraints

- The UI must not tell the player conclusions they should infer.
- Prefer raw evidence, conflicting records, testimony, logs, and documents.
- Do not build a generic mobile dashboard or a grid of repetitive rounded cards.
- Target actual 1920×1080 output when working on the current PC prototype.
- Main UI hides exact internal resource and leader percentages unless the protagonist has a valid measurement basis.
- Use qualitative labels and reasons; detailed screens may reveal more precise information when justified.
- Skills use segmented/discrete level presentation, not continuous percentage bars.
- Subjective distortion and electronic tampering need distinct visual languages.

## Prototype cast

- 홍예슬 — 부책임자
- 양동하 — 시설 기술자
- 방준연 — 의료 담당자
- 김동현 — 탐사·통신 담당자

These are fixed for the prototype, not necessarily the final full-game cast.

## Engineering workflow

- For non-trivial changes, write or update a plan before implementation.
- Use test-driven development for time calculations, conditions, delayed effects, reference validation, save/load, and simulation logic.
- Debug systematically; do not patch symptoms without identifying the cause.
- Before claiming completion, run the relevant tests and record commands and results.
- Never claim a Godot runtime test passed when only static validation was performed.
- Do not commit `.godot/`. Preserve `.gd.uid`, `project.godot`, `.tscn`, source, data, and tests.
- Work on a dedicated branch for migrations or large refactors.
- Avoid unrelated cleanup in the same change.

## Completion report format

Report:

1. files changed,
2. behavior changed,
3. SSoT impact or “none”,
4. schema/ID impact,
5. tests and exact results,
6. unresolved risks,
7. decisions requiring user approval.
