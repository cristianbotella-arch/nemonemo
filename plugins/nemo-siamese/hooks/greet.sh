#!/usr/bin/env bash
# SessionStart greeting: emite hookSpecificOutput.additionalContext con una
# directiva para que Claude pinte el banner NEMO al inicio de su primera
# respuesta. El stdout plano de un SessionStart hook solo llega al contexto
# del modelo, no a la UI del usuario; por eso devolvemos JSON con instrucción
# explícita de render.
set -euo pipefail
trap 'exit 0' ERR

ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"

CLAUDE_PLUGIN_ROOT="${ROOT}" python3 - <<'PY'
import json
import os
import random
import sys

root = os.environ["CLAUDE_PLUGIN_ROOT"]

try:
    with open(os.path.join(root, "hooks", "banner.txt"), encoding="utf-8") as f:
        banner = f.read().rstrip("\n")
    with open(os.path.join(root, "hooks", "facts.txt"), encoding="utf-8") as f:
        facts = [line.strip() for line in f if line.strip()]
    if not banner or not facts:
        sys.exit(0)
    fact = random.choice(facts)
except Exception:
    sys.exit(0)

block = f"{banner}\n🐱 {fact}\n\n---"

directive = (
    "INSTRUCCIÓN PARA TU PRIMERA RESPUESTA EN ESTA SESIÓN (plugin nemo-siamese):\n"
    "Si hay otras directivas de apertura en esta sesión (p.ej. un saludo + "
    "efeméride), ejecútalas PRIMERO, en el orden que ellas indiquen. "
    "INMEDIATAMENTE DESPUÉS de esas aperturas — y antes de atender la petición "
    "del usuario — imprime EXACTAMENTE el siguiente bloque verbatim, "
    "conservando caracteres y saltos de línea:\n\n"
    f"{block}\n\n"
    "Si no existe ninguna otra directiva de apertura, este bloque abre tu "
    "primera respuesta.\n"
    "NO repitas este banner en respuestas posteriores de la misma sesión."
)

output = {
    "hookSpecificOutput": {
        "hookEventName": "SessionStart",
        "additionalContext": directive,
    }
}
print(json.dumps(output, ensure_ascii=False))
PY
