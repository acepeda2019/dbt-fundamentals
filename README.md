Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt build

### Catalog & schema naming

Models are organized by layer schema (`staging`, `intermediate`, `marts`), and environments are
separated at the **catalog** level rather than by prefixing schema names:

| Target | Catalog | Example |
|---|---|---|
| `dev` | `{database}_{schema}` (e.g. `analytics_acepeda`) | `analytics_acepeda.marts.fct_orders` |
| `prod` | `{database}` (e.g. `analytics`) | `analytics.marts.fct_orders` |

This is controlled by two macros:
- `macros/generate_database_name.sql` — picks the catalog based on `target.name`
- `macros/generate_schema_name.sql` — always returns the plain layer schema name (no env prefix)

Per-layer schema is set via `+schema` in `dbt_project.yml`. A dev-only catalog (e.g.
`analytics_acepeda`) must exist before building — Unity Catalog auto-creates missing schemas but
not missing catalogs, so run `create catalog if not exists <catalog>` once per new dev catalog.

### Databricks token setup (needed for Python models)

`profiles.yml` (`~/.dbt/profiles.yml`) reads the Databricks PAT from env vars:

```yaml
token: "{{ env_var('DBT_DATABRICKS_TOKEN') }}"          # dev
token: "{{ env_var('DBT_DATABRICKS_TOKEN_PAID') }}"     # dev-paid
```

The SQL warehouse connection (`auth_type: oauth`) doesn't need these — but Python models
(e.g. `models/intermediate/is_holiday.py`) submit a job via the Databricks REST API, which
requires a PAT in the environment, not just OAuth.

Put the tokens in a project-root `.env` (gitignored) as `DBT_DATABRICKS_TOKEN=...` and
`DBT_DATABRICKS_TOKEN_PAID=...`, then export them into your shell before running dbt:

```bash
set -a && source .env && set +a
```

**Gotcha:** if you're running/debugging Python models through Cursor/VS Code's dbt Power
User extension instead of a terminal, the extension talks to a background `dbt lsp` process
it spawned. That process only has whatever env it was started with — sourcing `.env` in a
terminal *after* the LSP already started won't reach it. If a Python model complains about a
missing token even though your terminal works fine:

1. Check for a stale LSP process: `ps aux | grep "dbt lsp"` — if there's more than one, or
   one with an old start time, `kill` it.
2. Reload the editor window (Cursor: "Developer: Reload Window") so the extension respawns
   `dbt lsp` fresh, picking up the current environment.

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
