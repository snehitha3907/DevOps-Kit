---
last_verified: 2026-11-25
tool_version: Pulumi CLI 3.277.0 · Pulumi Python SDK 3.277.0 · pulumi-awsx 3.15.0 · pulumi-aws 7.55.0
sources:
  - https://pulumi.com/dev/tutorials/aws-vpc/
  - https://github.com/pulumi/pulumi/releases/tag/v3.277.0
  - https://pypi.org/pypi/pulumi/json
  - https://pypi.org/pypi/pulumi-awsx/json
  - https://pypi.org/pypi/pulumi-aws/json
  - https://raw.githubusercontent.com/pulumi/pulumi-awsx/master/awsx/ec2/vpc.ts
  - https://raw.githubusercontent.com/pulumi/pulumi-awsx/master/awsx/schema-types.ts
  - https://raw.githubusercontent.com/pulumi/pulumi-awsx/master/README.md
---

# The network module again, in Pulumi

In the Terraform modules lesson you built a reusable network module — a VPC with public and private subnets — and called it once per environment. This lesson recreates that same network in Pulumi using Python, and shows how Pulumi's `awsx.ec2.Vpc` component packs a VPC, subnets, route tables, NAT gateways and an internet gateway into a single declaration that Terraform would express as dozens of separate `aws_vpc`/`aws_subnet` resources.

## What you'll learn

- Stand up a Pulumi Python project and add the `pulumi-awsx` package.
- Create a VPC with public and private subnets using `awsx.ec2.Vpc` and export its IDs.
- Compare Pulumi's component-based network with Terraform's resource-by-resource network by counting what each one creates.
- Run `pulumi up` to preview and deploy, then `pulumi destroy` to tear it down.

## Before you start

- [Reusable Terraform modules](../06-iac-and-cloud/07-terraform-modules.md) — the network layout (VPC, public/private subnets per environment) you're recreating here, and the module-inputs/outputs pattern this lesson mirrors.
- [OpenTofu — quick primer](../../OpenTofu/notes/0000-primer-opentofu.md) — the init/plan/apply/destroy IaC workflow; Pulumi uses the same plan-then-apply cycle via `pulumi up` and `pulumi destroy`.
- The Pulumi Python project scaffold — see its layout in [Pulumi/templates/pulumi-python-project-scaffold/README.md](../../Pulumi/templates/pulumi-python-project-scaffold/README.md), which shows `Pulumi.yaml`, stack configs, `__init__.py`, and `requirements.txt` together.
- Pulumi CLI installed; confirm with `pulumi version` (expect 3.277.0, released 2026-11-18).
- Python 3.10 or newer; confirm with `python3 --version`.
- AWS credentials configured so Pulumi can create real VPC resources in your account.

## Walkthrough

