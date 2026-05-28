# nemonemo

Marketplace personal de plugins de Claude Code. Solo plugins propios (vendorizados en `plugins/`), mantenidos por el owner del marketplace.

## Quick start

```bash
# Añadir el marketplace (una sola vez por máquina)
/plugin marketplace add cristianbotella-arch/nemonemo

# Instalar los plugins que quieras
/plugin install nemo-siamese          # gato siamés en ASCII al abrir sesión
/plugin install nemo-caveman          # /caveman: respuestas ultra-compactas
/plugin install nemo-habla            # español siempre (incluso bajo caveman) + /llados-mode + /castellano-antiguo
/plugin install nemo-comments         # skill: comentarios de código mínimos y concisos
```

## Plugins

| Plugin | Tipo | Descripción |
|--------|------|-------------|
| **nemo-siamese** | Hook | `SessionStart` que imprime un ASCII de un gato siamés al empezar cada sesión |
| **nemo-caveman** | Command | `/caveman` activa modo respuestas ultra-compactas (drop fluff, keep technical substance). Adaptado de `mattpocock/skills` (MIT) |
| **nemo-habla** | Hook + Commands | Estilo de comunicación. Hook `UserPromptSubmit` que responde siempre en español (es-ES) incluso bajo `caveman`; código y comentarios siguen en inglés. `/llados-mode` activa modo persona Amadeo Lladós. `/castellano-antiguo` activa modo escriba medieval (siglos XIII-XV, grafías arcaicas, tratamiento de "vuestra merced"). Ambos modos sólo se activan vía slash command explícito, son mutuamente excluyentes y nunca tocan la corrección técnica |
| **nemo-comments** | Skill | Se activa cuando Claude va a escribir o editar comentarios en código (inline, JSDoc/TSDoc, docstrings, TODOs). Default: no comentar. Solo añade comentario si explica un WHY no obvio, y siempre conciso (1-2 líneas). Aplica las mismas reglas a docstrings que a comentarios inline |

## Estructura del repo

```
nemonemo/
├── .claude-plugin/
│   └── marketplace.json       # Catálogo de plugins propios
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
│   ├── nemo-habla/            # Plugin propio (vendorizado)
│   │   ├── .claude-plugin/plugin.json
│   │   ├── hooks/
│   │   │   ├── hooks.json
│   │   │   ├── pin-language.sh
│   │   │   └── language.txt
│   │   └── commands/
│   │       ├── llados-mode.md
│   │       └── castellano-antiguo.md
│   └── nemo-comments/         # Plugin propio (vendorizado)
│       ├── .claude-plugin/plugin.json
│       └── skills/
│           └── nemo-comments/
│               └── SKILL.md
├── CHANGELOG.md
├── LICENSE
└── README.md
```

## Cómo funcionan los updates

1. Edita el código del plugin en `plugins/<nombre>/`
2. Bumpea `version` en su `plugin.json` y en la entry correspondiente de `.claude-plugin/marketplace.json`
3. Bumpea `metadata.version` del marketplace (semver: nuevo plugin = minor, breaking = major)
4. Añade entrada en `CHANGELOG.md`
5. `bash scripts/marketplace-health.sh` para validar
6. Commit + tag `vX.Y.Z` + push
7. Tus consumers ejecutan `/plugin update <name>` (o abren sesión nueva)

## License

MIT.
