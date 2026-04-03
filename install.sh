#!/bin/bash
# install.sh — cast-dash manual installer
# For users who clone the repo instead of using Homebrew.
#
# Usage: bash install.sh

set -uo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CD_VERSION="$(cat "${REPO_DIR}/VERSION" 2>/dev/null || echo "unknown")"

# ── Colors ────────────────────────────────────────────────────────────────────
if [ -t 1 ] && [ "${TERM:-}" != "dumb" ]; then
  C_BOLD='\033[1m'
  C_GREEN='\033[0;32m'
  C_YELLOW='\033[0;33m'
  C_RED='\033[0;31m'
  C_RESET='\033[0m'
else
  C_BOLD='' C_GREEN='' C_YELLOW='' C_RED='' C_RESET=''
fi

_ok()   { printf "${C_GREEN}  [ok]${C_RESET} %s\n" "$*"; }
_warn() { printf "${C_YELLOW}  [warn]${C_RESET} %s\n" "$*" >&2; }
_fail() { printf "${C_RED}  [fail]${C_RESET} %s\n" "$*" >&2; }
_step() { printf "\n${C_BOLD}%s${C_RESET}\n" "$*"; }

# ── Banner ────────────────────────────────────────────────────────────────────
printf "\n${C_BOLD}cast-dash v${CD_VERSION} installer${C_RESET}\n"
printf "══════════════════════════════════════\n\n"

# ── Step 1: Check prerequisites ──────────────────────────────────────────────
_step "Checking prerequisites..."
if ! command -v python3 &>/dev/null; then
  _fail "python3 not found — cast-dash requires Python 3.9+"
  exit 1
else
  _ok "python3 found"
fi

# ── Step 2: Create Python venv ───────────────────────────────────────────────
_step "Setting up Python environment..."
VENV_DIR="${HOME}/.claude/venv"

if [ ! -d "$VENV_DIR" ]; then
  printf "  Creating venv at ${VENV_DIR}...\n"
  if python3 -m venv "$VENV_DIR" 2>/dev/null; then
    _ok "venv created"
  else
    _fail "Could not create venv — check Python installation"
    exit 1
  fi
else
  _ok "venv already exists at ${VENV_DIR}"
fi

# Install textual
printf "  Installing textual...\n"
if "${VENV_DIR}/bin/pip3" install --quiet textual 2>/dev/null; then
  _ok "textual installed"
else
  _warn "Could not install textual — run 'cast-dash setup' after install"
fi

# ── Step 3: Create directories ───────────────────────────────────────────────
_step "Creating directories..."
SCRIPTS_DST="${HOME}/.claude/scripts"
CONFIG_DST="${HOME}/.claude/config"

for dir in "$SCRIPTS_DST" "$CONFIG_DST"; do
  if mkdir -p "$dir" 2>/dev/null; then
    _ok "${dir/#$HOME/~}"
  else
    _fail "Could not create ${dir} — check permissions"
    exit 1
  fi
done

# ── Step 4: Copy scripts ────────────────────────────────────────────────────
_step "Installing dashboard scripts..."
copied=0

for f in "${REPO_DIR}/scripts/"*.py; do
  [ -f "$f" ] || continue
  base="$(basename "$f")"
  dest="${SCRIPTS_DST}/${base}"
  if cp "$f" "$dest" 2>/dev/null; then
    chmod +x "$dest" 2>/dev/null || true
    _ok "${base} → ~/.claude/scripts/"
    copied=$((copied + 1))
  else
    _fail "Could not copy ${base}"
  fi
done

# ── Step 5: Copy config ─────────────────────────────────────────────────────
_step "Installing configuration..."
if [ -f "${REPO_DIR}/config/model-pricing.json" ]; then
  if cp "${REPO_DIR}/config/model-pricing.json" "${CONFIG_DST}/model-pricing.json" 2>/dev/null; then
    _ok "model-pricing.json → ~/.claude/config/"
  else
    _warn "Could not copy model-pricing.json"
  fi
else
  _warn "model-pricing.json not found in repo"
fi

# ── Step 6: Symlink CLI ─────────────────────────────────────────────────────
_step "Installing CLI..."
LOCAL_BIN="${HOME}/.local/bin"
CLI_SRC="${REPO_DIR}/bin/cast-dash"
CLI_DST="${LOCAL_BIN}/cast-dash"

if mkdir -p "$LOCAL_BIN" 2>/dev/null; then
  if ln -sf "$CLI_SRC" "$CLI_DST" 2>/dev/null; then
    _ok "cast-dash → ~/.local/bin/cast-dash"
    if ! echo "$PATH" | grep -q "${LOCAL_BIN}"; then
      printf "\n  ${C_YELLOW}Note:${C_RESET} Add ~/.local/bin to your PATH:\n"
      printf "    echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.zshrc\n"
    fi
  else
    _warn "Could not symlink to ~/.local/bin — run from repo: ${CLI_SRC}"
  fi
else
  _warn "Could not create ~/.local/bin — run from repo: ${CLI_SRC}"
fi

# ── Summary ──────────────────────────────────────────────────────────────────
printf "\n${C_BOLD}══════════════════════════════════════${C_RESET}\n"
printf "${C_GREEN}cast-dash v${CD_VERSION} installed.${C_RESET}\n\n"
printf "  Scripts: ${SCRIPTS_DST} (${copied} files)\n"
printf "  Config:  ${CONFIG_DST}/model-pricing.json\n"
printf "  CLI:     ${CLI_DST}\n"
printf "\n${C_BOLD}Next steps:${C_RESET}\n"
printf "  1. Run: cast-dash setup  (if textual not installed)\n"
printf "  2. Run: cast-dash\n\n"
