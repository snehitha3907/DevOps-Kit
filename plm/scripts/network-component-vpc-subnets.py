# last_verified: 2026-10-14 · pulumi n/a
# I built a small component-resource stack from scratch: a reusable Network
# component that wraps a VPC plus its public and private subnets. The point of
# the exercise was to see how a ComponentResource works — it is just a class
# that groups resources under one logical name so callers do not have to wire
# the pieces together every time.
import ipaddress

import pulumi
import pulumi_aws as aws


class Network(pulumi.ComponentResource):
    """A VPC with one public and one private subnet per AZ.

    The component owns the VPC, the two subnet tiers, an Internet Gateway for
    the public tier, and a NAT Gateway so the private tier can reach the
    Internet without being reachable from it. Everything is created under the
    component's logical name, so a caller only asks for a Network and gets a
    coherent piece of networking back.
    """

    def __init__(self, name: str, cidr: str, opts: pulumi.ResourceOptions = None):
        super().__init__("custom:network:Network", name, {}, opts)

        # Parse the CIDR once so the math below is readable. A /16 gives us
        # room for two /18 tiers (public and private) with space to grow.
        network = ipaddress.ip_network(cidr, strict=False)
        public_subnet = list(network.subnets(new_prefix=18))[0]
        private_subnet = list(network.subnets(new_prefix=18))[1]

        # The VPC itself is the container everything else hangs off.
        self.vpc = aws.ec2.Vpc(
            f"{name}-vpc",
            cidr_block=cidr,
            enable_dns_hostnames=True,
            enable_dns_support=True,
            tags={"Name": f"{name}-vpc"},
            opts=pulumi.ResourceOptions(parent=self),
        )

        # Internet Gateway — the public tier's way out and the thing that
        # makes a subnet "public" in the first place.
        self.igw = aws.ec2.InternetGateway(
            f"{name}-igw",
            vpc_id=self.vpc.id,
            tags={"Name": f"{name}-igw"},
            opts=pulumi.ResourceOptions(parent=self),
        )

        # Public subnet: attached to the IGW, so instances here can be reached
        # from the Internet and can reach it back.
        self.public_subnet = aws.ec2.Subnet(
            f"{name}-public-subnet",
            vpc_id=self.vpc.id,
            cidr_block=str(public_subnet),
            availability_zone=f"{pulumi.get_region().name}a",
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

        # Private subnet: no direct route to the IGW. It reaches the Internet
        # through the NAT Gateway below, which is the whole point of the tier.
        self.private_subnet = aws.ec2.Subnet(
            f"{name}-private-subnet",
            vpc_id=self.vpc.id,
            cidr_block=str(private_subnet),
            availability_zone=f"{pulumi.get_region().name}a",
            tags={"Name": f"{name}-private", "tier": "private"},
            opts=pulumi.ResourceOptions(parent=self),
        )

        # NAT Gateway needs an Elastic IP and a home in the public subnet.
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

        # Expose the pieces a caller actually wants without forcing it to dig
        # into the component's internals.
        self.register_outputs(
            vpc=self.vpc,
            public_subnet=self.public_subnet,
            private_subnet=self.private_subnet,
        )

    def _public_route_table(self) -> aws.ec2.RouteTable:
        rt = aws.ec2.RouteTable(
            f"{self.id}-public-rt",
            vpc_id=self.vpc.id,
            routes=[{"cidr_block": "0.0.0.0/0", "gateway_id": self.igw.id}],
            tags={"Name": f"{self.id}-public-rt", "tier": "public"},
            opts=pulumi.ResourceOptions(parent=self),
        )
        return rt

    def _private_route_table(self) -> aws.ec2.RouteTable:
        rt = aws.ec2.RouteTable(
            f"{self.id}-private-rt",
            vpc_id=self.vpc.id,
            routes=[{"cidr_block": "0.0.0.0/0", "nat_gateway_id": self.nat_gateway.id}],
            tags={"Name": f"{self.id}-private-rt", "tier": "private"},
            opts=pulumi.ResourceOptions(parent=self),
        )
        return rt


# A caller creates one Network and gets a complete, working VPC back.
network = Network("demo-network", "10.20.0.0/16")

pulumi.export("vpc_id", network.vpc.id)
pulumi.export("public_subnet_id", network.public_subnet.id)
pulumi.export("private_subnet_id", network.private_subnet.id)