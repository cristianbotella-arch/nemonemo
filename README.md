# nemonemo

Marketplace personal de plugins de Claude Code.

Combina dos modelos:
- **Plugins propios** (vendorizados en `plugins/`): mantenidos por el owner del marketplace.
- **Referencias a plugins de terceros** (apuntan directamente al repo upstream): el catálogo actúa como un pin curado. Cuando upstream se actualiza, basta con bumpear la versión en `marketplace.json` — y `/update-check` te avisa cuándo toca hacerlo.

## Quick start

```bash
# Añadir el marketplace (una sola vez por máquina)
/plugin marketplace add cristianbotella-arch/nemonemo

# Instalar los plugins que quieras
/plugin install nemo-siamese          # gato siamés en ASCII al abrir sesión
/plugin install nemo-caveman          # /caveman: respuestas ultra-compactas
/plugin install nemo-habla            # español siempre (incluso bajo caveman) + /llados-mode + /castellano-antiguo
/plugin install forge-keeper          # /update-check + mantenimiento de contexto
/plugin install forge-commit
/plugin install forge-security
/plugin install forge-deepthink
/plugin install forge-deep-review
/plugin install forge-proactive-qa    # requiere Playwright instalado en el proyecto objetivo
```

## Plugins

### Propios (vendorizados)

| Plugin | Tipo | Descripción |
|--------|------|-------------|
| **nemo-siamese** | Hook | `SessionStart` que imprime un ASCII de un gato siamés al empezar cada sesión |
| **nemo-caveman** | Command | `/caveman` activa modo respuestas ultra-compactas (drop fluff, keep technical substance). Adaptado de `mattpocock/skills` (MIT) |
| **nemo-habla** | Hook + Commands | Estilo de comunicación. Hook `UserPromptSubmit` que responde siempre en español (es-ES) incluso bajo `caveman`; código y comentarios siguen en inglés. `/llados-mode` activa modo persona Amadeo Lladós. `/castellano-antiguo` activa modo escriba medieval (siglos XIII-XV, grafías arcaicas, tratamiento de "vuestra merced"). Ambos modos sólo se activan vía slash command explícito, son mutuamente excluyentes y nunca tocan la corrección técnica |

### Referenciados desde [`dmedina-dev/dev-forge`](https://github.com/dmedina-dev/dev-forge)

| Plugin | Tipo | Descripción |
|--------|------|-------------|
| **forge-keeper** | Commands + Hook + Skill | Mantenimiento de contexto. `/sync`, `/status`, `/recall`, `/update-check`, `/handoff`, `/segment-doc`, `/heal-plugin-cache` |
| **forge-commit** | Commands | `/commit`, `/commit-push-pr`, `/clean-gone`, `/release` |
| **forge-security** | Hook | Hook `PreToolUse` en `Edit`/`Write`/`MultiEdit` que avisa de patrones inseguros |
| **forge-deepthink** | Command + Skill | `/deepthink` + skill `deep-think` (protocolo de razonamiento) |
| **forge-deep-review** | Agents + Commands | 5 agents + `/deep-review`, `/pr-review` |
| **forge-proactive-qa** | Command + Skill + Rules + Scripts | Agente autónomo de QA con Playwright. `/proactive-qa init`, modos `explore` / `autofix` / `cycle` (pensado para `/loop`). Requiere Playwright en el proyecto objetivo. |

## Estructura del repo

```
nemonemo/
├── .claude-plugin/
│   └── marketplace.json       # Catálogo (entries propias + referencias)
├── plugins/
│   ├── nemo-siamese/          # Plugin propio (vendorizado)
│   │   ├── .claude-plugin/plugin.json
│   │   └── hooks/
│   │       ├── hooks.json
│   │       └── siamese.txt
│   ├── nemo-caveman/          # Plugin propio (vendorizado)
│   │   ├── .claude-plugin/plugin.json
│   │   └── commands/
│   │       └── caveman.md
│   └── nemo-habla/            # Plugin propio (vendorizado)
│       ├── .claude-plugin/plugin.json
│       ├── hooks/
│       │   ├── hooks.json
│       │   ├── pin-language.sh
│       │   └── language.txt
│       └── commands/
│           ├── llados-mode.md
│           └── castellano-antiguo.md
├── CHANGELOG.md
├── LICENSE
└── README.md
```

Las entries que apuntan a `dev-forge` no traen archivos al repo — Claude Code los baja directamente del upstream cuando un consumer hace `/plugin install`.

## Cómo funcionan los updates

**Referencias** (los `forge-*`): el catálogo es tuyo (tú decides qué versión exponer), pero los archivos viven en el repo upstream.

1. `/update-check` (de `forge-keeper`) — analiza tu `marketplace.json` y te dice qué plugins tienen versión más nueva en upstream
2. Decides cuáles actualizar y a qué versión
3. Bumpeas el campo `version` de esa entry en tu `marketplace.json`
4. Commit + push (puedes usar `/release` o a mano)
5. Tus consumers ejecutan `/plugin update <name>` (o abren sesión nueva)

**Propios** (los `nemo-*`): editas el código del plugin, bumpeas su `version` en `plugin.json` y en `marketplace.json`, commit + push.

## Pinning de versiones

La fuerza del modelo referencia: `marketplace.json` actúa como **pin**. Si dev-forge libera una v2 que te rompe, tu marketplace puede quedarse en la anterior todo el tiempo que quieras. Solo subes la versión cuando hayas validado los cambios.

## Atribución (plugins referenciados)

| Plugin | Upstream | Autor |
|--------|----------|-------|
| `forge-commit` | [`anthropics/claude-code/plugins/commit-commands`](https://github.com/anthropics/claude-code/tree/main/plugins/commit-commands) | Anthropic |
| `forge-security` | [`anthropics/claude-code/plugins/security-guidance`](https://github.com/anthropics/claude-code/tree/main/plugins/security-guidance) | David Dworken (Anthropic) |
| `forge-deep-review` | [`pr-review-toolkit`](https://github.com/anthropics/claude-code/tree/main/plugins/pr-review-toolkit) + [`code-review`](https://github.com/anthropics/claude-code/tree/main/plugins/code-review) | Daisy Hollman, Boris Cherny (Anthropic) |
| `forge-deepthink`, `forge-keeper` | Originales de [dev-forge](https://github.com/dmedina-dev/dev-forge) | David Medina |

## License

MIT (este catálogo y los plugins propios). Cada plugin referenciado mantiene su licencia upstream.
