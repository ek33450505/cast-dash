# Changelog

All notable changes to cast-dash are documented here.

## [0.2.0] — 2026-05-11 — Polish + Ecosystem Cross-Linking

### Added
- Ecosystem cross-link table in README pointing to all CAST Homebrew packages
- CI status badge (GitHub Actions workflow)
- GitHub community files: issue templates, PR template, contributing guide, code of conduct
- Agent count updated from 17 to 30 in README

### Changed
- README polish: ecosystem section with full package table, cross-links to cast-agents, cast-hooks, cast-observe, cast-security, cast-memory, cast-parallel
- Version badge updated from 0.1.0 to 0.2.0

### Notes
- This entry retroactively documents what shipped in v0.2.0. Future releases will have entries committed at release time.

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
