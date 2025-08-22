#!/usr/bin/env bash
set -Eeuo pipefail
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <namespace> <module_name>" >&2; exit 1
fi
ns="$1"; name="$2"
root="modules/${ns}/${name}"
mkdir -p "$root/tests"
cat >"$root/main.nf" <<'NF'
// MODULE: <replace>/<replace>
// Accept a meta map and input paths; emit meta and outputs.
// Replace inputs/outputs/script for your tool.

process TEMPLATE_PROCESS {
  tag { "${meta.id ?: 'no-id'}" }
  cpus 1
  memory '1 GB'
  time '2h'
  conda "${moduleDir}/environment.yml"

  input:
    tuple val(meta), path(input)

  output:
    tuple val(meta), path("*.out"), emit: out

  script:
  """
  # Replace with your tool invocation
  cp ${input} result.out
  """
}
NF
cat >"$root/meta.yml" <<META
name: ${name}
namespace: ${ns}
description: "TODO: describe ${name}"
keywords: [template]
maintainer: "@your-handle"
version: "0.1.0"
META
cat >"$root/environment.yml" <<'YML'
channels: [bioconda, conda-forge]
dependencies:
  - python=3.11
YML
cat >"$root/tests/README.md" <<'T'
Add nf-test specs here: main.nf.test and snapshots.
Keep fixtures tiny and generate synthetic inputs where possible.
T
echo "Created $root"
