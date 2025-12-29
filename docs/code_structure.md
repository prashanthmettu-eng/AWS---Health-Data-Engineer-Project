# Repository Code Structure

This project follows a clean separation between deployable pipeline code and developer helper tools.

## Folder Overview

### `src/`
Contains **all deployable application code**, including:
- `data_generator/` — generates synthetic healthcare data (Bronze layer input)
- `glue_jobs/` — ETL code for AWS Glue (Bronze → Silver, Silver → Gold)
- `lambda/` — AWS Lambda handlers (real ones later, stubs now)
- `stepfunctions/` — State Machine definitions (ASL JSON)
- `scripts/` — Pipeline-support scripts (local orchestrator, internal tools)

Everything in `src/` is considered part of the application and would be versioned/deployed.

### `scripts/` (root level)
Contains **developer convenience tools**:
- data inspection utilities (e.g., reading parquet)
- environment helpers
- one-off debugging utilities

These scripts are *not* meant for deployment and are for local development only.

## Summary

- Use `src/` for pipeline logic.
- Use root `scripts/` for developer-only utilities.

This structure keeps the project professional, clean, and easy for others to navigate.
