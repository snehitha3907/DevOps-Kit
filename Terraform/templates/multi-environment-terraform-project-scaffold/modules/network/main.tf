# last_verified: 2026-10-27 · terraform n/a

variable "name" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  tags       = merge(var.tags, { Name = var.name })
}

resource "aws_subnet" "this" {
  count             = 2
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags              = merge(var.tags, { Name = "${var.name}-${count.index}" })
}

data "aws_availability_zones" "available" {
  state = "available"
}

output "vpc_id" {
  value = aws_vpc.this.id
}

output "subnet_ids" {
  value = aws_subnet.this[*].id
}
