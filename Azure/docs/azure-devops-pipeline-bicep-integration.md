---
last_verified: 2026-10-08
tool_version: n/a
---

# Azure DevOps pipeline integration with Bicep deployments

## Purpose

This doc describes how to wire an Azure DevOps pipeline so that a Bicep file is validated, reviewed, and deployed through CI/CD rather than by hand. The pattern separates authoring (the Bicep template) from the pipeline that consumes it, which is what makes the same artifact reusable across environments and safe to change repeatedly.

## When to use

Use this pattern when a team owns a set of Azure resources that must exist in more than one environment and be recreated from scratch. If the resources are one-off, the Azure CLI is a shorter path. If the resources are declared in Bicep and already deployed, the pipeline's job is to keep the live state aligned with the file — which is the same loop Argo CD and Flux run for Kubernetes.

## Prerequisites

- An Azure DevOps project with a repository that holds the Bicep file.
- An Azure service connection (service principal or managed identity) with permission to deploy to the target resource group.
- The Bicep file should already build locally with `az bicep build` and pass `az bicep lint`.

## Steps

### Step 1 — Organize the Bicep artifact

Keep the template and its parameters in the repository, for example:

```
infra/
  main.bicep
  main.parameters.dev.json
  main.parameters.prod.json
```

Each parameters file carries only environment-specific values. Nothing sensitive is committed; secrets come from the pipeline's variable group at deploy time.

### Step 2 — Add a pipeline YAML

The pipeline runs four stages in order: build, validate, and deploy. Build compiles the Bicep to ARM so the artifact is reviewable; validate checks the template and runs a what-if against the target scope; deploy applies the compiled template only after the what-if has been inspected.

```yaml
trigger:
  branches:
    include: [ main ]

variables:
  - group: infra-secrets

stages:
  - stage: Build
    jobs:
      - job: Compile
        steps:
          - task: AzureCLI@2
            displayName: bicep build
            inputs:
              azureSubscription: infra-service-connection
              scriptType: bash
              script: |
                az bicep build --file infra/main.bicep --outs $(Build.SourcesDirectory)/infra/main.json

  - stage: Validate
    dependsOn: Build
    jobs:
      - job: Lint
        steps:
          - task: AzureCLI@2
            inputs:
              script: az bicep lint --file infra/main.bicep
      - job: WhatIf
        steps:
          - task: AzureCLI@2
            inputs:
              script: |
                az deployment group what-if \
                  --resource-group $(rg) \
                  --template-file infra/main.bicep \
                  --parameters infra/main.parameters.$(environment).json
```

### Step 3 — Approve before deploy

The deploy stage should not run automatically. Put it behind an environment with reviewers, or gate it on a manual approval check. That is what separates a safe change from a change that can take a production resource down without warning.

### Step 4 — Deploy

```yaml
  - stage: Deploy
    dependsOn: Validate
    environment: infra-$(environment)
    jobs:
      - deployment: Apply
        steps:
          - task: AzureCLI@2
            inputs:
              script: |
                az deployment group create \
                  --resource-group $(rg) \
                  --template-file infra/main.bicep \
                  --parameters infra/main.parameters.$(environment).json \
                  --no-what-if
```

## Verify

After the pipeline completes, confirm:

- The build stage produced `main.json` next to the source Bicep.
- The what-if stage printed a diff and exited zero.
- The deploy stage reported the resources it created or updated, and the count matches the what-if.
- Re-running the pipeline on an unchanged file produces no changes in the deploy report.

## Common errors

- `az bicep build` fails because a parameter file references a key that the template does not declare. Check the parameter file against the template's `param` declarations.
- The what-if shows a change the deploy did not apply. The deploy stage ran against a different resource group or parameters file than the what-if; align them.
- The service connection lacks `Microsoft.Resources/deployments/*`. Grant the role on the resource group scope, not the subscription.

## References

- Azure Resource Manager Bicep documentation (Microsoft Learn)
- Azure DevOps pipelines documentation (Microsoft Learn)