#!/usr/bin/env python3
"""Static structural validator for Project Nostalgia project skills.

This tool validates document structure and scenario specifications only. It does
not simulate skill routing, Codex/Claude triggers, or Godot runtime behavior.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any

REQUIRED_SECTIONS = {
    "목적",
    "호출 조건",
    "호출하지 말아야 하는 조건",
    "필수 입력",
    "수행 순서",
    "수정 가능한 범위",
    "수정 금지 범위",
    "중단 조건",
    "검증 절차",
    "결과 보고 형식",
    "다음 스킬로 넘기는 조건",
}
EVAL_FIELDS_BATCH_1 = {
    "id",
    "category",
    "title",
    "user_request",
    "project_context",
    "expected_primary_skill",
    "expected_secondary_skills",
    "must_not_trigger",
    "expected_first_action",
    "expected_allowed_actions",
    "expected_forbidden_actions",
    "expected_handoff",
    "expected_completion_state",
    "expected_report_items",
    "rationale",
    "static_eval_result",
    "runtime_eval_status",
}
EVAL_FIELDS_BATCH_2 = EVAL_FIELDS_BATCH_1 - {"expected_report_items"} | {"result_skill"}
VALID_STATIC_RESULTS = {"PASS", "FAIL", "AMBIGUOUS"}
VALID_RUNTIME_STATUS = {"NOT_RUNTIME_TESTED"}
MARKDOWN_LINK_RE = re.compile(r"(?<!!)\[[^\]]+\]\(([^)]+)\)")
FRONTMATTER_RE = re.compile(r"\A---\s*\n(.*?)\n---\s*\n", re.DOTALL)
HEADING_RE = re.compile(r"^##\s+(.+?)\s*$", re.MULTILINE)
SKILL_TOKEN_RE = re.compile(r"`(pn-[a-z0-9-]+)`")


def parse_frontmatter(text: str) -> dict[str, str] | None:
    match = FRONTMATTER_RE.match(text)
    if not match:
        return None
    values: dict[str, str] = {}
    for line in match.group(1).splitlines():
        if ":" not in line:
            continue
        key, value = line.split(":", 1)
        values[key.strip()] = value.strip().strip("\"'")
    return values


def manifest_skills(text: str) -> set[str]:
    result: set[str] = set()
    for line in text.splitlines():
        if not line.startswith("|") or "`pn-" not in line:
            continue
        match = SKILL_TOKEN_RE.search(line)
        if match:
            result.add(match.group(1))
    return result


def readme_skills(text: str) -> set[str]:
    return set(SKILL_TOKEN_RE.findall(text))


def resolve_markdown_target(source: Path, raw_target: str, repo_root: Path) -> Path | None:
    target = raw_target.split("#", 1)[0].strip()
    if not target or re.match(r"^[a-z][a-z0-9+.-]*://", target, re.IGNORECASE):
        return None
    if target.startswith("/"):
        return repo_root / target.lstrip("/")
    return source.parent / target


def validate_eval(path: Path, skill_names: set[str], errors: list[str]) -> None:
    try:
        payload = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, UnicodeError, json.JSONDecodeError) as exc:
        errors.append(f"{path}: JSON parse failed: {exc}")
        return

    cases = payload.get("cases") if isinstance(payload, dict) else payload
    if not isinstance(cases, list):
        errors.append(f"{path}: top level must be an array or an object with a cases array")
        return

    seen: set[str] = set()
    for index, case in enumerate(cases):
        label = f"{path}: case[{index}]"
        if not isinstance(case, dict):
            errors.append(f"{label} must be an object")
            continue
        required = EVAL_FIELDS_BATCH_2 if "result_skill" in case else EVAL_FIELDS_BATCH_1
        missing = sorted(required - case.keys())
        if missing:
            errors.append(f"{label} missing fields: {', '.join(missing)}")
        case_id = case.get("id")
        if not isinstance(case_id, str) or not case_id:
            errors.append(f"{label} has an invalid id")
        elif case_id in seen:
            errors.append(f"{label} duplicates id {case_id!r}")
        else:
            seen.add(case_id)

        primary = case.get("expected_primary_skill")
        if not isinstance(primary, str) or primary not in skill_names:
            errors.append(f"{label} has unknown expected_primary_skill {primary!r}")
        for field in ("expected_secondary_skills", "must_not_trigger"):
            values = case.get(field)
            if not isinstance(values, list) or any(not isinstance(value, str) for value in values):
                errors.append(f"{label}.{field} must be an array of skill names")
                continue
            unknown = sorted(set(values) - skill_names)
            if unknown:
                errors.append(f"{label}.{field} has unknown skills: {', '.join(unknown)}")
        if isinstance(primary, str) and primary in (case.get("must_not_trigger") or []):
            errors.append(f"{label} puts primary skill in must_not_trigger")
        if case.get("static_eval_result") not in VALID_STATIC_RESULTS:
            errors.append(f"{label} has invalid static_eval_result")
        if case.get("runtime_eval_status") not in VALID_RUNTIME_STATUS:
            errors.append(f"{label} must use runtime_eval_status=NOT_RUNTIME_TESTED")
        if "result_skill" in case and case.get("result_skill") not in skill_names:
            errors.append(f"{label} has unknown result_skill {case.get('result_skill')!r}")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo-root", type=Path, default=Path(__file__).resolve().parents[2])
    args = parser.parse_args()
    repo_root = args.repo_root.resolve()
    skills_root = repo_root / "project_skills"
    errors: list[str] = []
    warnings: list[str] = []

    manifest_path = skills_root / "MANIFEST.md"
    readme_path = skills_root / "README.md"
    if not manifest_path.is_file():
        errors.append("project_skills/MANIFEST.md is missing")
    if not readme_path.is_file():
        errors.append("project_skills/README.md is missing")
    if errors:
        for error in errors:
            print(f"ERROR: {error}")
        return 1

    manifest_names = manifest_skills(manifest_path.read_text(encoding="utf-8"))
    actual_dirs = {
        path.name
        for path in skills_root.iterdir()
        if path.is_dir() and path.name.startswith("pn-")
    }
    readme_names = readme_skills(readme_path.read_text(encoding="utf-8")) & actual_dirs
    if actual_dirs != manifest_names:
        errors.append(
            "MANIFEST skill set differs from directories: "
            f"manifest={sorted(manifest_names)}, directories={sorted(actual_dirs)}"
        )
    if actual_dirs != readme_names:
        errors.append(
            "README skill set differs from directories: "
            f"README={sorted(readme_names)}, directories={sorted(actual_dirs)}"
        )

    markdown_files = list(skills_root.rglob("*.md")) + list((repo_root / "docs").rglob("*.md"))
    for skill_dir in sorted(actual_dirs):
        directory = skills_root / skill_dir
        skill_path = directory / "SKILL.md"
        source_path = directory / "SOURCE_AND_LICENSE.md"
        if not skill_path.is_file():
            errors.append(f"project_skills/{skill_dir}/SKILL.md is missing")
            continue
        if not source_path.is_file():
            errors.append(f"project_skills/{skill_dir}/SOURCE_AND_LICENSE.md is missing")
        text = skill_path.read_text(encoding="utf-8")
        frontmatter = parse_frontmatter(text)
        if frontmatter is None:
            errors.append(f"{skill_path}: frontmatter is missing")
        else:
            if frontmatter.get("name") != skill_dir:
                errors.append(f"{skill_path}: name must equal directory name {skill_dir!r}")
            if not frontmatter.get("description"):
                errors.append(f"{skill_path}: description is missing")
        sections = set(HEADING_RE.findall(text))
        missing_sections = sorted(REQUIRED_SECTIONS - sections)
        if missing_sections:
            errors.append(f"{skill_path}: missing sections: {', '.join(missing_sections)}")
        if source_path.is_file():
            source_text = source_path.read_text(encoding="utf-8")
            if "- 직접 원본 스킬:" not in source_text or "- 원본 경로:" not in source_text:
                errors.append(f"{source_path}: upstream record is incomplete")
            if "- 라이선스:" not in source_text or "- 라이선스 사본:" not in source_text:
                errors.append(f"{source_path}: license record is incomplete")

    for markdown_path in markdown_files:
        try:
            text = markdown_path.read_text(encoding="utf-8")
        except (OSError, UnicodeError) as exc:
            errors.append(f"{markdown_path}: cannot read Markdown: {exc}")
            continue
        for raw_target in MARKDOWN_LINK_RE.findall(text):
            target = resolve_markdown_target(markdown_path, raw_target, repo_root)
            if target is not None and not target.exists():
                errors.append(f"{markdown_path}: broken relative link {raw_target!r}")

    for eval_path in sorted((skills_root / "evals").rglob("eval_cases.json")) if (skills_root / "evals").exists() else []:
        validate_eval(eval_path, actual_dirs, errors)

    source_root = repo_root / "Project_Nostalgia_Codex_Handoff_v0.1" / "source_skills"
    if not source_root.exists():
        warnings.append("source skill bundle is absent; upstream paths and hashes were not recomputed")

    print(
        "Validated "
        f"{len(actual_dirs)} skill directories, {len(markdown_files)} Markdown files, "
        f"and {len(list((skills_root / 'evals').rglob('eval_cases.json'))) if (skills_root / 'evals').exists() else 0} eval files."
    )
    for warning in warnings:
        print(f"WARNING: {warning}")
    for error in errors:
        print(f"ERROR: {error}")
    if errors:
        print(f"FAILED with {len(errors)} error(s).")
        return 1
    print("PASS: static project-skill structure is valid. Runtime trigger behavior was not tested.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
