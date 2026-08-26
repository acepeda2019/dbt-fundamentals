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

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
