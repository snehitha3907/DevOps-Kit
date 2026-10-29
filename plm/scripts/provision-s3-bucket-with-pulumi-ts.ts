# last_verified: 2026-10-29 · pulumi n/a
# I wrote the smallest Pulumi TypeScript program that provisions a real AWS
# S3 bucket. This is the deployable version of the one-bucket example in the
# primer; the snippet in snippets/ was the first scratch, this one is meant to
# be run with `pulumi up`. TODO: wire the bucket name in from stack config
# instead of hard-coding it so dev and prod stacks stay apart.
import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";

// One bucket. Bucket names are globally unique, so pick a name that will not
// collide with another account's bucket if this stack is ever reused.
const bucket = new aws.s3.Bucket("my-first-pulumi-bucket", {
  // Default is private; leaving ACL unset keeps the bucket private by default
  // and forces me to add a policy explicitly if I ever want public read.
  acl: "private",
  // Server-side encryption with an AWS-managed key; cheap and automatic.
  serverSideEncryptionConfiguration: {
    rule: {
      applyServerSideEncryptionByDefault: {
        sseAlgorithm: "aws:kms",
      },
    },
  },
  // Block all public access at the bucket level so an accidental policy
  // cannot open the bucket to the world.
  blockPublicAcls: true,
  blockPublicPolicy: true,
  ignorePublicAcls: true,
  restrictPublicBuckets: true,
});

// Hand the real, assigned name and ARN back to the stack so another resource
// (or an app config) can reference them without guessing.
pulumi.export("bucket_name", bucket.id);
pulumi.export("bucket_arn", bucket.arn);
pulumi.export("bucket_regional_domain_name", bucket.bucketRegionalDomainName);