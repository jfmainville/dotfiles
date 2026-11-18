# Global Agent Instructions

## Coding Rules

Before writing or reviewing code, follow `~/.agents/rules/general.md`, then the rules file for each language you touch:

| Language              | Rules file                      |
| --------------------- | ------------------------------- |
| Lua                   | `~/.agents/rules/lua.md`        |
| Python                | `~/.agents/rules/python.md`     |
| TypeScript/JavaScript | `~/.agents/rules/typescript.md` |
| SCSS/CSS              | `~/.agents/rules/scss.md`       |
| Shell                 | `~/.agents/rules/shell.md`      |
| Terraform             | `~/.agents/rules/terraform.md`  |
| Ansible               | `~/.agents/rules/ansible.md`    |
| Go                    | `~/.agents/rules/go.md`         |

The project's own `AGENTS.md`/`CLAUDE.md`, tool configs, and existing code win over these rules when they disagree.

## Git

For branches, commits, pull requests, and review replies, follow `~/.agents/rules/git.md`.

## Reading the Rules

Only read a rules file when its content isn't already in your context. Claude Code loads `general.md` and `git.md` on its own, plus the language file for each file you open, so don't read them again there. Other harnesses read them by path.

## Skills

The skills in `~/.agents/skills/` apply these rules:

| Skill               | Uses the rules to                        |
| ------------------- | ---------------------------------------- |
| `work-on`           | Implement a task                         |
| `pr-review`         | Review and fix a pull request            |
| `pr-resolve-review` | Fix review comments                      |
| `tester`            | Write and validate tests                 |
| `style-guide`       | Generate or update a language rules file |
