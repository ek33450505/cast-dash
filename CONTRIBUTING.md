# Contributing to cast-dash

Thank you for your interest in cast-dash! This guide covers how to modify the TUI, add panels, and contribute tests.

## Prerequisites

- **Python 3.9+** — required for the Textual TUI
- **textual** — TUI framework (auto-installed by `cast-dash setup`)
- **bats-core** — test runner for the BATS test suite
- **Bash 4+** — CLI wrapper targets Bash 4 (macOS ships Bash 3; install via `brew install bash`)

## Quick Start

```bash
git clone https://github.com/ek33450505/cast-dash
cd cast-dash
bash install.sh
cast-dash setup
bats tests/
```

## TUI Architecture

`scripts/cast-dash.py` is a Textual app with a CSS grid layout containing 4 panels:

```
+-------------------+-------------------+
|  Active Agents    |  Today's Stats    |
|  (DataTable)      |  (Static + Spark) |
+-------------------+-------------------+
|  Recent Runs      |  System Health    |
|  (DataTable)      |  (Static)         |
+-------------------+-------------------+
```

Key components:

| Component | Description |
|---|---|
| `CastDashApp` | Main Textual `App` subclass — owns the refresh timer and layout |
| `ActiveAgentsPanel` | DataTable widget showing running agents with model, status, elapsed |
| `TodayStatsPanel` | Static widget with run count, cost, tokens, errors, hourly sparkline |
| `RecentRunsPanel` | DataTable of last 20 agent runs, color-coded by status |
| `SystemHealthPanel` | Static widget counting agents, hooks, skills, plans, DB rows |

The app refreshes every 5 seconds by querying `cast.db` via `cast_db.py`.

## Data Layer

`scripts/cast_db.py` provides the DB abstraction:

- Opens `~/.claude/cast.db` in **read-only** mode with WAL
- Exports `db_query(sql, params)` for SELECT queries
- Used by all 4 panels to fetch live data

The `config/model-pricing.json` file maps model names to per-token costs for the cost calculations in Today's Stats.

## Adding a New Panel

1. Create a new widget class in `cast-dash.py` (subclass `textual.widgets.Static` or `DataTable`)
2. Add a data query method that calls `db_query()` from `cast_db.py`
3. Add the widget to the CSS grid in `CastDashApp.compose()`
4. Register it in the refresh timer callback so it updates every 5 seconds
5. Update the panel descriptions in `README.md`

## Modifying Queries

All SQL queries use the `cast.db` schema:

| Table | Key columns |
|---|---|
| `sessions` | id, start_time, end_time, status |
| `agent_runs` | id, agent_name, model, status, cost, duration, started_at |
| `routing_events` | id, event_type, timestamp, data |
| `hook_health` | id, hook_id, last_run, status |

Use `db_query()` for all reads. Never write to cast.db from the dashboard.

## Testing Guide

Tests live in `tests/cast-dash.bats`. Run them with:

```bash
bats tests/
```

Test coverage includes:
- CLI subcommands (`--version`, `--help`)
- Script existence for `cast-dash.py` and `cast_db.py`
- Python syntax validation for all `.py` files
- JSON validity of `config/model-pricing.json`
- Bash syntax validation (`bash -n`) for CLI and installer

For TUI testing, launch `cast-dash` manually and verify panel rendering and keyboard shortcuts.

## PR Checklist

- [ ] `bats tests/` passes locally
- [ ] Python syntax valid: `python3 -c "import ast; ast.parse(open('scripts/cast-dash.py').read())"`
- [ ] New panel: widget class added, registered in grid and refresh timer
- [ ] New panel: described in `README.md` Panels section
- [ ] `CHANGELOG.md` updated for any user-visible changes
- [ ] No hardcoded absolute paths — use `$HOME`, `CAST_DB_PATH`, or env vars
