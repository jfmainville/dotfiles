---
name: tech-docs
description: Write or update a repository's technical docs (architecture and implementation per service, with Mermaid diagrams and tables) on a given branch, then commit and open a draft PR. Use for "tech-docs NUA-1234-billing-docs", "document this repo", or "update the docs".
license: MIT
compatibility: Requires git and an authenticated gh.
allowed-tools: Bash(git *) Bash(gh *)
argument-hint: "<branch-name> [product, service, or path] [output directory, defaults to docs]"
metadata:
  author: jfmainville
  version: "2.0.0"
  homepage: https://github.com/jfmainville/dotfiles
---

Document how each service is built and works, with only what a new engineer needs. Rules live in `~/.agents/rules/`.

## 1. Parse and Branch

Arguments: $ARGUMENTS (`<branch-name> [target] [output-dir]`)

- The branch name is required and used verbatim. Its leading `^[A-Za-z]+-[0-9]+` is the task ID, if there is one.
- The target defaults to the whole repo, and the output directory to `docs/`.
- If `git status` shows changes or the branch exists, ask the user. Otherwise branch from the freshly pulled default branch (`gh repo view --json defaultBranchRef -q .defaultBranchRef.name`).

## 2. Understand

Never document what you haven't confirmed in code, config, or infrastructure.

- Detect a monorepo (`apps/`, `services/`, `packages/`, workspace files, several deployables).
- Per service, find the entry points, interfaces (routes, gRPC, queues, CLI), data stores, external dependencies, and configuration.
- Find the cloud provider and managed services from the infrastructure and CI files.
- Update existing docs and `README.md` files instead of rewriting them, and remove what is no longer true.

## 3. Structure

Use as few files as possible:

```
docs/README.md            # What it is, why it exists, and a table linking every doc
docs/architecture.md      # Cloud diagram, components table, sequence diagrams, data stores, dependencies
docs/implementation.md    # Code layout, key modules, configuration and env vars, run, test, deploy
```

For a monorepo, use `docs/README.md` (the product index), `docs/general/architecture.md` (shared infrastructure and how products interact), `docs/general/conventions.md` (only if needed), and `docs/<product>/` with the three files above, named after the product's directory. Link to general content instead of repeating it.

## 4. Write

- Write for humans, concisely, with no intro or summary filler. Explain the why of non-obvious decisions only.
- Prefer tables and lists, with paragraphs of three sentences at most. Every bullet ends with a period.
- No em dashes, semicolons, or colons as separators outside code, paths, URLs, and Mermaid.
- Headings are short and Title Case, with no separators. No horizontal rules.
- Inline code for file names, paths, versions, commands, env vars, and technical terms. Link to source files with relative paths instead of copying code.
- Use Mermaid for every diagram, never images or ASCII art, with one sentence above each saying what it shows and one idea per diagram.
  - Architecture is a `flowchart` with nested `subgraph`s for provider, account, region, and network, with nodes named after the real managed services (`Amazon RDS`, `Cloud Run`).
  - Each main flow (a request, auth, a job, a deploy) gets a `sequenceDiagram`. Use `erDiagram` or `stateDiagram-v2` when they fit.

## 5. Commit and Open the PR

Run the format and lint check from `general.md` and render-check the diagrams (`npx -y @mermaid-js/mermaid-cli`, if available). Commit per `git.md` with the `docs` type, with the product or `general` as scope, one commit per product in a monorepo. Open a draft PR per `git.md`. **Changes** lists the products documented or docs significantly changed, and **Additional Notes** lists what couldn't be confirmed from the code. Report the PR URL.
