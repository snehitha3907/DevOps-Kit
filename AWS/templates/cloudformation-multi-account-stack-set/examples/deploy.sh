# last_verified: 2026-10-07 · AWS CloudFormation · n/a
# Example StackSet operation: create the set, deploy it to two accounts in
# two regions, then show the resulting stacks. Run from a machine with the
# AWS CLI configured as an IAM principal in the management (payer) account
# that has permission to call cloudformation:CreateStackSet and, for each
# target account, cloudformation:CreateStackInstances.

# 1. Create the StackSet itself. The template body is the shared definition;
#    capabilities are IAM because the template creates an IAM group.
aws cloudformation create-stack-set \
  --stack-set-name baseline-multi-account \
  --template-body file://template.yaml \
  --capabilities IAM \
  --parameters ParameterKey=LogBucketName,ParameterValue=baseline-cloudtrail-logs \
                ParameterKey=SNSTopicName,ParameterValue=baseline-notifications

# 2. Deploy the set into two accounts in two regions. Capabilities are
#    repeated per operation because each stack instance needs them.
aws cloudformation create-stack-instances \
  --stack-set-name baseline-multi-account \
  --regions us-east-1 us-west-2 \
  --accounts 111111111111 222222222222 \
  --operation-preferences RegionConcurrencyOrder=us-east-1,us-west-2 \
                          FailureToleranceCount=1 \
                          MaxConcurrentCount=1

# 3. List the stacks the operation created, per account.
aws cloudformation list-stack-instances \
  --stack-set-name baseline-multi-account \
  --query 'Summaries[*].[Account,Region,StackInstanceStatus]'

# 4. Show the outputs of one stack instance.
aws cloudformation describe-stack-instances \
  --stack-set-name baseline-multi-account \
  --stack-instance-accounts 111111111111 \
  --stack-instance-regions us-east-1 \
  --query 'StackInstances[0].StackId'

# 5. Roll the set out to a third account later with the same operation.
aws cloudformation create-stack-instances \
  --stack-set-name baseline-multi-account \
  --regions us-east-1 \
  --accounts 333333333333

# 6. Delete the instance in one account without touching the others.
aws cloudformation delete-stack-instances \
  --stack-set-name baseline-multi-account \
  --regions us-east-1 \
  --accounts 111111111111 \
  --retain-stacks false