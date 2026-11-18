# Global Agent Instructions

## Coding Rules

Before writing or reviewing code, read `~/.agents/rules/general.md`, then the rules file for each language you touch:

| Language              | Rules file                      |
| --------------------- | ------------------------------- |
| Lua                   | `~/.agents/rules/lua.md`        |
| Python                | `~/.agents/rules/python.md`     |
| TypeScript/JavaScript | `~/.agents/rules/typescript.md` |
| SCSS/CSS              | `~/.agents/rules/scss.md`       |
| Shell                 | `~/.agents/rules/shell.md`      |
| Terraform             | `~/.agents/rules/terraform.md`  |
| Go                    | `~/.agents/rules/go.md`         |

The project's own `AGENTS.md`/`CLAUDE.md`, tool configs, and existing code win over these rules when they disagree.

## Skills

The skills in `~/.agents/skills/` apply these rules:

| Skill               | Uses the rules to                        |
| ------------------- | ---------------------------------------- |
| `work-on`           | Implement a task                         |
| `pr-review`         | Review and fix a pull request            |
| `pr-resolve-review` | Fix review comments                      |
| `tester`            | Write and validate tests                 |
| `style-guide`       | Generate or update a language rules file |
