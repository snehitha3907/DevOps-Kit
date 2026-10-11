---
last_verified: 2026-10-11
tool_version: n/a
---

# Terraform testing strategies: tflint, terratest, and infrastructure test harnesses

## Purpose

Define a layered testing strategy for Terraform configurations that catches
different defect classes at the cheapest stage: formatting and syntax errors
before review, rule violations before plan, contract violations before apply,
and behavioural regressions against short-lived environments before rollout.
The three layers covered here are static linting with tflint, Go-driven
integration tests with Terratest, and the CI harness that binds them together
with the built-in plan/apply workflow.

## When to use

| Layer | Catches | Run when |
|---|---|---|
| `fmt` + `validate` | Syntax errors, type mismatches, missing references | Every edit, pre-commit |
| tflint | Deprecated syntax, naming drift, provider rule violations, missing version constraints | Every pull request |
| Native test framework (`.tftest.hcl`) | Module contract violations: wrong outputs for given inputs, broken variable validation | Every pull request touching a module |
| Terratest (Go) | Behavioural regressions: resources that plan cleanly but misbehave once deployed | Module releases and scheduled runs |
| Plan-artifact assertions in CI | Environment drift: a plan that introduces destroys or touches protected resources | Every apply pipeline |

Use all five layers for shared modules. For a single-environment root module,
the first two layers plus plan-artifact assertions are usually sufficient.

## Prerequisites

- A Terraform root configuration or module with its own directory.
- The Terraform CLI available in the working environment.
- tflint installed for the lint step.
- A Go toolchain available for the Terratest step.
- Provider credentials that permit read-only planning at minimum; the
  integration-test step additionally needs credentials scoped to a sandbox
  account or subscription used only by tests.

## Steps

### 1. Enforce formatting and basic validity

Run the two built-in checks before anything else. They are fast, need no
credentials, and eliminate the most common review noise.

```bash
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```

`fmt -check` fails on any file that is not canonically formatted; `init
-backend=false` installs providers without touching remote state; `validate`
type-checks variables, references, and block structure. Gate pull requests on
all three: a failure here means the change never reaches a linter or a plan.

### 2. Lint with tflint

tflint parses the configuration the same way Terraform does and applies a
rule set on top: deprecated syntax, provider-specific misuse (for example an
instance type string that does not exist in the target region), missing
`required_version` and `required_providers` constraints, and naming
conventions the team configures. Initialise its plugin set once per
repository, then run it over the tree:

```bash
tflint --init
tflint --recursive
```

Keep the tflint configuration file in version control next to the Terraform
code and enable rules incrementally: start with the preset ruleset, promote
warnings to errors only after the existing tree passes cleanly. A lint step
that fails on legacy violations nobody intends to fix gets disabled; a lint
step that passes on day one and ratchets upward stays enabled.

### 3. Pin module contracts with the native test framework

For reusable modules, add `.tftest.hcl` files that assert input/output
contracts without deploying anything. Each file declares mock-free runs
against the module with fixed variable values, then asserts on outputs and on
`validation` blocks:

```hcl
run "rejects_negative_retention" {
  command = plan
  variables {
    log_retention_days = -1
  }
  expect_failures = [var.log_retention_days]
}

run "exposes_bucket_name" {
  command = plan
  variables {
    log_retention_days = 30
  }
  assert {
    condition     = output.bucket_name != ""
    error_message = "module must expose the created bucket name"
  }
}
```

Run them with the built-in test command and treat a red test the same as a
red unit test in application code: the module interface changed, and callers
need to be updated or the change reverted.

```bash
terraform init -backend=false
terraform test
```

### 4. Prove behaviour with Terratest against ephemeral environments

Static checks cannot tell whether the deployed infrastructure actually works.
Terratest fills that gap from Go: each test deploys a fixture configuration
into a sandbox account, asserts against the live resources (or their outputs
and tags), then destroys everything, even when an assertion fails, via
deferred cleanup.

```go
func TestVpcModule(t *testing.T) {
  opts := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
    TerraformDir: "./fixtures/minimal",
  })
  defer terraform.Destroy(t, opts)
  terraform.InitAndApply(t, opts)
  assert.NotEmpty(t, terraform.Output(t, opts, "vpc_id"))
}
```

Keep fixtures minimal — the smallest configuration that exercises the
module — and tag every test-created resource so orphaned leftovers from
interrupted runs are identifiable. Run this layer on module release branches
and on a schedule rather than on every commit, since real applies take
minutes and consume cloud quota.

### 5. Bind the layers into a CI harness with plan-artifact checks

The pipeline order is fixed: format check, validate, lint, native tests,
plan to a saved file, assert against the plan artifact, then apply exactly
the reviewed file.

```bash
terraform fmt -check -recursive
terraform validate
tflint --recursive
terraform test
terraform plan -out=tfplan
terraform show -json tfplan > plan.json
terraform apply tfplan
```

The plan-artifact step is where environment protection lives. Render the
plan to JSON and assert the properties the team cares about: no destroy
actions outside an explicit allow-list, no changes to resources tagged as
protected, and an exit status from a separate `plan -detailed-exitcode` run
consistent with expectations (no changes where none were intended). Applying
the saved plan file instead of re-planning guarantees the reviewed change is
the executed change.

## Verify

- `terraform fmt -check -recursive` exits 0 across the repository.
- `terraform validate` passes after a backend-less init.
- `tflint --recursive` reports no errors under the checked-in ruleset.
- `terraform test` passes every `.tftest.hcl` file in the module.
- The Go suite (`go test ./...`) deploys, asserts, and destroys the fixture
  with no leftover resources in the sandbox account.
- A `plan -detailed-exitcode` run returns the expected status for the change
  (no-change vs change-present), and the plan JSON contains no destroy
  actions outside the allow-list.
- `terraform apply` consumes the saved plan file produced by the reviewed
  `plan` step, not a fresh plan.

## Common errors

| Symptom | Likely cause | Fix |
|---|---|---|
| `validate` fails after a clean `fmt` | Provider plugins missing (no `init`) or a genuine type/reference error | Run `init -backend=false` first; treat remaining errors as real defects |
| tflint reports violations on untouched files | Ruleset enabled globally over legacy code | Scope the run to changed directories first, ratchet the ruleset as legacy files are cleaned |
| Native test passes locally, fails in CI | Test relies on default variable values or ambient credentials | Pin every variable in the test run block; use backend-less init in CI |
| Terratest leaves resources behind | Test process killed before deferred destroy ran | Re-run with the same fixture to converge state, destroy explicitly, and tag all fixtures for sweeper identification |
| Apply changes differ from the reviewed plan | Pipeline re-planned at apply time instead of consuming the saved file | Always `apply` the exact plan file artifact from the `plan` step |
| Plan shows destroys nobody expected | Removed or renamed resource without a moved block | Add explicit resource-movement handling and re-plan before approving |

## References

- tflint user guide: installation, plugin initialisation, and ruleset configuration.
- Terratest documentation: test stage helpers, retryable errors, and output assertions.
- Terraform CLI reference: `fmt`, `validate`, `plan` (including saved plan files and detailed exit codes), `show`, `apply`, and `test`.
- AWS Prescriptive Guidance repository structure and CI pipeline shape for Terraform modules (root module layout, fmt/validate/plan/apply ordering).
