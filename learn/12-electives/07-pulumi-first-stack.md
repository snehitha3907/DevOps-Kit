---
last_verified: 2026-11-26
tool_version: 3.277.0
sources:
  - https://github.com/pulumi/pulumi/releases/tag/v3.277.0
  - https://www.pulumi.com/docs/iac/languages-sdks/python/
---

# The network module again, in Pulumi

In [Reusable Terraform modules](../06-iac-and-cloud/07-terraform-modules.md) you turned a small network into a reusable module of `local_file` resources and called it once for dev and once for prod. This lesson recreates that same network as a Pulumi program in Python, so you can compare Pulumi's general-purpose-language approach with the declarative HCL you wrote there — same resources, same outputs, different authoring model.

## What you'll learn

- Bootstrap a Pulumi Python project with `pulumi new python` and read the files it creates.
- Declare VPC and subnet resources in `__main__.py` with `pulumi_aws`, wiring one resource to another with `.id`.
- Preview, apply, and tear down a stack with `pulumi preview`, `pulumi up`, and `pulumi destroy`, and export values with `pulumi.export`.
- Compare Pulumi's Python program model with the Terraform module from the previous lesson.

## Before you start

- [Reusable Terraform modules](../06-iac-and-cloud/07-terraform-modules.md) — the network (VPC plus public and private subnets) you are recreating; you need its variable and output shape.
- Pulumi CLI installed; confirm with `pulumi version` (this lesson targets 3.277.0).
- Python 3 installed; confirm with `python3 --version`.
- AWS credentials configured if you deploy the real resources below; confirm with `aws sts get-caller-identity`. If you have no AWS account, you can still run `pulumi preview`, which plans without creating anything.
- Companion scaffold you can copy instead of bootstrapping from scratch: [Pulumi Python project scaffold](../../Pulumi/templates/pulumi-python-project-scaffold/README.md).

## Walkthrough

1. Bootstrap a new project.

   Create a directory and run the Python template:

   ```bash
   mkdir pulumi-network && cd pulumi-network
   pulumi new python
   ```

   Accept the defaults for project name and stack name. Pulumi scaffolds the project and installs dependencies.

   You should see: `Your new project is ready to go!` and three files appear — `Pulumi.yaml`, `__main__.py`, and `requirements.txt`.

2. Read what the bootstrap created.

   `Pulumi.yaml` declares the project name and the `python` runtime. `requirements.txt` pins `pulumi` and `pulumi-aws`. `__main__.py` is the program Pulumi runs; the starter version creates one S3 bucket, which you will replace.

   You should see: `Pulumi.yaml` contains `runtime: python`.

3. Configure the AWS region for the stack.

   ```bash
   pulumi config set aws:region us-west-2
   ```

   This writes the value into `Pulumi.dev.yaml` so the program can read it at run time.

   You should see: `Config key 'aws:region' set to 'us-west-2'`.

4. Replace `__main__.py` with the network.

   ```python
   import pulumi
   import pulumi_aws as aws

   # VPC
   vpc = aws.ec2.Vpc(
       "network-vpc",
       cidr_block="10.0.0.0/16",
       tags={"Name": "pulumi-network-vpc"},
   )

   # Public subnet — vpc_id takes the VPC's .id (an Output[str]), not the object.
   public_subnet = aws.ec2.Subnet(
       "network-public-subnet",
       vpc_id=vpc.id,
       cidr_block="10.0.1.0/24",
       map_public_ip_on_launch=True,
       tags={"Name": "pulumi-network-public"},
   )

   # Private subnet.
   private_subnet = aws.ec2.Subnet(
       "network-private-subnet",
       vpc_id=vpc.id,
       cidr_block="10.0.2.0/24",
       tags={"Name": "pulumi-network-private"},
   )

   pulumi.export("vpc_id", vpc.id)
   pulumi.export("public_subnet_id", public_subnet.id)
   pulumi.export("private_subnet_id", private_subnet.id)
   ```

   The key detail: `vpc_id=vpc.id` passes the VPC's assigned ID, while `parent` and `depends_on` take the resource object itself. Mixing the two forms is the most common type error.

   You should see: three resources declared and three `pulumi.export` calls.

5. Preview the change.

   ```bash
   pulumi preview
   ```

   Pulumi runs the Python program, builds the dependency graph, and shows the plan without touching AWS.

   You should see: `3 to create` (one VPC and two subnets) and no errors.

6. Apply the stack.

   ```bash
   pulumi up
   ```

   Review the preview, then confirm. Pulumi creates the resources and records them in state.

   You should see: `3 created` and the three exported outputs printed at the end.
7. Read back an exported value.

   ```bash
   pulumi stack output vpc_id
   ```

   You should see: a VPC ID such as `vpc-0123456789abcdef0`.

8. Tear down when you are done.

   ```bash
   pulumi destroy
   pulumi stack rm dev
   ```

   `destroy` removes the cloud resources; `stack rm` removes the stack's state history. Run both so you do not leave resources or state behind.

   You should see: `3 destroyed` and the stack removed.

## Exercise

On your own, make the program reusable the way the Terraform module was:

1. Wrap the three resources in a Python function `make_network(name_prefix, vpc_cidr)` that declares a VPC plus public and private subnets and returns their IDs.
2. Call it twice in the same program — once for `dev` and once for `prod` — and export both sets of IDs.
3. Run `pulumi preview` and confirm it plans 6 resources (two VPCs, four subnets) with no errors.

No solution is provided — write the code yourself and verify with the check below.

## Check your work

- `pulumi preview` reports 6 resources to create and no errors.
- `pulumi up` succeeds and `pulumi stack output` lists both dev and prod VPC and subnet IDs.
- `pulumi destroy` removes all 6 resources.

## Common mistakes

- Running `pulumi` commands outside the directory containing `Pulumi.yaml` — you get `no Pulumi.yaml project file found`.
- Passing the resource object to `vpc_id` instead of `vpc.id` — a type error at preview time.
- Forgetting `pulumi.export` — the values are created but never surfaced to `pulumi stack output`.
- Leaving a stack and its resources after experimenting — run `pulumi destroy` and `pulumi stack rm` to clean up.

## Next

[The GitOps setup again, with Flux](./08-flux-gitops-alternative.md)
