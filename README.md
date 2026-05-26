# nemonemo

Marketplace personal de plugins de Claude Code.

Modelo: **referencia** a plugins de terceros (no vendorizamos, apuntamos directamente a sus repos). Cuando los upstreams se actualizan, basta con bumpear la versión en `marketplace.json` para que los consumers vean los cambios — y `/update-check` te avisa cuándo toca hacerlo.

## Quick start

```bash
# Añadir el marketplace (una sola vez por máquina)
/plugin marketplace add cristianbotella-arch/nemonemo

# Instalar los plugins que quieras
/plugin install forge-keeper          # para tener /update-check (recomendado)
/plugin install forge-commit
/plugin install forge-security
/plugin install forge-deepthink
/plugin install forge-deep-review
```

## Plugins

Todos referenciados desde [`dmedina-dev/dev-forge`](https://github.com/dmedina-dev/dev-forge) (David Medina, MIT).

| Plugin | Tipo | Descripción |
|--------|------|-------------|
| **forge-keeper** | Commands + Hook + Skill | Mantenimiento de contexto. `/sync`, `/status`, `/recall`, `/update-check`, `/handoff`, `/segment-doc`, `/heal-plugin-cache` |
| **forge-commit** | Commands | `/commit`, `/commit-push-pr`, `/clean-gone`, `/release` |
| **forge-security** | Hook | Hook `PreToolUse` en `Edit`/`Write`/`MultiEdit` que avisa de patrones inseguros |
| **forge-deepthink** | Command + Skill | `/deepthink` + skill `deep-think` (protocolo de razonamiento) |
| **forge-deep-review** | Agents + Commands | 5 agents + `/deep-review`, `/pr-review` |

## Estructura del repo

```
nemonemo/
├── .claude-plugin/
│   └── marketplace.json       # Solo el catálogo — los plugins viven en el repo upstream
├── CHANGELOG.md
├── LICENSE
└── README.md
```

No hay carpeta `plugins/` aquí: cada `source.url` apunta a `https://github.com/dmedina-dev/dev-forge.git` con su `path` específico, y Claude Code los baja directamente de allí cuando un consumer hace `/plugin install`.

## Cómo funcionan los updates

**Modelo de referencia**: el catálogo es tuyo (tú decides qué versión exponer a tus consumers), pero los archivos del plugin viven en el repo upstream.

Flujo cuando upstream publica algo nuevo:

1. `/update-check` (de `forge-keeper`) — analiza tu `marketplace.json` y te dice qué plugins tienen una versión más nueva en upstream
2. Decides cuál actualizar y a qué versión
3. Bumpeas el campo `version` de esa entry en tu `marketplace.json` para que coincida con el upstream
4. Commit + push (puedes usar `/release` o a mano)
5. Tus consumers ejecutan `/plugin update <name>` (o abren sesión nueva) y reciben los cambios

**Sin `/update-check` no pasa nada malo**, simplemente te toca a ti revisar dev-forge de vez en cuando para ver si hay nuevas releases.

## Pinning de versiones

La fuerza del modelo referencia: `marketplace.json` actúa como **pin**. Si dev-forge libera una v2 que te rompe, tu marketplace puede quedarse en v1 todo el tiempo que quieras. Solo subes la versión cuando hayas validado los cambios.

## Atribución

| Plugin | Upstream | Autor |
|--------|----------|-------|
| `forge-commit` | [`anthropics/claude-code/plugins/commit-commands`](https://github.com/anthropics/claude-code/tree/main/plugins/commit-commands) | Anthropic |
| `forge-security` | [`anthropics/claude-code/plugins/security-guidance`](https://github.com/anthropics/claude-code/tree/main/plugins/security-guidance) | David Dworken (Anthropic) |
| `forge-deep-review` | [`pr-review-toolkit`](https://github.com/anthropics/claude-code/tree/main/plugins/pr-review-toolkit) + [`code-review`](https://github.com/anthropics/claude-code/tree/main/plugins/code-review) | Daisy Hollman, Boris Cherny (Anthropic) |
| `forge-deepthink`, `forge-keeper` | Originales de [dev-forge](https://github.com/dmedina-dev/dev-forge) | David Medina |

`dev-forge` curó/adaptó los anteriores; nemonemo solo los re-expone como catálogo.

## License

MIT (este catálogo). Cada plugin mantiene su licencia upstream (MIT en todos los casos a fecha 2026-05-26).
