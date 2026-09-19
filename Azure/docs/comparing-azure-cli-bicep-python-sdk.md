---
last_verified: 2026-09-19
tool_version: n/a
sources: []
---

# Comparing Azure CLI, Bicep, and the Python SDK for provisioning a small app stack

## Purpose

Three tools can provision resources in Azure: the Azure CLI, Bicep, and the Python SDK. Each occupies a different point on the spectrum from interactive command-line control to fully programmatic automation. This doc compares the three and describes when to reach for each one when standing up a small app stack — a resource group, a virtual network, and a couple of compute resources.

The three are not competitors in the usual sense. They are different interfaces to the same underlying Azure Resource Manager (ARM) control plane, and they often appear together in a single workflow. The choice is usually about which interface fits the stage of the workflow you are in.

## When to use which

### Azure CLI — interactive and script-oriented provisioning

Reach for the Azure CLI when you need to provision or inspect resources from a terminal, whether interactively or from a shell script. It is the most direct path from a human intent ("create a resource group here") to an Azure resource. Commands are imperative: you state what you want, and the CLI makes the call. This is the right tool for bootstrapping a subscription, checking what exists, and doing one-off tasks that do not need to repeat reliably.

### Bicep — declarative, repeatable infrastructure

Reach for Bicep when the same set of resources needs to exist in more than one environment or be recreated from scratch. Bicep is a domain-specific language that describes the desired end state of a set of resources. You write what the infrastructure should look like, and the deployment engine figures out how to make it so. This is the right tool when you want idempotent, reviewable, version-controlled infrastructure definitions that can be deployed across development, staging, and production.

### Python SDK — programmatic and embedded automation

Reach for the Python SDK when provisioning needs to live inside a larger Python application or automation pipeline. The SDK gives you fine-grained control over every API call, which is useful when provisioning logic depends on runtime conditions, custom polling, or integration with other Python libraries. It is more verbose than the CLI or Bicep for simple tasks, but it is the right tool when infrastructure decisions are driven by application logic rather than a static file or a single command.

## Steps

The following walks through the same small app stack — a resource group, a virtual network with a subnet, and a virtual machine — using each tool. The goal is to show the shape of each approach rather than to produce production-ready code.

### Step 1: Set up credentials

Before provisioning anything, authenticate with Azure. All three tools use the same underlying identity system, but the setup differs.

- **Azure CLI:** Run `az login` and sign in interactively, or use a service principal for automation.
- **Bicep:** No separate authentication step — Bicep deployments authenticate through the same session or through the deployment context.
- **Python SDK:** Create a credential object in code, typically from environment variables or a managed identity, and pass it to every client constructor.

### Step 2: Create a resource group

A resource group is the logical container for everything in this stack.

- **Azure CLI:** Issue a command to create the resource group in a chosen region.
- **Bicep:** Declare a `resourceGroup`-scoped resource in the template. The deployment creates it as part of the overall run.
- **Python SDK:** Instantiate a `ResourceManagementClient` and call its resource group creation method, passing the location and metadata.

### Step 3: Provision networking

Create a virtual network with a subnet to isolate the app stack.

- **Azure CLI:** Run sequential commands to create the virtual network and then the subnet, referencing the resource group and location.
- **Bicep:** Declare the virtual network and subnet as nested resources within the template, each referencing the resource group.
- **Python SDK:** Use the network client to create the virtual network, then create the subnet within it. Each call returns an object you can inspect before proceeding.

### Step 4: Deploy compute

Add a virtual machine to the subnet.

- **Azure CLI:** Run a command that specifies the VM size, image, network interface, and credentials. The command creates and wires up the resources in one step.
- **Bicep:** Declare the virtual machine, its network interface, and any dependent resources as additional template resources. Deploy the whole template.
- **Python SDK:** Use the compute client to define and create the virtual machine, specifying disk, networking, and OS profile details through method parameters.

### Step 5: Verify the deployment

Confirm the stack exists and is reachable.

- **Azure CLI:** Run a show or list command for each resource type and check that the output reflects the expected properties.
- **Bicep:** The deployment output returns the status of each resource. A successful deployment means all resources are provisioned.
- **Python SDK:** Poll the resource APIs or check the provisioning state on returned objects until each reaches a successful state.

## Verify

To confirm the comparison holds for a small stack, consider which approach handles these scenarios:

| Scenario | Azure CLI | Bicep | Python SDK |
|---|---|---|---|
| Create a resource group in one step | Yes | As part of template deploy | Yes, via client call |
| Re-run and get the same result | Idempotent per command | Idempotent by design | Idempotent with logic |
| See what changed before applying | `--diff` flag on update | `what-if` deployment | Compare before/after state in code |
| Handle a failure mid-deploy | Check exit code and clean up manually | Deployment fails; previous state remains | Handle exception; rollback in code |
| Integrate with non-Azure Python code | Shell out from Python | Not directly | Native integration |

The practical takeaway: start with the Azure CLI to explore and validate. Move to Bicep once the stack shape is stable and needs to repeat. Use the Python SDK when provisioning logic needs to be embedded in application code or when programmatic decision-making is required during deployment.
