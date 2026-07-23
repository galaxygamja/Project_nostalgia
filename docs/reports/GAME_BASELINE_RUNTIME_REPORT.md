# Game Baseline Runtime Report

- Date: 2026-07-24
- Result: `RUNTIME_BASELINE_PASS_WITH_KNOWN_WARNINGS`

## Environment

- Binary: `C:\Users\User\tools\Godot\4.7.1-stable\Godot_v4.7.1-stable_win64.exe`
- Download: official Godot Builds release asset `Godot_v4.7.1-stable_win64.exe.zip`
- Archive SHA-256: `C7A289051EAEFB460B0106B60E9CD5BEE0EF55FD102DCB2BED1EB356CF3D90A1`
- Executable SHA-256: `323F9C4CC5DB674E98815CDD8E69DA007D5EFC779ABEDC8C0E42883B7FDEA12A`
- Authenticode: valid; signer `Prehensile Tales B.V.`
- `--version`: `4.7.1.stable.official.a13da4feb`

## Commands and results

| Command | Result |
|---|---|
| `--headless --path game_development/godot_data_core --editor --quit` | exit 0; project import/parse completed |
| `--headless --path game_development/godot_data_core --script res://tests/runtime_core_test.gd` | exit 0; existing runtime-core test completed |
| `--headless --path game_development/godot_data_core --script res://tests/game_loop_v1_test.gd` | exit 0; existing game-loop test completed |
| `--headless --path ... --quit -- --data-root=<sibling game_json_templates>` | 20 JSON loaded, 28 definitions registered, known validator result reproduced: 17 errors and 1 warning |

Godot generated `game_development/godot_data_core/.godot/` during import. It is an untracked cache and is not staged. The smoke run used the immutable sibling authoring data only; it did not copy runtime JSON into `res://data`.

## Known baseline issues retained

- `res://data` contains only its README; default bootstrap remains intentionally incomplete.
- 17 missing-reference occurrences / 15 unique IDs and one zero-active-weight pool warning are reproduced.
- IFBO semantic IDs, 100/1000-day wiring, continuous/discrete skill conflict, game-loop repository connection, and viewport difference remain unchanged.
