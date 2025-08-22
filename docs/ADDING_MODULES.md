# Adding a new module

1. **Create from template**
   ```bash
   scripts/new_module.sh <namespace> <module_name>
   ```
   Example: `scripts/new_module.sh cruksi trim_galore`

2. **Implement** your process in `main.nf`:
   - Accept/emit `meta` maps.
   - Add inputs/outputs and script block.
   - Reference the local `environment.yml` for Conda usage (`conda "${moduleDir}/environment.yml"`).

3. **Pin packages** in `environment.yml` (bioconda/conda-forge). Keep minimal.

4. **Write tests** under `tests/` using `nf-test`.

5. **Document** what the module does in `meta.yml`.

6. **Commit & PR** with an entry in `CHANGELOG.md`.

## Tips
- Keep parameters out of modules; pass constants via inputs or environment where possible.
- Validate file extensions early.
- Avoid hard-coded temp paths; rely on Nextflow work dir.
