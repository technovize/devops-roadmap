package test

import (
    "testing"
    "github.com/gruntwork-io/terratest/modules/aws"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestVPCModule(t *testing.T) {
    t.Parallel()

    terraformOptions := &terraform.Options{
        TerraformDir: "../modules/vpc",
        Vars: map[string]interface{}{
            "project_name": "test",
            "environment":  "test",
            "vpc_cidr":     "10.99.0.0/16",
            "az_count":     2,
        },
    }

    // Destroy infrastructure after test (even on failure)
    defer terraform.Destroy(t, terraformOptions)

    // Init and apply the Terraform module
    terraform.InitAndApply(t, terraformOptions)

    // Get outputs
    vpcId          := terraform.Output(t, terraformOptions, "vpc_id")
    publicSubnets  := terraform.OutputList(t, terraformOptions, "public_subnet_ids")
    privateSubnets := terraform.OutputList(t, terraformOptions, "private_subnet_ids")

    // Assertions
    assert.NotEmpty(t, vpcId)
    assert.Len(t, publicSubnets, 2)
    assert.Len(t, privateSubnets, 2)

    // Verify VPC exists in AWS
    vpc := aws.GetVpcById(t, vpcId, "us-east-1")
    assert.Equal(t, "10.99.0.0/16", aws.GetCidrBlockAssociatedWithVpc(t, vpc))
    assert.True(t, aws.IsDnsHostnamesEnabledForVpc(t, vpc))
}
