---
paths: ["**/*.sh", "**/*.bash", "**/*.zsh", "**/.zshrc", "**/.bashrc"]
---

# Shell Rules

Apply after `~/.agents/rules/general.md`.

## Tooling

| Task   | Command                                                  |
| ------ | -------------------------------------------------------- |
| Format | `shfmt -w <files>`                                       |
| Lint   | `shellcheck <files>` (Bash and POSIX `sh` only, not Zsh) |
| Test   | `bats`, only if the project already has it               |

## Versions and Modern Features

- macOS ships Bash 3.2. Scripts that must run there without Homebrew's Bash avoid Bash 4+ features: associative arrays, `mapfile`/`readarray`, `${var,,}`/`${var^^}`, and `|&`. Linux-only scripts can use Bash 4 and 5 features.
- Zsh files can use Zsh features, such as glob qualifiers (`(N-/)`) and array helpers.
- Use `printf` instead of `echo -e`, `readonly` for constants, and `command -v` instead of `which`.

## Conventions

- Start scripts with `#!/usr/bin/env bash` and `set -euo pipefail`. Zsh config files (`.zshrc`) keep Zsh syntax and skip `set -e`.
- Quote every variable expansion (`"$var"`, `"$@"`).
- Use `[[ ... ]]` for tests and `$(...)` for command substitution.
- Declare variables inside functions with `local`.
- Names are `snake_case` for variables and functions, `UPPER_SNAKE_CASE` only for exported or environment variables.
- Check that required commands exist (`command -v tool >/dev/null`) before using them.
- Write errors to stderr (`>&2`) and exit with a non-zero code.
- Use `mktemp` for temporary files and clean them up with `trap`.

## Avoid

- Parsing `ls` output. Use globs or `find`.
- `eval` and unquoted `$*`.
- `sudo` inside scripts unless the script's purpose requires it.
- Piping remote scripts into a shell (`curl ... | sh`) without pinning the source.
