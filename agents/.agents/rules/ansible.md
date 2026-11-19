---
paths:
  [
    "**/ansible/**/*.yml",
    "**/ansible/**/*.yaml",
    "**/playbooks/**/*.yml",
    "**/roles/**/*.yml",
    "**/*playbook*.yml",
  ]
---

# Ansible Rules

## Tooling

| Task   | Command                                                               |
| ------ | --------------------------------------------------------------------- |
| Format | `prettier --write <files>`                                            |
| Lint   | `ansible-lint <files>`                                                |
| Syntax | `ansible-playbook --syntax-check <playbook>`                          |
| Test   | `molecule test`, only if the project already has a `molecule/` folder |

## Versions and Modern Features

- Target the `ansible-core` version the project pins, otherwise the latest release.
- Use fully qualified collection names (`ansible.builtin.copy`, not `copy`).
- Use `ansible.builtin.import_*` for static reuse and `include_*` only for dynamic reuse.
- Use `loop` instead of `with_*`, and `ansible_facts['...']` instead of injected `ansible_*` fact variables.

## Conventions

- Start each YAML file with `---` and indent with 2 spaces.
- Give every play and task a `name` that starts with a capital letter and describes the outcome.
- Write module arguments as YAML maps, not `key=value` strings.
- Use `true`/`false` for booleans, not `yes`/`no`.
- Names are `snake_case` for variables, and role variables start with the role name (`nginx_port`).
- Put defaults in `defaults/main.yml`, and constants in `vars/main.yml`.
- Set `mode` explicitly on `copy`, `template`, and `file` tasks, as a quoted string (`"0644"`).
- Prefer a module over `command` or `shell`. When one is needed, set `changed_when` and use `creates` or `removes` where possible.
- Use handlers for service restarts and reloads.
- Tag tasks only when the project already uses tags.
- Use `ansible-vault` for secrets and load the vault password from the project's secret store.

## Security

- Never commit plaintext secrets, keys, or passwords. Encrypt them with `ansible-vault`.
- Set `no_log: true` on tasks that handle secrets.
- Use `become` only on the plays or tasks that need it.

## Avoid

- `ignore_errors: true`. Use `failed_when` or `block`/`rescue` instead.
- `command`/`shell` tasks that are not idempotent.
- `latest` as a package `state` unless the requirement says so.
- Hard-coded hosts, users, and paths. Use inventory variables.
