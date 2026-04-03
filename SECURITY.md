# Security Policy

## Supported Versions

| Version | Support Status |
|---|---|
| 0.1.x | Full support — security fixes backported |
| < 0.1 | No longer supported |

## Reporting a Vulnerability

**Do NOT open a public GitHub issue for security vulnerabilities.**

Report privately using [GitHub Security Advisories](https://github.com/ek33450505/cast-dash/security/advisories/new).

### What to Include

- **cast-dash version** — output of `cast-dash --version`
- **Operating system** — macOS / Linux, version
- **Which file** — e.g., `install.sh`, `bin/cast-dash`, `scripts/cast-dash.py`
- **Steps to reproduce** — minimal, clear reproduction steps
- **Impact** — what an attacker could do

### Response Timeline

| Severity | Acknowledgment | Fix Target |
|---|---|---|
| Critical | 48 hours | 14 days |
| High | 48 hours | 30 days |
| Medium / Low | 5 business days | Next release |

## Security Design Notes

cast-dash is a read-only terminal UI that displays data from cast.db. Key design decisions:

- **Read-only database access** — `cast_db.py` opens SQLite in read-only mode; the TUI never writes to cast.db
- **No remote network calls** — the dashboard operates entirely locally
- **No credential storage** — cast-dash never reads or writes API keys, tokens, or secrets
- **WAL-safe reads** — uses SQLite WAL mode for safe concurrent reading alongside other CAST writers
- **Python venv isolation** — textual dependency is installed in `~/.claude/venv/`, not system-wide
- **install.sh is idempotent** — safe to re-run; copies files and creates venv if needed

## Out of Scope

- Vulnerabilities in the Claude API or Anthropic services — report to [Anthropic](https://www.anthropic.com/security)
- Vulnerabilities in third-party tools (Python, textual, SQLite, Homebrew)
- Issues requiring physical access to the machine
- Data displayed in the TUI — cast-dash shows what cast.db contains, which is controlled by hooks and agents
