# Game Baseline Provenance Audit

- Audit date: 2026-07-24
- Integration source: `2a9a42be9fc4c4da0bbc35c6fe96b5128c19e0f7`
- Verification snapshot: `3138faf20df172263e59335410a349a8cdde4b83`
- Result: `READY_FOR_EXACT_BLOB_INTEGRATION`

## Source decision

`2a9a42` is the first game-development import commit. Against its parent `040f798`, it adds 86 paths only: 85 files under `game_development/` and this repository's original intake report. It contains no rename, deletion, executable, symlink, archive, cache, or large binary.

`git diff --name-status` and `git diff --raw` for `2a9a42..3138faf -- game_development docs/ssot` are empty. The two snapshots therefore have byte-identical `game_development/` (85 files) and `docs/ssot/` (2 files). The initial import is used as the provenance source; `3138faf` is retained unchanged as the independent equality checkpoint.

## Included provenance boundary

- Game project, authoring JSON, schema guidance: `game_development/`
- Canonical authority and required project context: selected `docs/ssot/`, `docs/context/`, and data-core audit files listed in `GAME_BASELINE_INTEGRATION_ALLOWLIST.md`
- `Project_Nostalgia_Codex_Handoff_v0.1/` is not a tracked tree in either source commit. It is not restored or staged.

No SSoT wording, status tag, runtime JSON value, schema, ID, or Godot source content was authored or altered by this audit.
