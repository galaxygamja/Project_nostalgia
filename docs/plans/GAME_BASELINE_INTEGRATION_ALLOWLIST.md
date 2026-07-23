# Verified Game Baseline Integration Allowlist

- Source commit: `2a9a42be9fc4c4da0bbc35c6fe96b5128c19e0f7`
- Equality checkpoint: `3138faf20df172263e59335410a349a8cdde4b83`
- Rule: each restored source file must have the same Git blob in the integration commit.

## Exact restoration paths

| Path | Files | Reason |
|---|---:|---|
| `game_development/` | 85 | Godot project, canonical authoring JSON, source schema guidance, tests |
| `docs/ssot/PROJECT_NOSTALGIA_SSOT.md` | 1 | Canonical project authority |
| `docs/ssot/SOURCE_METADATA.md` | 1 | SSoT provenance and synchronization boundary |
| `docs/context/SSOT_POINTER.md` | 1 | Canonical SSoT pointer |
| `docs/context/PROJECT_CONTEXT.md` | 1 | Project and prototype context used by skills and development planning |
| `docs/context/KNOWN_CONFLICTS.md` | 1 | Unresolved implementation and canon gates |
| `docs/audits/GODOT_DATA_CORE_AUDIT_v0.1.md` | 1 | Existing data-core findings |
| `docs/reports/GAME_DEVELOPMENT_INTAKE_REPORT.md` | 1 | Initial import manifest and provenance |

Source baseline total: 92 files. This Goal additionally creates audit and environment documentation only.

## Explicit exclusions

- `project_skills/`, previous skill commits, prompts, `AGENTS.md`, and `.gitignore`
- `goal/`, untracked source-handoff material, and user-specific configuration
- `.godot/`, logs, build/export output, executable files, archives, and generated cache
- Any schema/ID/reference repair, viewport change, JSON placement change, or feature implementation
