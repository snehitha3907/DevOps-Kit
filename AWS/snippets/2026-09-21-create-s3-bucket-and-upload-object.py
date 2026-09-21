#!/usr/bin/env python3
# last_verified: 2026-09-21 · AWS boto3 n/a
# I wanted one small Python example that creates a bucket, then uploads a file.
# The region handling is explicit because the first S3 region is a special case.

import argparse
from pathlib import Path

import boto3
from botocore.exceptions import ClientError


def create_bucket(s3, bucket, region):
    options = {"Bucket": bucket}
    if region != "us-east-1":
        options["CreateBucketConfiguration"] = {"LocationConstraint": region}
    s3.create_bucket(**options)


def main():
    parser = argparse.ArgumentParser(description="Create an S3 bucket and upload one object.")
    parser.add_argument("bucket", help="Globally unique bucket name")
    parser.add_argument("source", type=Path, help="Local file to upload")
    parser.add_argument("--region", default="us-east-1", help="Bucket region")
    parser.add_argument("--key", help="Object key; defaults to the source filename")
    args = parser.parse_args()

    if not args.source.is_file():
        raise SystemExit(f"File not found: {args.source}")

    s3 = boto3.client("s3", region_name=args.region)
    try:
        create_bucket(s3, args.bucket, args.region)
    except ClientError as error:
        code = error.response.get("Error", {}).get("Code", "")
        if code not in {"BucketAlreadyExists", "BucketAlreadyOwnedByYou"}:
            raise

    key = args.key or args.source.name
    s3.upload_file(str(args.source), args.bucket, key)
    print(f"Uploaded {args.source} to s3://{args.bucket}/{key}")


if __name__ == "__main__":
    main()
