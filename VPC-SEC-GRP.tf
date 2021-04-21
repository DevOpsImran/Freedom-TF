resource "aws_vpc" "vpc" {
  cidr_block = var.vpcCIDRblock
  enable_dns_hostnames = true
  tags = {
    Name   = "Freedom-nonprod-VPC",
    Client = "Freedom"
	Environment = "NonProd"
  }
} 
# END of VPC RESOURCE

# Internet gateway creation
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Freedom-nonprod-VPC-IGW",
	Client = "Freedom",
	Environment = "NonProd"
  }
}

#SUBNET CREATION

resource aws_subnet "subnet" {

  vpc_id            = aws_vpc.vpc.id
  count             = length(var.subnetcidr)
  cidr_block        = var.subnetcidr[count.index]
  availability_zone = var.availabilityZone[count.index]

  tags = {
    count = length(var.subnet_names)
    Name  = var.subnet_names[count.index],
	Client = "Freedom",
	Environment = "NonProd"

  }
} #END of subnet creation




resource aws_route_table "rt_table" {
  vpc_id = aws_vpc.vpc.id
  count  = length(var.rt_table_names)
  tags = {
    Name = var.rt_table_names[count.index],
	Client = "Freedom",
	Environment = "NonProd"
  }
}

# subnet association to route table
resource "aws_route_table_association" "rt_association" {
  count = length(var.subnet_names)
  subnet_id      = aws_subnet.subnet[count.index].id
  route_table_id = aws_route_table.rt_table[count.index].id
} # end resource subnet association

#Associate IGW to route table
resource aws_route "attach_igw_pub" {
  count = length(var.rt_table_names)
  route_table_id         = aws_route_table.rt_table[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


resource "aws_security_group" "seg_public" {
  name        = "Freedom-nonprod-sg"
  description = "Freedom nonprod security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Hive-1"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["182.72.168.142/32"]
  }
  ingress {
    description = "Hive-2"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["121.242.155.146/32"]
  }
   ingress {
    description = "SSH-Imran"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["106.198.89.195/32"]
  }


  tags = {
    Name   = "Freedom-preprod",
    Client = "Freedom",
	Environment = "NonProd"
  }


}


output "subnetid" {
  value = {
    for x in range(length(var.subnet_names)) :
    var.subnet_names[x] => aws_subnet.subnet[x].id
  }
}
