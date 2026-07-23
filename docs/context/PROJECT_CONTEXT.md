# Project Nostalgia — Project Context Handoff

## Purpose

This document transfers the accumulated project context from the prior ChatGPT design sessions to a local Codex workflow. It contains decisions, implementation state, known incompatibilities, and guardrails. It is not a replacement for the canonical SSoT.

## Project identity

- Development codename: **Project Nostalgia**.
- The codename is separate from the undecided commercial title.
- Engine: Godot.
- Genre: text-heavy hardcore base survival and management.
- Player role: one vulnerable human leader managing a survival base and their own body and mind.
- Core themes:
  - “당신은 기지를 관리한다. 하지만 당신의 상태를 관리하는 사람은 누구인가.”
  - “당신이 관리해야 할 마지막 자원은 당신 자신이다.”

## World and long-term structure

- Nuclear war and nuclear-winter-like collapse destroyed surface agriculture and logistics.
- Hostile self-replicating AI expanded after the collapse.
- The top-level AI data center/core is on the Moon.
- The exact cause of the AI's rebellion remains undecided and must not be invented as canon.
- Long-term endings include permanent settlement, lunar infiltration, lunar missile routes, overwork death, and mental-collapse outcomes.
- Hidden endings require knowledge and preparation, not only high stats.

## Resource layers

Physical resources include food, water, oxygen, electricity, parts, and medicine in the full design. Human resources include population, morale, skills, trust, fatigue, injury, and survival. Leader resources include condition, stress, health, continuous awake/activity time, and judgment/self-awareness.

Prototype core resources are:

- electricity,
- water,
- oxygen,
- morale.

## Time and schedule design

- No fixed number of actions per day.
- Actions and movement consume time.
- The player makes a rough daily plan but can revise, cancel, or rearrange it.
- Current implementation discussions use a 30-minute internal resolution and 48 slots per day.
- Dates/times are represented using a two-dimensional day/slot structure, while comparisons use absolute slots.
- Fixed schedules start at fixed times.
- Morning fixed schedule includes a work report.
- A free action cannot be selected when a known schedule conflict would occur.
- Delegating a fixed schedule must be selected in advance.
- Encounter pools are divided by context, such as sleep or outdoor activity.

## Leader condition and information reliability

- Fatigue primarily causes omission, blur, memory failure, number misreading, and concentration loss.
- Stress primarily causes threat exaggeration, hostile interpretation, impulsive choices, suspicion, and self-denial.
- Health limits movement and field action.
- Long continuous activity increases sudden mistakes, unconsciousness, and time-perception errors.
- Severe state display progression includes uncertainty (`?`) and later false certainty such as `책임자 상태: 정상. 모든 것이 올바르다.`
- The final false-certainty stage should not reassuringly add “정말로?”; the contradiction should come from visual/perceptual breakdown.

## Fairness rules

- Serious distortion must have warning signs.
- The player must have responses such as checking, testing, asking, delegating, isolating systems, and resting.
- Important bad outcomes should arise mainly from accumulated state and choices, not arbitrary random deception.
- The design must distinguish subjective distortion from actual AI intrusion.

## AI information attack boundaries

Subjective distortion and AI manipulation are separate systems.

AI may manipulate networked/electronic external information it can plausibly access:

- electronic reports,
- sensor records,
- communications,
- alarms,
- cameras,
- access logs,
- electronic orders,
- digital audio,
- networked medical monitors.

AI cannot directly manipulate:

- inner monologue,
- subjective leader-status display,
- paper notes,
- isolated analog gauges,
- face-to-face speech.

A clear intrusion path is required. Candidate routes include infected expedition equipment, dormant maintenance networks, a human collaborator, a refugee/insider, external communications vulnerabilities, or small maintenance/spy machines. Humanoid android infiltration is not the default setting.

Escalation should be external information warfare → limited network breach → physical/internal penetration only after a clear event or failure. Detection and recovery must be possible through analog comparison, independent sensors, isolation, access validation, hashes/signatures, physical search, cleanup, and restoration.

## Information-gated choices

- No time-loop or protagonist multi-run memory premise.
- A player who knows an answer from a guide still cannot choose it unless the protagonist has the in-world basis.
- Knowledge layers: clue → deduction → plan.
- Ordinary locked choices may show requirements; major hidden-ending choices may remain fully hidden.
- First-run hidden endings must remain logically reachable.

