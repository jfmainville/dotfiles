---
paths: ["**/*.tf", "**/*.tfvars", "**/*.hcl"]
---

# Terraform Rules

Apply after `~/.agents/rules/general.md`.

## Tooling

| Task     | Command                                                                |
| -------- | ---------------------------------------------------------------------- |
| Format   | `terraform fmt -recursive`                                             |
| Validate | `terraform validate`                                                   |
| Lint     | `tflint --recursive`                                                   |
| Test     | `terraform test`, only if the project already has `*.tftest.hcl` files |

## Conventions

- Split each root module into `main.tf`, `variables.tf`, `outputs.tf`, `providers.tf`, and `versions.tf`.
- Pin `required_version` and every provider in `required_providers` with `~>` constraints.
- Give every variable a `type` and a `description`, and every output a `description`.
- Names are `snake_case` for resources, variables, and outputs. Don't repeat the resource type in its name (`aws_s3_bucket.logs`, not `aws_s3_bucket.logs_bucket`).
- Use `for_each` over `count` for anything that isn't a simple on/off toggle.
- Use `locals` for repeated expressions and common tags.
- Prefer well-known registry modules (e.g. `terraform-aws-modules`) over hand-written equivalents, pinned to a version.

## Security

- Never put secrets in `.tf` or `.tfvars` files. Load them from the project's secret store and mark the variables `sensitive = true`.
- No `0.0.0.0/0` ingress, public buckets, or wildcard IAM actions/resources unless the requirement says so.
- Enable encryption at rest and in transit when the resource supports it.

## Avoid

- Hard-coded account IDs, regions, and ARNs. Use variables or data sources.
- `local-exec` and `remote-exec` provisioners when a resource or data source can do the job.
