#!/usr/bin/env bash
# SessionStart greeting: prints the NEMO banner and a random cat fact.
set -euo pipefail

ROOT="${CLAUDE_PLUGIN_ROOT:-$(dirname "$0")/..}"

cat "${ROOT}/hooks/banner.txt"

python3 -c "
import random, os, sys
path = os.path.join('${ROOT}', 'hooks', 'facts.txt')
with open(path, encoding='utf-8') as f:
    facts = [line.strip() for line in f if line.strip()]
print('  ✿ ' + random.choice(facts))
print()
"
