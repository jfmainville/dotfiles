---
paths: ["**/*.go", "**/go.mod"]
---

# Go Rules

## Tooling

| Task       | Command                                                       |
| ---------- | ------------------------------------------------------------- |
| Format     | `gofmt -w <files>` (`goimports -w` if the project uses it)    |
| Lint       | `golangci-lint run` when configured, otherwise `go vet ./...` |
| Type-check | `go build ./...`                                              |
| Test       | `go test ./...` (`-race` for concurrent code)                 |

## Versions and Modern Features

- Target the `go` directive in `go.mod`, otherwise the oldest Go release still supported (Go supports the two most recent releases).
- Use generics when they remove duplication, the `min`, `max`, and `clear` built-ins, and the `slices`, `maps`, and `cmp` packages instead of hand-written loops.
- Use `for i := range n` and drop the old `v := v` loop variable copies (Go 1.22+).
- Use range-over-func iterators (`iter.Seq`) only when the target is Go 1.23 or newer, and `t.Context()` and `b.Loop()` in tests only for Go 1.24 or newer.

## Conventions

- Names are `MixedCaps`, exported with an uppercase first letter. Keep acronyms in one case (`userID`, `HTTPClient`).
- Package names are short, lowercase, one word, and never `util`, `common`, or `helpers`.
- Return errors as the last value and check them right away. Never discard one with `_`.
- Wrap errors with context (`fmt.Errorf("load config: %w", err)`), and compare them with `errors.Is` and `errors.As`.
- Pass `context.Context` as the first parameter of anything that does I/O or can block.
- Accept interfaces and return concrete types. Define an interface where it is used, not where it is implemented.
- Keep the happy path unindented: handle errors and edge cases first with an early `return`.
- Use the standard library first (`net/http`, `log/slog`, `encoding/json`, `errors`) before adding a package.
- Start every goroutine with a clear way to stop it (a cancelled context or a closed channel).

## Preferred Packages

| Need        | Package                                                         |
| ----------- | --------------------------------------------------------------- |
| Logging     | `log/slog`                                                      |
| HTTP router | `net/http` (Go 1.22+ patterns), or `chi` if the project uses it |
| CLI         | `cobra`                                                         |
| Config      | `viper` (or the standard `flag` package for small tools)        |
| Testing     | `testing`, plus `testify` if the project uses it                |

## Testing

- Tests sit next to the code in `<file>_test.go`, with functions named `Test<Function>_<behavior>`.
- Use table-driven tests with `t.Run` subtests for input variations.
- Call `t.Helper()` in test helpers and `t.Parallel()` in independent tests.
- Use `httptest` for HTTP handlers and clients instead of real network calls.

## Avoid

- `panic` outside of `main` or truly unrecoverable states.
- `init()` functions with side effects.
- Package-level mutable state.
- Naked returns in functions longer than a few lines.
