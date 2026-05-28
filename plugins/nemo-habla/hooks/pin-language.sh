#!/usr/bin/env bash
# UserPromptSubmit hook: reinyecta en CADA turno una directiva de idioma para
# que Claude responda siempre en español. Va por UserPromptSubmit (no
# SessionStart) a propósito: se re-emite en cada mensaje del usuario, así
# sobrevive al resumen de contexto de sesiones largas y le gana al drift al
# inglés de skills escritas en inglés (p.ej. caveman). Emitimos
# hookSpecificOutput.additionalContext (no stdout plano) para inyectar la
# directiva como contexto del modelo de forma fiable.
set -euo pipefail
trap 'exit 0' ERR

ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"

CLAUDE_PLUGIN_ROOT="${ROOT}" python3 - <<'PY'
import json
import os
import sys

root = os.environ["CLAUDE_PLUGIN_ROOT"]

try:
    with open(os.path.join(root, "hooks", "language.txt"), encoding="utf-8") as f:
        directive = f.read().strip()
    if not directive:
        sys.exit(0)
except Exception:
    sys.exit(0)

output = {
    "hookSpecificOutput": {
        "hookEventName": "UserPromptSubmit",
        "additionalContext": directive,
    }
}
print(json.dumps(output, ensure_ascii=False))
PY
