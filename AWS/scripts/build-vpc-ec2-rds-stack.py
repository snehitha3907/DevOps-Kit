#!/usr/bin/env python3
# last_verified: 2026-09-22 · AWS boto3 n/a
# Builds a minimal end-to-end AWS stack: VPC with public/private subnets,
# EC2 instance in private subnet accessible via SSM, and RDS instance with security group.

import argparse
import logging
import sys
import time
from typing import Optional

import boto3
from botocore.exceptions import ClientError, NoRegionError, NoCredentialsError

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(name)s: %(message)s",
)
logger = logging.getLogger(__name__)
logging.getLogger("botocore").setLevel(logging.WARNING)
logging.getLogger("boto3").setLevel(logging.WARNING)


class StackBuilder:
    def __init__(self, profile: str, region: str):
        self.profile = profile
        self.region = region
        self.session = boto3.Session(profile_name=profile, region_name=region)
        self.ec2 = self.session.client("ec2")
        self.rds = self.session.client("rds")
        self.ssm = self.session.client("ssm")
        self.sts = self.session.client("sts")
        self.vpc_id: Optional[str] = None
        self.public_subnet_id: Optional[str] = None
        self.private_subnet_id: Optional[str] = None
        self.ec2_instance_id: Optional[str] = None
        self.db_instance_id: Optional[str] = None
        self.security_group_id: Optional[str] = None

    def verify_identity(self) -> None:
        try:
            identity = self.sts.get_caller_identity()
            logger.info(
                "Authenticated as account=%s arn=%s",
                identity["Account"],
                identity["Arn"],
            )
        except (NoCredentialsError, ClientError) as e:
            logger.error("Credential check failed: %s", e)
            raise SystemExit("Cannot verify AWS identity. Check profile and region.") from e

    def create_vpc(self, cidr: str = "10.0.0.0/16") -> str:
        logger.info("Creating VPC with CIDR %s", cidr)
        response = self.ec2.create_vpc(CidrBlock=cidr)
        vpc_id = response["Vpc"]["VpcId"]
        self.ec2.get_waiter("vpc_available").wait(VpcIds=[vpc_id])
        self.ec2.modify_vpc_attribute(VpcId=vpc_id, EnableDnsHostnames={"Value": True})
        self.ec2.modify_vpc_attribute(VpcId=vpc_id, EnableDnsSupport={"Value": True})
        self.ec2.create_tags(Resources=[vpc_id], Tags=[{"Key": "Name", "Value": "lab-vpc"}])
        logger.info("Created VPC: %s", vpc_id)
        return vpc_id

    def create_subnets(self, vpc_id: str) -> tuple[str, str]:
        logger.info("Creating public and private subnets")
        public = self.ec2.create_subnet(
            VpcId=vpc_id,
            CidrBlock="10.0.1.0/24",
            AvailabilityZone=f"{self.region}a",
        )
        public_id = public["Subnet"]["SubnetId"]
        self.ec2.modify_subnet_attribute(SubnetId=public_id, MapPublicIpOnLaunch={"Value": True})
        self.ec2.create_tags(
            Resources=[public_id], Tags=[{"Key": "Name", "Value": "lab-public-subnet"}]
        )

        private = self.ec2.create_subnet(
            VpcId=vpc_id,
            CidrBlock="10.0.2.0/24",
            AvailabilityZone=f"{self.region}a",
        )
        private_id = private["Subnet"]["SubnetId"]
        self.ec2.create_tags(
            Resources=[private_id], Tags=[{"Key": "Name", "Value": "lab-private-subnet"}]
        )

        logger.info("Created subnets: public=%s private=%s", public_id, private_id)
        return public_id, private_id

    def create_internet_gateway_and_routes(self, vpc_id: str, public_subnet_id: str) -> None:
        logger.info("Creating internet gateway and public route")
        igw = self.ec2.create_internet_gateway()
        igw_id = igw["InternetGateway"]["InternetGatewayId"]
        self.ec2.attach_internet_gateway(InternetGatewayId=igw_id, VpcId=vpc_id)
        self.ec2.create_tags(Resources=[igw_id], Tags=[{"Key": "Name", "Value": "lab-igw"}])

        rt = self.ec2.create_route_table(VpcId=vpc_id)
        rt_id = rt["RouteTable"]["RouteTableId"]
        self.ec2.create_route(
            RouteTableId=rt_id, DestinationCidrBlock="0.0.0.0/0", GatewayId=igw_id
        )
        self.ec2.associate_route_table(RouteTableId=rt_id, SubnetId=public_subnet_id)
        self.ec2.create_tags(Resources=[rt_id], Tags=[{"Key": "Name", "Value": "lab-public-rt"}])
        logger.info("Internet gateway and public route configured")

    def create_nat_gateway(self, vpc_id: str, public_subnet_id: str) -> str:
        logger.info("Creating NAT gateway for private subnet egress")
        eip = self.ec2.allocate_address(Domain="vpc")
        eip_id = eip["AllocationId"]
        nat = self.ec2.create_nat_gateway(
            AllocationId=eip_id, SubnetId=public_subnet_id, ConnectivityType="public"
        )
        nat_id = nat["NatGateway"]["NatGatewayId"]
        self.ec2.get_waiter("nat_gateway_available").wait(NatGatewayIds=[nat_id])
        self.ec2.create_tags(Resources=[nat_id], Tags=[{"Key": "Name", "Value": "lab-nat"}])

        rt = self.ec2.create_route_table(VpcId=vpc_id)
        rt_id = rt["RouteTable"]["RouteTableId"]
        self.ec2.create_route(
            RouteTableId=rt_id, DestinationCidrBlock="0.0.0.0/0", NatGatewayId=nat_id
        )
        self.ec2.associate_route_table(RouteTableId=rt_id, SubnetId=self.private_subnet_id)
        self.ec2.create_tags(Resources=[rt_id], Tags=[{"Key": "Name", "Value": "lab-private-rt"}])
        logger.info("NAT gateway and private route configured: %s", nat_id)
        return nat_id

    def create_security_group(self, vpc_id: str) -> str:
        logger.info("Creating security group for EC2 and RDS")
        sg = self.ec2.create_security_group(
            GroupName="lab-sg", Description="Lab security group for EC2 and RDS", VpcId=vpc_id
        )
        sg_id = sg["GroupId"]
        self.ec2.authorize_security_group_ingress(
            GroupId=sg_id,
            IpPermissions=[
                {
                    "IpProtocol": "tcp",
                    "FromPort": 3306,
                    "ToPort": 3306,
                    "UserIdGroupPairs": [{"GroupId": sg_id}],
                }
            ],
        )
        self.ec2.create_tags(Resources=[sg_id], Tags=[{"Key": "Name", "Value": "lab-sg"}])
        logger.info("Created security group: %s", sg_id)
        return sg_id

    def create_ec2_instance(self, subnet_id: str, sg_id: str, key_name: Optional[str] = None) -> str:
        logger.info("Creating EC2 instance in private subnet via SSM")
        images = self.ec2.describe_images(
            Owners=["amazon"],
            Filters=[
                {"Name": "name", "Values": ["amzn2-ami-hvm-*-x86_64-gp2"]},
                {"Name": "state", "Values": ["available"]},
            ],
        )
        image_id = sorted(images["Images"], key=lambda x: x["CreationDate"], reverse=True)[0][
            "ImageId"
        ]
        logger.info("Using AMI: %s", image_id)

        iam_profile = self._ensure_ssm_instance_profile()

        run_args = {
            "ImageId": image_id,
            "InstanceType": "t3.micro",
            "SubnetId": subnet_id,
            "SecurityGroupIds": [sg_id],
            "MinCount": 1,
            "MaxCount": 1,
            "IamInstanceProfile": {"Name": iam_profile},
            "TagSpecifications": [
                {
                    "ResourceType": "instance",
                    "Tags": [{"Key": "Name", "Value": "lab-ec2-private"}],
                }
            ],
        }
        if key_name:
            run_args["KeyName"] = key_name

        response = self.ec2.run_instances(**run_args)
        instance_id = response["Instances"][0]["InstanceId"]
        self.ec2.get_waiter("instance_running").wait(InstanceIds=[instance_id])
        logger.info("Created EC2 instance: %s", instance_id)
        return instance_id

    def _ensure_ssm_instance_profile(self) -> str:
        iam = self.session.client("iam")
        profile_name = "LabSSMInstanceProfile"
        role_name = "LabSSMRole"
        try:
            iam.get_instance_profile(InstanceProfileName=profile_name)
            logger.info("SSM instance profile already exists: %s", profile_name)
        except ClientError as e:
            if e.response["Error"]["Code"] == "NoSuchEntity":
                logger.info("Creating SSM instance profile and role")
                assume_role_policy = {
                    "Version": "2012-10-17",
                    "Statement": [
                        {
                            "Effect": "Allow",
                            "Principal": {"Service": "ec2.amazonaws.com"},
                            "Action": "sts:AssumeRole",
                        }
                    ],
                }
                iam.create_role(
                    RoleName=role_name,
                    AssumeRolePolicyDocument=str(assume_role_policy).replace("'", '"'),
                )
                iam.attach_role_policy(
                    RoleName=role_name,
                    PolicyArn="arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
                )
                iam.create_instance_profile(InstanceProfileName=profile_name)
                iam.add_role_to_instance_profile(
                    InstanceProfileName=profile_name, RoleName=role_name
                )
                time.sleep(10)
            else:
                raise
        return profile_name

    def create_rds_instance(
        self, subnet_id: str, sg_id: str, db_name: str = "labdb"
    ) -> str:
        logger.info("Creating RDS instance in private subnet")
        subnet_group = self.rds.create_db_subnet_group(
            DBSubnetGroupName="lab-subnet-group",
            DBSubnetGroupDescription="Lab subnet group for RDS",
            SubnetIds=[subnet_id],
        )
        logger.info("Created DB subnet group: %s", subnet_group["DBSubnetGroup"]["DBSubnetGroupName"])

        instance_id = "lab-db-instance"
        try:
            self.rds.create_db_instance(
                DBInstanceIdentifier=instance_id,
                DBInstanceClass="db.t3.micro",
                Engine="postgres",
                EngineVersion="16.3",
                AllocatedStorage=20,
                DBName=db_name,
                MasterUsername="admin",
                MasterUserPassword="TempPass123!",
                VpcSecurityGroupIds=[sg_id],
                DBSubnetGroupName="lab-subnet-group",
                PubliclyAccessible=False,
                DeletionProtection=False,
                BackupRetentionPeriod=0,
                Tags=[{"Key": "Name", "Value": "lab-rds"}],
            )
            logger.info("RDS instance creation initiated: %s", instance_id)
            self.rds.get_waiter("db_instance_available").wait(
                DBInstanceIdentifier=instance_id, WaiterConfig={"Delay": 30, "MaxAttempts": 40}
            )
        except ClientError as e:
            if e.response["Error"]["Code"] == "DBInstanceAlreadyExists":
                logger.info("RDS instance already exists: %s", instance_id)
            else:
                raise
        return instance_id

    def verify_stack(self) -> None:
        logger.info("Verifying stack components")
        self.ec2.describe_vpcs(VpcIds=[self.vpc_id])
        self.ec2.describe_subnets(SubnetIds=[self.public_subnet_id, self.private_subnet_id])
        self.ec2.describe_instances(InstanceIds=[self.ec2_instance_id])
        self.rds.describe_db_instances(DBInstanceIdentifier=self.db_instance_id)
        logger.info("All resources verified successfully")

    def build(self, key_name: Optional[str] = None) -> None:
        logger.info("Starting stack build in region=%s profile=%s", self.region, self.profile)
        self.verify_identity()

        self.vpc_id = self.create_vpc()
        self.public_subnet_id, self.private_subnet_id = self.create_subnets(self.vpc_id)
        self.create_internet_gateway_and_routes(self.vpc_id, self.public_subnet_id)
        self.create_nat_gateway(self.vpc_id, self.public_subnet_id)
        self.security_group_id = self.create_security_group(self.vpc_id)
        self.ec2_instance_id = self.create_ec2_instance(
            self.private_subnet_id, self.security_group_id, key_name
        )
        self.db_instance_id = self.create_rds_instance(self.private_subnet_id, self.security_group_id)
        self.verify_stack()
        logger.info("Stack build complete")
        logger.info(
            "Resources: VPC=%s PublicSubnet=%s PrivateSubnet=%s EC2=%s RDS=%s SG=%s",
            self.vpc_id,
            self.public_subnet_id,
            self.private_subnet_id,
            self.ec2_instance_id,
            self.db_instance_id,
            self.security_group_id,
        )


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Build a minimal AWS stack: VPC, public/private subnets, NAT, EC2 (SSM), RDS."
    )
    parser.add_argument("--profile", required=True, help="AWS CLI profile name")
    parser.add_argument("--region", required=True, help="AWS region (e.g., us-east-1)")
    parser.add_argument("--key-name", help="EC2 key pair name (optional; SSM used for access)")
    args = parser.parse_args()

    builder = StackBuilder(profile=args.profile, region=args.region)
    try:
        builder.build(key_name=args.key_name)
    except (NoRegionError, NoCredentialsError) as e:
        logger.error("AWS configuration error: %s", e)
        sys.exit(1)
    except ClientError as e:
        code = e.response.get("Error", {}).get("Code", "")
        logger.error("AWS API error (%s): %s", code, e)
        sys.exit(1)
    except KeyboardInterrupt:
        logger.warning("Interrupted by user")
        sys.exit(130)


if __name__ == "__main__":
    main()