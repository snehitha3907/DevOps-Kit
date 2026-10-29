// last_verified: 2026-10-29 · pulumi n/a
// The program: declare one S3 bucket and hand its real name and ARN back to
// the stack. The bucket name comes from stack config so dev and prod stacks
// get distinct buckets without changing the code.
import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";

// Read the bucket name from stack config. The key is namespaced under `s3:`
// so it does not collide with other namespaces; if it is missing the preview
// fails loudly instead of silently picking a name.
const cfg = new pulumi.Config();
const bucketName = cfg.require("s3:bucket-name");

const bucket = new aws.s3.Bucket(bucketName, {
  acl: "private",
  serverSideEncryptionConfiguration: {
    rule: {
      applyServerSideEncryptionByDefault: {
        sseAlgorithm: "aws:kms",
      },
    },
  },
  blockPublicAcls: true,
  blockPublicPolicy: true,
  ignorePublicAcls: true,
  restrictPublicBuckets: true,
});

pulumi.export("bucket_name", bucket.id);
pulumi.export("bucket_arn", bucket.arn);
pulumi.export("bucket_regional_domain_name", bucket.bucketRegionalDomainName);