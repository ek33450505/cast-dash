#!/usr/bin/env bats
# cast-dash.bats — BATS test suite for cast-dash

REPO_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"

# ── CLI tests ────────────────────────────────────────────────────────────────

@test "cast-dash --version prints version matching VERSION file" {
  expected="cast-dash v$(cat "$REPO_DIR/VERSION" | tr -d '[:space:]')"
  run bash "$REPO_DIR/bin/cast-dash" --version
  [ "$status" -eq 0 ]
  [ "$output" = "$expected" ]
}

@test "cast-dash --help exits 0 and prints usage" {
  run bash "$REPO_DIR/bin/cast-dash" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Terminal UI dashboard"* ]]
}

# ── Script existence ─────────────────────────────────────────────────────────

@test "scripts/cast-dash.py exists" {
  [ -f "$REPO_DIR/scripts/cast-dash.py" ]
}

@test "scripts/cast_db.py exists" {
  [ -f "$REPO_DIR/scripts/cast_db.py" ]
}

# ── Python syntax validation ─────────────────────────────────────────────────

@test "cast-dash.py has valid Python syntax" {
  run python3 -c "import ast; ast.parse(open('$REPO_DIR/scripts/cast-dash.py').read())"
  [ "$status" -eq 0 ]
}

@test "cast_db.py has valid Python syntax" {
  run python3 -c "import ast; ast.parse(open('$REPO_DIR/scripts/cast_db.py').read())"
  [ "$status" -eq 0 ]
}

# ── Config validation ────────────────────────────────────────────────────────

@test "config/model-pricing.json is valid JSON" {
  run python3 -c "import json; json.load(open('$REPO_DIR/config/model-pricing.json'))"
  [ "$status" -eq 0 ]
}

@test "config/model-pricing.json contains at least one model entry" {
  run python3 -c "
import json
with open('$REPO_DIR/config/model-pricing.json') as f:
    data = json.load(f)
if isinstance(data, dict) and len(data) > 0:
    print(f'{len(data)} model entries found')
elif isinstance(data, list) and len(data) > 0:
    print(f'{len(data)} model entries found')
else:
    print('No model entries found')
    exit(1)
"
  [ "$status" -eq 0 ]
}

# ── Syntax validation ────────────────────────────────────────────────────────

@test "bin/cast-dash has valid bash syntax" {
  run bash -n "$REPO_DIR/bin/cast-dash"
  [ "$status" -eq 0 ]
}

@test "install.sh has valid bash syntax" {
  run bash -n "$REPO_DIR/install.sh"
  [ "$status" -eq 0 ]
}
