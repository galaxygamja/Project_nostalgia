# Development Environment Handoff

- Baseline integration source: `2a9a42be9fc4c4da0bbc35c6fe96b5128c19e0f7`
- Verified engine: Godot `4.7.1.stable.official.a13da4feb`
- Binary path: `C:\Users\User\tools\Godot\4.7.1-stable\Godot_v4.7.1-stable_win64.exe`

Use this exact binary for parser, headless, and runtime claims. Do not auto-upgrade Godot. The baseline imports and parses; its two existing headless tests pass. The data-core smoke run intentionally reaches the known validator report when pointed at the sibling 20 JSON authoring files.

Do not commit `.godot/`, the portable archive/binary, logs, or generated runtime output. Before the next implementation Goal, read `REAL_DEVELOPMENT_ENTRY_PLAN.md`, `KNOWN_CONFLICTS.md`, and `GAME_BASELINE_RUNTIME_REPORT.md`; do not repair the known issues without their separate approval path.