## Prototype scope

- About 15 minutes of real play.
- Three in-game days.
- Starts after the absolute beginning, in an early but already operating base.
- No narrative ending; stop at the end of the produced interval and optionally show an operation record.
- Actions have time costs affected by skill, condition, injury, equipment, and circumstances.
- Micro-actions should usually be automated and surfaced only when meaningful.

### Working prototype story

Working title: **흐린 보고서**.

- Starts around D+9 with the leader underslept.
- Water purification output is falling.
- Digital and paper/analog records conflict.
- 김동현 recovers an unidentified electronic device from an external relay.
- The cause is not immediately confirmed.

This story package is a content draft and is not yet fully compatible with the canonical runtime schema.

## Fixed prototype companions

1. 홍예슬 — 부책임자
2. 양동하 — 시설 기술자
3. 방준연 — 의료 담당자
4. 김동현 — 탐사·통신 담당자

## UI direction

- PC target and current prototype target: 1920×1080.
- The main screen should feel like narrative documents and a command desk, not a smartphone dashboard.
- Show raw evidence instead of announcing conclusions such as “물이 부족하다.”
- Useful evidence includes automatic logs, handwritten notes, conflicting reports, and inquiries.
- Do not expose internal exact food kg or leader percentages on the main HUD.
- Display what the protagonist can reasonably know; measurement, expertise, tools, and condition affect precision.
- UI should show major qualitative reasons, not full formulas.
- Current accepted v0.2 direction uses a left evidence area, central side-by-side reports, choices, schedule, and work traces.
- The existing v0.2 reference PNG is a layout reference, not proof of a Godot runtime render.

## Skill and reading design

- Skills/abilities rise discretely when level-specific conditions are satisfied, not by a continuously filling XP percentage.
- Books do not directly grant levels.
- Books reduce or replace requirements for their level band.
- Later volumes normally require earlier volumes, except a character already at the entry skill level may begin with the relevant later volume.
- Reading must save later time, repetitions, risk, or information cost.
- UI should compare requirements before and after reading.
- A segmented bar is confirmed; maximum 8 is only a working proposal.

## Item information design

Later approved design outside the current SSoT text uses three knowledge stages:

- 미확인,
- 식별됨,
- 전문가.

Remove separate “사용 경험 있음” and “관련 경험” display stages. Once an item is identified, show ordinary practical use information immediately. Expertise and experience are causes of knowledge unlock, not additional display stages. Analysis equipment can be a condition for expert knowledge.

Current perception stages used in the item-authoring discussion:

- 정상,
- 피곤,
- 심한 피로,
- 판단 불안정.

In unstable states, item-specific collapse text is rolled before common collapse text, and the result must be fixed to prevent reroll abuse.

## Canonical data-core architecture

Use these runtime conventions:

```json
{
  "schema_version": 1,
  "data_type": "item",
  "entries": []
}
```

- IDs use `ABCD_001`.
- `GameJsonLoader` loads.
- `GameDataRepository` registers and serves data.
- `GameDataValidator` validates.
- `GameDataBootstrap` initializes.
- Exact mechanics and player-facing display information are separate.

Do not treat the existing item editor v0.3 output as compatible. Its envelope and lowercase IDs are incompatible and require migration.

## Current artifact state

### Godot data core

The core has 20 JSON data files and foundational loader/repository/validator/bootstrap scripts. Static auditing found valid JSON syntax, no duplicate IDs, required fields present, and mechanically valid ID shapes. Blocking reference failures and validator gaps remain; see the audit report.

### UI prototype v0.2

- Static project validation passed.
- Actual Godot runtime compilation/rendering was not performed because the environment lacked a Godot binary.
- Never report it as runtime-tested.

### Skill collection

- `Project_nostalgia_Skills_v0.6.zip`
- SHA-256: `3f5978d68b1c14b36405321a20f60724e31e5bbf4ae85a7d3979c763a99378c7`
- `.git` content was removed from Understand-Anything.
- The upstream skill set has not yet been comprehensively rewritten for Project Nostalgia.

## Ownership split from earlier planning

- User owns story, characters, and miscellaneous final decisions.
- Teammate work primarily covers UI, encounters, and items.
- Regardless of ownership, all outputs must follow the SSoT.
