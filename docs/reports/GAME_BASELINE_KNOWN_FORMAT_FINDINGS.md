# Game Baseline Known Format Findings

- Baseline source: `2a9a42be9fc4c4da0bbc35c6fe96b5128c19e0f7`
- Check: `git diff --check 5dfa393..2a9a42 -- <baseline allowlist>`
- Policy: `KNOWN_BASELINE_FORMAT_FINDING`; no remediation in this Goal.

## Recorded source findings

| Path | Finding count | Finding |
|---|---:|---|
| `docs/ssot/PROJECT_NOSTALGIA_SSOT.md` | 343 | trailing whitespace |
| `docs/audits/GODOT_DATA_CORE_AUDIT_v0.1.md` | 3 | trailing whitespace |
| Total | 346 | source-existing formatting only |

The source total is recorded from the exact allowlist, not rounded from earlier whole-snapshot estimates. Integration validation must reproduce these source findings at the same file and line locations, produce zero new findings, and produce zero allowlist-external findings. No SSoT reformatting, changelog edit, or whitespace cleanup is authorized here.
