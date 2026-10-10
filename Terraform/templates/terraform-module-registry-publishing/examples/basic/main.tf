module "artifact_bucket" {
  source  = "../../"
  version = "1.0.0"

  aws_region   = "us-east-1"
  environment  = "dev"
  owner        = "platform-team"
  module_name  = "artifact-store"
}

output "bucket_name" {
  value = module.artifact_bucket.module_artifacts_bucket_name
}