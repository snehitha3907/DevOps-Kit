package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestModuleBasic(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/basic",
		Vars: map[string]interface{}{
			"aws_region":   "us-east-1",
			"environment":  "test",
			"owner":        "test-team",
			"module_name":  "test-artifact",
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	bucketName := terraform.Output(t, terraformOptions, "bucket_name")
	assert.NotEmpty(t, bucketName)

	bucketArn := terraform.Output(t, terraformOptions, "bucket_arn")
	assert.NotEmpty(t, bucketArn)
	assert.Contains(t, bucketArn, "arn:aws:s3:::")
}