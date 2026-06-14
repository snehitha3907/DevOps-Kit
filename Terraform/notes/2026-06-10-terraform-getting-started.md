# Terraform getting-started tutorial

I followed the official HashiCorp Learn tutorial — "Get Started with Terraform" using the Docker provider. No cloud account needed, which was nice.

## Following along

I created a working directory and a `main.tf` with the Docker provider block and an `nginx` container resource:

```hcl
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "tutorial"
  ports {
    internal = 80
    external = 8080
  }
}
```

Then ran:

```
terraform init
terraform plan
terraform apply -auto-approve
```

It pulled the nginx image and started a container. `curl localhost:8080` returned the nginx welcome page. That worked first try.

## Modifying infrastructure

The tutorial had me change the container name and re-apply. Terraform detected the change and replaced the container. I could see `docker ps` showing the new name. The plan output showed `~` for the name attribute — a change in-place or destroy-and-recreate depending on the attribute.

## Destroying

`terraform destroy -auto-approve` removed the container. The image stayed because of `keep_locally = true`. Clean exit.

## Got stuck on

- The Docker provider isn't from HashiCorp — it's from kreuzwerker (community). The tutorial doesn't flag this clearly. I figured it out when `terraform init` listed the registry source.
- `terraform fmt` rewrote my file. I didn't run it at first, so the indentation was a mess. Running it afterward made the file look consistent.
- The `docker` provider requires the Docker daemon to be running. If Docker isn't installed or the socket isn't accessible, `terraform apply` fails with a connection error. The tutorial assumes you already have Docker.
- I forgot `keep_locally = true` the first time. On destroy it removed the image too. Added it back on the second pass.

## What I'd try next

I want to try variables and outputs next — parameterizing the image name and printing the container's IP after apply. The tutorial covers that in a later section.
