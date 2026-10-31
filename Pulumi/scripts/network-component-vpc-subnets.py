# last_verified: 2026-10-14 · pulumi n/a
# Purpose: reusable Network component wrapping a VPC with public/private subnets.
# Usage: Network("demo-network", "10.20.0.0/16") builds a VPC, IGW, NAT gateway,
#   two subnets and their route tables under one component name. This is one way
#   to structure it; the docs also show splitting each tier into its own
#   component, which suits larger layouts.
# Verify: `pulumi preview` shows one VPC, two subnets, IGW, EIP + NAT gateway
#   and two route-table associations; `pulumi stack output vpc_id` returns the VPC.
import ipaddress

import pulumi
import pulumi_aws as aws


class Network(pulumi.ComponentResource):
    """A VPC with one public and one private subnet.

    The component owns the VPC, both subnet tiers, an Internet Gateway for
    the public tier, and a NAT Gateway so the private tier can reach the
    Internet without being reachable from it. Callers request a Network and
    receive VPC/subnet IDs without wiring the pieces themselves.
    """

    def __init__(self, name: str, cidr: str, opts: pulumi.ResourceOptions = None):
        super().__init__("custom:network:Network", name, {}, opts)
        self._base_name = name

        try:
            network = ipaddress.ip_network(cidr, strict=False)
        except ValueError as exc:
            raise ValueError(
                f"invalid CIDR {cidr!r}: must be a valid IPv4 network "
                f"(e.g. '10.20.0.0/16')"
            ) from exc
        if network.prefixlen > 18:
            raise ValueError(
                f"invalid CIDR {cidr!r}: prefix /{network.prefixlen} is too "
                f"small to split into two /18 tiers; use /18 or larger "
                f"(e.g. /16)"
            )
        public_subnet = list(network.subnets(new_prefix=18))[0]
        private_subnet = list(network.subnets(new_prefix=18))[1]

        zones = aws.get_availability_zones(state="available")
        az = zones.names[0]

        self.vpc = aws.ec2.Vpc(
            f"{name}-vpc",
            cidr_block=cidr,
            enable_dns_hostnames=True,
            enable_dns_support=True,
            tags={"Name": f"{name}-vpc"},
            opts=pulumi.ResourceOptions(parent=self),
        )

        self.igw = aws.ec2.InternetGateway(
            f"{name}-igw",
            vpc_id=self.vpc.id,
            tags={"Name": f"{name}-igw"},
            opts=pulumi.ResourceOptions(parent=self),
        )

        self.public_subnet = aws.ec2.Subnet(
            f"{name}-public-subnet",
            vpc_id=self.vpc.id,
            cidr_block=str(public_subnet),
            availability_zone=az,
            map_public_ip_on_launch=True,
            tags={"Name": f"{name}-public", "tier": "public"},
            opts=pulumi.ResourceOptions(parent=self),
        )
        aws.ec2.RouteTableAssociation(
            f"{name}-public-rt",
            subnet_id=self.public_subnet.id,
            route_table_id=self._public_route_table().id,
            opts=pulumi.ResourceOptions(parent=self),
        )

        self.private_subnet = aws.ec2.Subnet(
            f"{name}-private-subnet",
            vpc_id=self.vpc.id,
            cidr_block=str(private_subnet),
            availability_zone=az,
            tags={"Name": f"{name}-private", "tier": "private"},
            opts=pulumi.ResourceOptions(parent=self),
        )

        self.nat_eip = aws.ec2.Eip(
            f"{name}-nat-eip",
            domain="vpc",
            opts=pulumi.ResourceOptions(parent=self),
        )
        self.nat_gateway = aws.ec2.NatGateway(
            f"{name}-nat-gateway",
            subnet_id=self.public_subnet.id,
            allocation_id=self.nat_eip.id,
            tags={"Name": f"{name}-nat"},
            opts=pulumi.ResourceOptions(parent=self),
        )
        aws.ec2.RouteTableAssociation(
            f"{name}-private-rt",
            subnet_id=self.private_subnet.id,
            route_table_id=self._private_route_table().id,
            opts=pulumi.ResourceOptions(parent=self),
        )

        self.register_outputs(
            {
                "vpc_id": self.vpc.id,
                "public_subnet_id": self.public_subnet.id,
                "private_subnet_id": self.private_subnet.id,
            }
        )

    def _public_route_table(self) -> aws.ec2.RouteTable:
        rt = aws.ec2.RouteTable(
            f"{self._base_name}-public-rt",
            vpc_id=self.vpc.id,
            routes=[{"cidr_block": "0.0.0.0/0", "gateway_id": self.igw.id}],
            tags={"Name": f"{self._base_name}-public-rt", "tier": "public"},
            opts=pulumi.ResourceOptions(parent=self),
        )
        return rt

    def _private_route_table(self) -> aws.ec2.RouteTable:
        rt = aws.ec2.RouteTable(
            f"{self._base_name}-private-rt",
            vpc_id=self.vpc.id,
            routes=[{"cidr_block": "0.0.0.0/0", "nat_gateway_id": self.nat_gateway.id}],
            tags={"Name": f"{self._base_name}-private-rt", "tier": "private"},
            opts=pulumi.ResourceOptions(parent=self),
        )
        return rt


network = Network("demo-network", "10.20.0.0/16")

pulumi.export("vpc_id", network.vpc.id)
pulumi.export("public_subnet_id", network.public_subnet.id)
pulumi.export("private_subnet_id", network.private_subnet.id)