1. Scaffold a Pulumi Python project.

   Create a folder, then a `Pulumi.yaml` project file:

   ```yaml
   name: pulumi-network
   runtime: python
   description: A VPC with public and private subnets, built with Pulumi and Python
   ```

   Add a stack config for `dev`:

   ```yaml
   config:
     aws:region: us-west-2
   ```

   Create `requirements.txt` declaring the Pulumi SDK, the AWS provider, and the AWSX component library:

   ```
   pulumi
   pulumi-aws==7.55.0
   pulumi-awsx==3.15.0
   ```

   Install the packages:

   ```bash
   pip install -r requirements.txt
   ```

   You should see: `pulumi`, `pulumi-aws`, and `pulumi-awsx` installed without a `ModuleNotFoundError`. (`pulumi-awsx` is not installed by default — the scaffold's `requirements.txt` only declares `pulumi` and `pulumi-aws`, so you must add it yourself.) [source: https://raw.githubusercontent.com/pulumi/pulumi-awsx/master/README.md]

2. Write the network program.

   Create `__main__.py` and declare the VPC with the `awsx.ec2.Vpc` component:

   ```python
   import pulumi
   import pulumi_aws as aws
   import pulumi_awsx as awsx

   # One component provisions a VPC, public and private subnets in the first
   # three availability zones, route tables, NAT gateways, and an internet
   # gateway — everything a Terraform network would declare resource by resource.
   vpc = awsx.ec2.Vpc("app-vpc")

   # Hand the real, assigned values back to the stack.
   pulumi.export("vpc_id", vpc.vpc_id)
   pulumi.export("public_subnet_ids", vpc.public_subnet_ids)
   pulumi.export("private_subnet_ids", vpc.private_subnet_ids)
   ```

   You should see: a `__main__.py` that declares one `awsx.ec2.Vpc` and exports `vpc_id`, `public_subnet_ids`, and `private_subnet_ids`.

   The component defaults to CIDR `10.0.0.0/16`, the first three availability zones, one public and one private subnet per AZ, one NAT gateway plus an Elastic IP per public subnet, and one internet gateway [source: https://pulumi.com/dev/tutorials/aws-vpc/]. Its configurable fields include `cidrBlock`, `numberOfAvailabilityZones`, `availabilityZoneNames`, `subnetSpecs`, `natGateways`, `tags`, and `subnetStrategy` [source: https://raw.githubusercontent.com/pulumi/pulumi-awsx/master/awsx/schema-types.ts]. Never pass both `availabilityZoneNames` and `numberOfAvailabilityZones` — only one is allowed [source: https://raw.githubusercontent.com/pulumi/pulumi-awsx/master/awsx/ec2/vpc.ts].

3. Preview and deploy.

   Initialize the stack and run Pulumi:

   ```bash
   pulumi stack init dev
   pulumi up
   ```

   You should see: `pulumi up` previews the resources to create (a default `awsx.ec2.Vpc` provisions about 34 underlying resources) and, after you confirm, creates them. Expect the first `pulumi up` of a new VPC to take 2–3 minutes, largely because of NAT gateway creation [source: https://pulumi.com/dev/tutorials/aws-vpc/].

   In Terraform you would declare each of those ~34 resources explicitly — `aws_vpc`, `aws_subnet`, `aws_internet_gateway`, `aws_nat_gateway`, `aws_route_table`, `aws_eip`, and more — each with its own `resource` block. Pulumi hides that boilerplate behind the `awsx.ec2.Vpc` component; Terraform requires the explicit declarations [source: https://pulumi.com/dev/tutorials/aws-vpc/ ; https://raw.githubusercontent.com/pulumi/pulumi-awsx/master/awsx/ec2/vpc.ts].

4. Read the outputs and clean up.

   ```bash
   pulumi stack output vpc_id
   pulumi stack output public_subnet_ids
   pulumi stack output private_subnet_ids
   ```

   Then destroy everything so you don't leave running NAT gateways (which accrue charges) in your account:

   ```bash
   pulumi destroy
   ```

   You should see: the three exports return real AWS IDs, and `pulumi destroy` removes every resource the component created.

## Exercise

On your own, resize the network and compare it with Terraform:

1. Edit `__main__.py`: change the VPC to use only two availability zones (`number_of_availability_zones=2`) and add tags (`tags={"Environment": "dev", "ManagedBy": "pulumi"}`).
2. Run `pulumi up` and confirm the plan shows two public and two private subnets with the tags applied.
3. Run `pulumi stack output vpc_id public_subnet_ids private_subnet_ids` and record the values.
4. Now write the Terraform equivalent for a two-AZ VPC: list the `resource` blocks you would need (`aws_vpc`, two `aws_subnet` for public, two `aws_subnet` for private, `aws_internet_gateway`, `aws_route_table`, `aws_route_table_association`…). Count them.
5. Compare: one `awsx.ec2.Vpc` call in Pulumi versus your list of explicit Terraform `resource` blocks.

Do not paste the run output inline — run the commands yourself and record the result.

## Check your work

- `pip install -r requirements.txt` exits 0 and installs `pulumi`, `pulumi-aws`, and `pulumi-awsx`.
- `pulumi up` completes without errors and creates the VPC and subnets.
- `pulumi stack output vpc_id` returns a real VPC ID; `public_subnet_ids` and `private_subnet_ids` each return two subnet IDs after your Exercise change.
- Your Terraform equivalent lists multiple explicit `resource` blocks where Pulumi used a single `awsx.ec2.Vpc` component.

## Common mistakes

- Passing both `availabilityZoneNames` and `numberOfAvailabilityZones` to `awsx.ec2.Vpc` — the component rejects it ("Only one of [availabilityZoneNames] and [numberOfAvailabilityZones] can be specified"); pick one [source: https://raw.githubusercontent.com/pulumi/pulumi-awsx/master/awsx/ec2/vpc.ts].
- Forgetting `pulumi-awsx` in `requirements.txt` — you get `ModuleNotFoundError: No module named 'pulumi_awsx'`; add it and run `pip install -r requirements.txt` [source: https://raw.githubusercontent.com/pulumi/pulumi-awsx/master/README.md].
- The AWS provider plugin missing — `pulumi up` fails with "No plugin found for package aws"; run `pulumi plugin install resource aws 7.55.0` (or let the CLI auto-install on first run) [source: https://pypi.org/pypi/pulumi/json].
- Not pinning the AWS Classic Provider version — pin it explicitly with `pulumi.ResourceOptions(version="7.55.0")` on a custom `aws.Provider` and pass it to the component via `opts=pulumi.ResourceOptions(providers={"aws": awsp})` to avoid version-drift warnings [source: https://raw.githubusercontent.com/pulumi/pulumi-awsx/master/README.md].

## Next

[The GitOps setup again, with Flux](../../00_index/learning-path.md)
