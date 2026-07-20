# Artifact Inventory and Compatibility Notes

## Important local artifacts from the previous workspace

| Artifact | Role | Compatibility / warning |
|---|---|---|
| `Project_nostalgia_Skills_v0.6.zip` | Upstream skill collection | Not yet Project-Nostalgia-customized |
| `PN_godot_data_core_검증보고서_v0.1.md` | Core audit | Use as current known defect list |
| `project_nostalgia_ui_prototype_v0_2.zip` | Revised UI prototype | Static validation only; no Godot runtime proof |
| `PN_UI_HUMAN_DESIGN_SKILL_v0.1.md` | UI design guidance | Useful input for future project skill |
| `PN_UI_수정_프롬프트_v0.2.md` | UI correction prompt | More current than v0.1 |
| `PN_UI_제작_프롬프트_v0.1.md` | Original UI prompt | Outdated and may encourage parallel schema |
| `item_json_editor_v0_3.*` | Human-readable item editor | Output is incompatible with core schema |
| `prototype_story_v0_1.*` | Prototype narrative draft | Requires core-schema migration |
| `prototype_companions_v0_1.*` | Prototype companion draft | Requires core-schema migration |

## Known checksums

- `Project_nostalgia_Skills_v0.6.zip`  
  `3f5978d68b1c14b36405321a20f60724e31e5bbf4ae85a7d3979c763a99378c7`
- `project_nostalgia_ui_prototype_v0_2.zip`  
  `480ce534e80c7f714912601ca7c09ed63ad045bae2e9f00e721851679b4d66d8`
- `PN_godot_data_core_검증보고서_v0.1.md`  
  `e71279c0b441eb6d293f8c9ea3487fc5e39065c31e3107cd65bcd34859b075f4`

## Google Drive migration source

The configured `Game Development` folder contains at least:

- `godot_data_core/`
- `game_json_templates/`
- `게임 프로젝트 설정 기준서 — Project_Nostalgia`
- `json_authoring_guidelines.json`

Preserve relative structure during migration, but exclude `.godot/` from source control.
