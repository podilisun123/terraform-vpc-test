### vpc
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = var.enable_dns_hostnames  
  tags = merge(
    var.common_tags,
    var.vpc_tags,
    {
        Name = local.resourc_name
    }

  )
}
### igw
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(
        var.common_tags,
        var.igw_tags,
        {
            Name = local.resourc_name
        }
    )

}
# public subnet
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  availability_zone = local.azs[count.index]
  cidr_block = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    var.public_subnet_tags,
    {
        Name = "${local.resourc_name}-public-${local.azs[count.index]}"
    }
  )
}
# private subnet
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  availability_zone = local.azs[count.index]
  cidr_block = var.private_subnet_cidrs[count.index]

  tags = merge(
    var.common_tags,
    var.private_subnet_tags,
    {
        Name = "${local.resourc_name}-private-${local.azs[count.index]}"
    }
  )
}
# database subnet
resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  availability_zone = local.azs[count.index]
  cidr_block = var.database_subnet_cidrs[count.index]
 
  tags = merge(
    var.common_tags,
    var.database_subnet_tags,
    {
        Name = "${local.resourc_name}-database-${local.azs[count.index]}"
    }
  )
}
### database subnet group
resource "aws_db_subnet_group" "db" {
  name       = local.resourc_name
  subnet_ids = aws_subnet.database[*].id

  tags = merge(
    var.common_tags,
    var.db_subnet_group_tags,
    {
        Name = "${local.resourc_name}-database"
    }
  )
}
#elastic ip
resource "aws_eip" "eip" {
    domain   = "vpc"
}
### nat gateway
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.public[0].id
  tags = merge(
    var.common_tags,
    var.ngw_tags,
    {
        Name = "${local.resourc_name}-nat"
    }
  )
  depends_on = [aws_internet_gateway.igw]
}
### public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.public_route_table_tags,
    {
        Name = "${local.resourc_name}-public"
    }
  )
}
### private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
 
  tags = merge(
    var.common_tags,
    var.private_route_table_tags,
    {
        Name = "${local.resourc_name}-private"
    }
  )
}
### database route table
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.database_route_table_tags,
    {
        Name = "${local.resourc_name}-database"
    }
  )
}
### public route to route table
resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}
resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.ngw.id
}
resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.ngw.id
}
### route table association
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public[*].id,count.index)
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private[*].id,count.index)
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "databae" {
  count = length(var.database_subnet_cidrs)
  subnet_id      = element(aws_subnet.database[*].id,count.index)
  route_table_id = aws_route_table.database.id
}



