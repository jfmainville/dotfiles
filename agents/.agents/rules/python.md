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

## Versions and Modern Features

- Target `requires-python`, otherwise the oldest CPython release still getting security fixes (3.10 reached end of life in October 2026, so 3.11).
- Use `match` for branching on structure, `tomllib` for TOML, `typing.Self`, `asyncio.TaskGroup` instead of `asyncio.gather`, and `@dataclass(slots=True, kw_only=True)`.
- Only when the target is 3.12 or newer, use type parameter syntax (`def first[T](items: list[T]) -> T`), `type` aliases, `typing.override`, and `itertools.batched`.
- Run `ruff check --select UP <files>` to find syntax older than the target version, and fix what it reports.

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
