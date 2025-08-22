# Contributing

- Follow the structure in `modules/cruksi/_template` when adding a new module.
- Keep `environment.yml` minimal and pinned.
- Emit helpful `exit 1` messages on invalid input (validate extensions, etc.).
- Add `nf-test` specs under `modules/<ns>/<name>/tests/` with tiny fixtures.
- Update `CHANGELOG.md` and open a PR.
