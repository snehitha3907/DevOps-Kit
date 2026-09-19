# last_verified: 2026-09-19 · terraform n/a
# First try at two providers: random_pet makes a unique suffix, local_file writes it to disk.
# Not applied yet (no terraform binary here) — plan: save as .tf, then init, apply, look for hello-<words>.txt.
terraform {
  required_providers {
    local  = { source = "hashicorp/local" }
    random = { source = "hashicorp/random" }
  }
}
resource "random_pet" "suffix" { length = 2 } # TODO: try length = 3 and see what changes
resource "local_file" "hello" {
  content  = "hello-${random_pet.suffix.id}\n"
  filename = "${path.module}/hello-${random_pet.suffix.id}.txt"
}
