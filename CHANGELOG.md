# Changelog

All notable changes to cast-dash are documented here.

## [0.1.0] — 2026-04-03

### Added

- Textual-based 4-panel TUI dashboard for Claude Code observability
- Active Agents panel with live status, model, and elapsed time
- Today's Stats panel with run count, cost, token usage, error count, and hourly cost sparkline
- Recent Runs panel showing last 20 agent runs with status, cost, duration, and time ago
- System Health panel with agent, hook, skill, and plan file counts plus DB row counts
- 5-second auto-refresh with manual refresh (`r` key)
- Color-coded status indicators (green=DONE, yellow=CONCERNS, red=BLOCKED, blue=running)
- Keyboard navigation (`q`=quit, `r`=refresh, `Tab`=cycle focus)
- `cast-dash` CLI wrapper with `--db`, `setup`, `--version` subcommands
- Automatic Python venv setup with textual dependency
- Homebrew formula for macOS/Linux install (`brew tap ek33450505/cast-dash`)
- BATS test suite
