# nemonemo

Marketplace personal de plugins de Claude Code.

## Uso rápido

```bash
# Añadir el marketplace (una sola vez por máquina)
/plugin marketplace add cristianbotella-arch/nemonemo

# Instalar plugins
/plugin install nemo-commit
```

## Plugins

| Plugin | Descripción | Comandos |
|--------|-------------|----------|
| **nemo-commit** | Flujo de git para commits, PRs y releases del marketplace | `/commit`, `/commit-push-pr`, `/clean-gone`, `/release` |

## Estructura del repo

```
nemonemo/
├── .claude-plugin/
│   └── marketplace.json       # Catálogo de plugins
├── plugins/
│   └── nemo-commit/
│       ├── .claude-plugin/
│       │   ├── plugin.json         # Metadatos del plugin
│       │   └── customizations.json # Origen + cambios desde upstream
│       └── commands/               # Slash commands (.md)
└── README.md
```

## Atribución

`nemo-commit` está adaptado de [`forge-commit`](https://github.com/dmedina-dev/dev-forge/tree/main/plugins/forge-commit) (David Medina, [dev-forge](https://github.com/dmedina-dev/dev-forge)), que a su vez vendoriza [`commit-commands`](https://github.com/anthropics/claude-code/tree/main/plugins/commit-commands) de Anthropic.
