---
paths: ["**/*.py"]
---

# Python Rules

Apply after `~/.agents/rules/general.md`.

## Tooling

| Task       | Command                                                  |
| ---------- | -------------------------------------------------------- |
| Format     | `black <files>`                                          |
| Lint       | `ruff check <files>` (`ruff check --fix` for safe fixes) |
| Type-check | `pyright`                                                |
| Test       | `pytest`                                                 |

## Conventions

- Add type hints to every function signature. Use built-in generics (`list[str]`, `dict[str, int]`, `X | None`).
- Names are `snake_case` for functions and variables, `PascalCase` for classes, `UPPER_SNAKE_CASE` for constants.
- Use `pathlib.Path` for paths, f-strings for formatting, and `logging` instead of `print` outside CLI output.
- Use `dataclasses` for plain data, and the project's model library (e.g. `pydantic`) for validated input.
- Catch specific exceptions, never a bare `except:`. Re-raise with `raise ... from err` to keep the cause.
- Keep imports at the top of the file, grouped as standard library, third-party, then local.

## Preferred Packages

| Need                    | Package                                        |
| ----------------------- | ---------------------------------------------- |
| HTTP client             | `httpx` (or `requests` if the project uses it) |
| Validation and settings | `pydantic`, `pydantic-settings`                |
| CLI                     | `typer` (or `click`)                           |
| Retries                 | `tenacity`                                     |
| Testing                 | `pytest`, `pytest-mock`                        |

## Testing

- Tests live in `tests/`, in files named `test_<module>.py`, with functions named `test_<behavior>`.
- Use fixtures for setup and `pytest.mark.parametrize` for input variations instead of loops in tests.
- Assert specific exceptions with `pytest.raises(SpecificError, match=...)`.

## Avoid

- Mutable default arguments (`def f(x=[])`).
- `from module import *`.
- `os.system` or `subprocess` with `shell=True` on untrusted input.
