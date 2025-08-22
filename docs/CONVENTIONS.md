# SPLICE module conventions

## File layout
```
modules/<namespace>/<module_name>/
  ├── main.nf            # Nextflow process implementation
  ├── meta.yml           # Metadata (name, description, maintainer, version)
  ├── environment.yml    # Minimal, pinned Conda env (for outside TRE)
  └── tests/             # nf-test specs + tiny fixtures
```

## Interface
- Accept a `meta` map when inputs relate to a sample or lane. Otherwise a neutral `meta` is fine.
- Emit `meta` along with outputs to maintain provenance.
- Keep resource requests modest and overridable by pipeline `conf/`.

## Packaging
- Prefer **Apptainer** in pipelines; modules carry **Conda** envs for convenience and CI.
- Pin versions and avoid wildcard (`*`).

## I/O rules
- Do not fetch from the internet.
- Do not write outside the working directory.
- Avoid `publishDir` inside modules; publishing is a pipeline concern.

## Testing
- Use `nf-test`.
- Keep fixtures tiny; generate synthetic data where possible.
- Make assertions on file existence and basic content.
