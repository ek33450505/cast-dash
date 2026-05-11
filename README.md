# cast-dash

[![CI](https://github.com/ek33450505/cast-dash/actions/workflows/ci.yml/badge.svg)](https://github.com/ek33450505/cast-dash/actions/workflows/ci.yml)
![version](https://img.shields.io/badge/version-0.1.0-blue)
![license](https://img.shields.io/badge/license-MIT-green)
![platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey)
![python](https://img.shields.io/badge/python-3.9%2B-yellow)

htop for Claude Code. A live terminal dashboard that shows active agents, costs, recent runs, and system health — all from `cast.db`. No browser, no web server, no configuration. Launch it and see what Claude Code is doing right now.

## Screenshot

```
+-- CAST Dashboard -----------------------------------------------+
|  Active Agents (5s poll)       |  Today's Stats                  |
|  ----------------------------  |  ----------------------------   |
|  [DataTable: agent/status/     |  Runs: 12  Cost: $0.43          |
|   model/elapsed]               |  Tokens: 180K  Errors: 1        |
|                                |  [Sparkline: hourly cost]       |
|--------------------------------|---------------------------------|
|  Recent Runs (last 20)         |  System Health                  |
|  ----------------------------  |  ----------------------------   |
|  [DataTable: agent/status/     |  Agents: 30  Hooks: 14          |
|   cost/duration/ago]           |  Skills: 8   Plans: 54          |
|                                |  DB: 18 runs, 5 sessions        |
+--------------------------------+---------------------------------+
  q:quit  r:refresh  Tab:focus             cast.db: OK  5s refresh
```

## Install

### Homebrew

```bash
brew tap ek33450505/cast-dash
brew install cast-dash
cast-dash setup
```

### Manual

```bash
git clone https://github.com/ek33450505/cast-dash.git
cd cast-dash
bash install.sh
```

## Usage

```bash
# Launch with default cast.db path (~/.claude/cast.db)
cast-dash

# Custom database path
cast-dash --db /path/to/cast.db

# Set up Python venv and install textual
cast-dash setup

# Print version
cast-dash --version
```

## Panels

### Active Agents

DataTable showing currently running agents with model, status, and elapsed time. Polls cast.db every 5 seconds. Agents appear when `SubagentStart` fires and clear when `SubagentStop` completes.

### Today's Stats

Aggregate numbers for the current day: total runs, cumulative cost (calculated from token counts and `model-pricing.json`), total tokens processed, and error count. Includes an hourly cost sparkline showing spend distribution across the day.

### Recent Runs

Last 20 agent runs with agent name, status, cost, duration, and time ago. Color-coded by status: green for DONE, yellow for DONE_WITH_CONCERNS, red for BLOCKED, blue (bold) for currently running.

### System Health

File counts for key CAST directories: agents (`~/.claude/agents/`), hooks (`~/.claude/scripts/`), skills (`~/.claude/skills/`), plans (`~/.claude/plans/`). Also shows cast.db row counts for runs and sessions.

## Keyboard Shortcuts

| Key | Action |
|---|---|
| `q` | Quit |
| `r` | Force refresh (bypass 5s timer) |
| `Tab` | Cycle focus between panels |

## Status Colors

| Color | Status |
|---|---|
| Green | DONE |
| Yellow | DONE_WITH_CONCERNS |
| Red | BLOCKED |
| Blue (bold) | Running |

## Data Source

cast-dash reads `~/.claude/cast.db` (SQLite, read-only, WAL-safe). The database is populated by any CAST component that writes observability data — cast-hooks, cast-observe, or the full CAST framework. If cast.db does not exist or is empty, panels display placeholder data.

Override the database path with `--db`:

```bash
cast-dash --db ~/backups/cast.db
```

## Requirements

- Python 3.9+
- [textual](https://github.com/Textualize/textual) (auto-installed by `cast-dash setup` or `install.sh`)
- `cast.db` — from cast-hooks, cast-observe, or the full CAST install

## Part of CAST

cast-dash visualizes data from [CAST](https://github.com/ek33450505/claude-agent-team)'s cast.db observability layer. If you don't run CAST, the dashboard won't have data to display. If you do run CAST, you can install this TUI dashboard standalone via Homebrew and monitor all your Claude Code activity from the terminal.

## CAST Ecosystem

Each CAST component ships as a standalone Homebrew package. Mix and match to build your own stack.

| Package | What It Does | Install |
|---------|-------------|---------|
| [cast-agents](https://github.com/ek33450505/cast-agents) | 30 specialist Claude Code agents | `brew tap ek33450505/cast-agents && brew install cast-agents` |
| [cast-hooks](https://github.com/ek33450505/cast-hooks) | 13 hook scripts — observability, safety gates, dispatch | `brew tap ek33450505/cast-hooks && brew install cast-hooks` |
| [cast-observe](https://github.com/ek33450505/cast-observe) | Session cost + token spend tracking | `brew tap ek33450505/cast-observe && brew install cast-observe` |
| [cast-security](https://github.com/ek33450505/cast-security) | Policy gates, PII redaction, audit trail | `brew tap ek33450505/cast-security && brew install cast-security` |
| **cast-dash** | Terminal UI dashboard (Python + Textual) | `brew tap ek33450505/cast-dash && brew install cast-dash` |
| [cast-memory](https://github.com/ek33450505/cast-memory) | Persistent memory for Claude Code agents | `brew tap ek33450505/cast-memory && brew install cast-memory` |
| [cast-parallel](https://github.com/ek33450505/cast-parallel) | Parallel plan execution across dual worktrees | `brew tap ek33450505/cast-parallel && brew install cast-parallel` |

## License

MIT — see [LICENSE](LICENSE)
