#!/usr/bin/env python3
from __future__ import annotations

import sys
from pathlib import Path

try:
    import yaml  # type: ignore
except Exception:
    print("Missing dependency: PyYAML. Install with: python3 -m pip install pyyaml", file=sys.stderr)
    sys.exit(2)


def read_yaml(path: Path) -> dict:
    with path.open("r", encoding="utf-8") as f:
        return yaml.safe_load(f) or {}


def fmt_tools(meta: dict) -> str:
    tools = meta.get("tools", []) or []
    lines = []
    for item in tools:
        # nf-core tools structure: - "toolname": { ... }
        if not isinstance(item, dict):
            continue
        for tool_name, info in item.items():
            info = info or {}
            lines.append(f"- **{tool_name}**")
            if isinstance(info, dict):
                for k in ["description", "homepage", "documentation", "tool_dev_url", "licence", "identifier"]:
                    v = info.get(k, "")
                    if v in ("", None, [], {}):
                        continue
                    if isinstance(v, list):
                        v = ", ".join(str(x) for x in v)
                    lines.append(f"  - {k}: {v}")
    return "\n".join(lines) if lines else "_No tool metadata found in meta.yml._"


def fmt_io(section: dict) -> str:
    # section can be list (inputs) or dict (outputs) depending on nf-core style
    if section is None:
        return "_Not specified._"

    def describe_entry(name: str, entry: dict) -> str:
        t = entry.get("type", "")
        d = (entry.get("description") or "").strip()
        p = entry.get("pattern", "")
        out = [f"- **{name}**"]
        if t:
            out.append(f"  - type: {t}")
        if p:
            out.append(f"  - pattern: {p}")
        if d:
            out.append(f"  - description: {d}")
        return "\n".join(out)

    lines = []
    if isinstance(section, list):
        # inputs: list of dicts like [{meta: {...}}, {reads: {...}}]
        for item in section:
            if not isinstance(item, dict):
                continue
            for name, entry in item.items():
                if isinstance(entry, dict):
                    lines.append(describe_entry(name, entry))
                else:
                    lines.append(f"- **{name}**")
    elif isinstance(section, dict):
        # outputs: dict keyed by emit name
        for key, value in section.items():
            # value often is list structure; keep it simple and show top-level key
            lines.append(f"- **{key}**")
            if isinstance(value, list):
                # attempt to summarise nested file patterns
                for part in value:
                    if isinstance(part, dict):
                        for subk, subv in part.items():
                            if isinstance(subv, dict):
                                d = (subv.get("description") or "").strip()
                                p = subv.get("pattern", "")
                                lines.append(f"  - {subk}")
                                if p:
                                    lines.append(f"    - pattern: {p}")
                                if d:
                                    lines.append(f"    - description: {d}")
            elif isinstance(value, dict):
                d = (value.get("description") or "").strip()
                p = value.get("pattern", "")
                if p:
                    lines.append(f"  - pattern: {p}")
                if d:
                    lines.append(f"  - description: {d}")
    else:
        return "_Not specified._"

    return "\n".join(lines) if lines else "_Not specified._"


def main() -> int:
    if len(sys.argv) < 2:
        print("Usage: scripts/render_module_readme.py <module_dir>", file=sys.stderr)
        print("Example: scripts/render_module_readme.py modules/splice/fq/0.12.0/lint", file=sys.stderr)
        return 2

    module_dir = Path(sys.argv[1]).resolve()
    meta_yml = module_dir / "meta.yml"
    main_nf = module_dir / "main.nf"
    readme = module_dir / "README.md"

    if not meta_yml.exists():
        print(f"ERROR: meta.yml not found: {meta_yml}", file=sys.stderr)
        return 2
    if not main_nf.exists():
        print(f"ERROR: main.nf not found: {main_nf}", file=sys.stderr)
        return 2

    meta = read_yaml(meta_yml)

    name = meta.get("name", module_dir.name)
    desc = (meta.get("description") or "").strip() or "_No description provided._"
    keywords = meta.get("keywords", []) or []
    authors = meta.get("authors", []) or []
    maintainers = meta.get("maintainers", []) or []
    origin = meta.get("origin", {}) or {}

    kw_line = ", ".join(str(k) for k in keywords) if keywords else "_None_"
    authors_line = ", ".join(str(a) for a in authors) if authors else "_Not specified_"
    maintainers_line = ", ".join(str(m) for m in maintainers) if maintainers else "_Not specified_"

    origin_block = ""
    if isinstance(origin, dict) and origin:
        parts = []
        for k in ["repository", "module_source"]:
            if origin.get(k):
                parts.append(f"- {k}: {origin.get(k)}")
        if origin.get("original_authors"):
            oa = origin.get("original_authors")
            if isinstance(oa, list):
                oa = ", ".join(str(x) for x in oa)
            parts.append(f"- original_authors: {oa}")
        notes = (origin.get("notes") or "").strip()
        origin_block = "\n".join(parts)
        if notes:
            origin_block += ("\n\n" if origin_block else "") + notes
    else:
        origin_block = "_Not specified._"

    readme_text = f"""# {name}

## Description
{desc}

## Keywords
{kw_line}

## Tool
{fmt_tools(meta)}

## Inputs
{fmt_io(meta.get("input"))}

## Outputs
{fmt_io(meta.get("output"))}

## Usage
This directory contains a Nextflow module.

- Module script: `main.nf`
- Metadata: `meta.yml`
- Tests: `tests/`

Import and call the module from a Nextflow workflow using your usual module include pattern.

## Task extensions
This module may support per invocation options via `task.ext.*`.

If you extend this module, document new `task.ext.*` keys here in the README.

## Provenance
{origin_block}

## Contacts
- authors: {authors_line}
- maintainers: {maintainers_line}

---

This README is generated from `meta.yml`. If you need to update it, edit `meta.yml` and rerun the generator.
"""

    readme.write_text(readme_text, encoding="utf-8")
    print(f"Wrote: {readme}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
