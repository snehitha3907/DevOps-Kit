#!/usr/bin/env python3
# last_verified: 2026-10-07 · AWS n/a
# CDK Python stack: VPC with isolated workload subnets and private endpoints
# so in-VPC traffic to AWS services stays off the public internet.
# Usage:
#   pip install aws-cdk-lib constructs
#   cdk synth --context env_name=dev
#   cdk deploy --context env_name=dev

import ipaddress

from aws_cdk import App, CfnOutput, RemovalPolicy, Stack, StackProps
from aws_cdk import aws_ec2 as ec2
from constructs import Construct


ALLOWED_ENVS = ("dev", "staging", "prod")

ENV_CONFIG = {
    "dev": {"cidr": "10.20.0.0/16", "max_azs": 2, "nat_gateways": 1},
    "staging": {"cidr": "10.30.0.0/16", "max_azs": 2, "nat_gateways": 1},
    "prod": {"cidr": "10.40.0.0/16", "max_azs": 3, "nat_gateways": 2},
}

# Gateway endpoints (S3, DynamoDB) are free and route via the route table.
GATEWAY_ENDPOINTS = {
    "s3": ec2.GatewayVpcEndpointAwsService.S3,
    "dynamodb": ec2.GatewayVpcEndpointAwsService.DYNAMODB,
}

# Interface endpoints kept to the small set most private workloads need.
# Each one provisions an ENI per AZ, so keep the list short.
INTERFACE_ENDPOINTS = {
    "ecr-api": ec2.InterfaceVpcEndpointAwsService.ECR,
    "ecr-docker": ec2.InterfaceVpcEndpointAwsService.ECR_DOCKER,
    "cloudwatch-logs": ec2.InterfaceVpcEndpointAwsService.CLOUDWATCH_LOGS,
    "ssm": ec2.InterfaceVpcEndpointAwsService.SSM,
}


def resolve_env(app: App) -> str:
    env_name = app.node.try_get_context("env_name") or "dev"
    if env_name not in ALLOWED_ENVS:
        raise ValueError(
            f"Unknown env_name={env_name!r}. Expected one of {ALLOWED_ENVS}."
        )
    return env_name


def validate_cidr(cidr: str) -> None:
    try:
        network = ipaddress.ip_network(cidr, strict=True)
    except ValueError as exc:
        raise ValueError(f"Invalid VPC CIDR {cidr!r}: {exc}") from exc
    if network.prefixlen > 20:
        raise ValueError(
            f"VPC CIDR {cidr!r} is smaller than /20; "
            "public/private/isolated subnets across AZs will not fit."
        )


class VpcWithPrivateEndpointsStack(Stack):
    def __init__(self, scope: Construct, construct_id: str, env_name: str, **kwargs: StackProps) -> None:
        super().__init__(scope, construct_id, **kwargs)

        config = ENV_CONFIG[env_name]
        validate_cidr(config["cidr"])

        self.vpc = ec2.Vpc(
            self,
            "WorkloadVpc",
            ip_addresses=ec2.IpAddresses.cidr(config["cidr"]),
            max_azs=config["max_azs"],
            nat_gateways=config["nat_gateways"],
            subnet_configuration=[
                ec2.SubnetConfiguration(
                    name="public", subnet_type=ec2.SubnetType.PUBLIC, cidr_mask=24
                ),
                ec2.SubnetConfiguration(
                    name="private", subnet_type=ec2.SubnetType.PRIVATE_WITH_EGRESS, cidr_mask=24
                ),
                ec2.SubnetConfiguration(
                    name="isolated", subnet_type=ec2.SubnetType.PRIVATE_ISOLATED, cidr_mask=24
                ),
            ],
            enable_dns_hostnames=True,
            enable_dns_support=True,
        )

        for name, service in GATEWAY_ENDPOINTS.items():
            self.vpc.add_gateway_endpoint(name, service=service)

        endpoint_sg = ec2.SecurityGroup(
            self,
            "EndpointSecurityGroup",
            vpc=self.vpc,
            description="Allow TLS from the VPC to interface endpoints",
            allow_all_outbound=False,
        )
        endpoint_sg.add_ingress_rule(
            peer=ec2.Peer.ipv4(config["cidr"]),
            connection=ec2.Port.tcp(443),
            description="HTTPS from workloads to endpoints",
        )

        for name, service in INTERFACE_ENDPOINTS.items():
            self.vpc.add_interface_endpoint(
                name,
                service=service,
                subnets=ec2.SubnetSelection(
                    subnet_type=ec2.SubnetType.PRIVATE_WITH_EGRESS
                ),
                security_groups=[endpoint_sg],
                private_dns_enabled=True,
            )

        if env_name == "prod":
            for subnet in self.vpc.isolated_subnets:
                CfnOutput(self, f"IsolatedSubnet-{subnet.availability_zone}", value=subnet.subnet_id)

        CfnOutput(self, "VpcId", value=self.vpc.vpc_id)
        CfnOutput(self, "PrivateEndpointSecurityGroup", value=endpoint_sg.security_group_id)

        self.apply_removal_policy(env_name)

    def apply_removal_policy(self, env_name: str) -> None:
        policy = RemovalPolicy.RETAIN if env_name == "prod" else RemovalPolicy.DESTROY
        for child in self.node.find_all():
            if isinstance(child, (ec2.CfnVPC, ec2.CfnSubnet, ec2.CfnRouteTable)):
                child.apply_removal_policy(policy)


def main() -> None:
    app = App()
    env_name = resolve_env(app)
    VpcWithPrivateEndpointsStack(
        app,
        f"vpc-private-endpoints-{env_name}",
        env_name=env_name,
        description=f"VPC with private endpoints ({env_name})",
    )
    app.synth()


if __name__ == "__main__":
    main()
