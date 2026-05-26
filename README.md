# nemonemo

Marketplace personal de plugins de Claude Code.

## Quick start

```bash
# Añadir el marketplace (una sola vez por máquina)
/plugin marketplace add cristianbotella-arch/nemonemo

# Instalar los plugins que quieras
/plugin install nemo-commit
/plugin install nemo-security
/plugin install nemo-deepthink
/plugin install nemo-deep-review
```

## Plugins

| Plugin | Tipo | Descripción | Comandos / componentes |
|--------|------|-------------|-----------------------|
| **nemo-commit** | Commands | Flujo de git y releases del marketplace | `/commit`, `/commit-push-pr`, `/clean-gone`, `/release` |
| **nemo-security** | Hook | Avisa de patrones inseguros (XSS, eval, pickle, etc.) al editar archivos | Hook `PreToolUse` en `Edit`/`Write`/`MultiEdit` |
| **nemo-deepthink** | Command + Skill | Protocolo de razonamiento profundo: 7-slot interview, red team, pre-mortem | `/deepthink` + skill `deep-think` |
| **nemo-deep-review** | Agents + Commands | Code review con 5 agentes especializados | `/deep-review`, `/pr-review` + 5 agents |

## Estructura del repo

```
nemonemo/
├── .claude-plugin/
│   └── marketplace.json       # Catálogo (vX.Y.Z + entries de plugins)
├── plugins/
│   ├── nemo-commit/
│   ├── nemo-security/
│   ├── nemo-deepthink/
│   └── nemo-deep-review/
│       ├── .claude-plugin/
│       │   ├── plugin.json         # Metadatos del plugin
│       │   └── customizations.json # Origen + cambios desde upstream
│       ├── commands/               # Slash commands (.md)
│       ├── skills/                 # Skills auto-invocables (SKILL.md)
│       ├── agents/                 # Subagentes (.md)
│       └── hooks/                  # Hooks de eventos (.json + scripts)
├── CHANGELOG.md
├── LICENSE
└── README.md
```

## Actualizar el marketplace

**Como maintainer**: edita los archivos del plugin, haz commit, y cuando quieras shippear lanza `/release` en la raíz del repo. El comando detecta plugins cambiados desde el último tag, decide el bump (semver según commits), edita `plugin.json` + `marketplace.json`, actualiza este CHANGELOG, valida JSON, hace commit + tag + push.

**Como consumer** (cualquier sesión de Claude con el marketplace añadido):

| Comando | Qué hace |
|---------|----------|
| `/reload-plugins` | Re-lee `marketplace.json` en la sesión actual. No descarga versiones nuevas. |
| `/plugin update <name>` | Pulla la nueva versión de un plugin (requiere bump de `version`). |
| Sesión nueva | Refresh total — pulla todo lo que tenga versión nueva. |

## Atribución

Los plugins están vendorizados desde [`dmedina-dev/dev-forge`](https://github.com/dmedina-dev/dev-forge) (David Medina, MIT). `dev-forge` a su vez curó la mayoría desde upstreams de Anthropic.

| Plugin nemonemo | dev-forge | Upstream original |
|-----------------|-----------|-------------------|
| `nemo-commit` | `forge-commit` | [`commit-commands`](https://github.com/anthropics/claude-code/tree/main/plugins/commit-commands) — Anthropic |
| `nemo-security` | `forge-security` | [`security-guidance`](https://github.com/anthropics/claude-code/tree/main/plugins/security-guidance) — David Dworken (Anthropic) |
| `nemo-deepthink` | `forge-deepthink` | (original de David Medina) |
| `nemo-deep-review` | `forge-deep-review` | [`pr-review-toolkit`](https://github.com/anthropics/claude-code/tree/main/plugins/pr-review-toolkit) + [`code-review`](https://github.com/anthropics/claude-code/tree/main/plugins/code-review) — Daisy Hollman, Boris Cherny (Anthropic) |

Cada plugin lleva su `customizations.json` con el detalle de qué se modificó respecto a su origen.

## License

MIT
