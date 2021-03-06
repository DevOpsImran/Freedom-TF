resource "aws_vpc" "vpc" {
  cidr_block = var.vpcCIDRblock
  enable_dns_hostnames = true
  tags = {
    Name   = "Freedom-UAT-create-nonprod",
    Client = var.Global-Tag["Client"],
    Environment = var.Global-Tag["Env"]
    Owner = var.Global-Tag["Owner"]
 }
} 
# END of VPC RESOURCE

# Internet gateway creation
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Freedom-nonprod-VPC-IGW",
    Client = var.Global-Tag["Client"],
     Environment = var.Global-Tag["Env"]
     Owner = var.Global-Tag["Owner"]
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
    Client = var.Global-Tag["Client"],
     Environment = var.Global-Tag["Env"]
     Owner = var.Global-Tag["Owner"]
  }
} #END of subnet creation




resource aws_route_table "rt_table" {
  vpc_id = aws_vpc.vpc.id
  count  = length(var.rt_table_names)
  tags = {
    Name = var.rt_table_names[count.index],
    Client = var.Global-Tag["Client"],
     Environment = var.Global-Tag["Env"]
     Owner = var.Global-Tag["Owner"] 
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
  depends_on  = [aws_security_group.redis-2-sec-grp]
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

  ingress {
    description = "Hive-1"
    from_port   = 26379
    to_port     = 26379
    protocol    = "TCP"
    cidr_blocks = ["182.72.168.142/32"]
  }
  ingress {
    description = "Hive-2"
    from_port   = 6379
    to_port     = 6379
    protocol    = "TCP"
    cidr_blocks = ["121.242.155.146/32"]
  }
  ingress {
    description = "internal-routing"
    from_port   = 6379
    to_port     = 6379
    protocol    = "TCP"
    security_groups = ["${aws_security_group.redis-2-sec-grp.id}"]
  }




  tags = {
    Name   = "Freedom-preprod",
    Client = var.Global-Tag["Client"],
     Environment = var.Global-Tag["Env"]
     Owner = var.Global-Tag["Owner"]
   }


}

## SEC-GRP for Freedom-UAT-create-nonprod-redis-1
resource "aws_security_group" "Redis-1-win-seg_public" {
  name        = "Freedom-UAT-create-nonprod-redis-1"
  description = "Freedom-UAT-create-nonprod-redis-1"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Hive-1"
    from_port   = 3389
    to_port     = 3389
    protocol    = "TCP"
    cidr_blocks = ["182.72.168.142/32"]
  }
  ingress {
    description = "Hive-2"
    from_port   = 3389
    to_port     = 3389
    protocol    = "TCP"
    cidr_blocks = ["121.242.155.146/32"]
  }
   ingress {
    description = "SSH-Imran"
    from_port   = 3389
    to_port     = 3389
    protocol    = "TCP"
    cidr_blocks = ["106.198.81.152/32"]
  }


  tags = {
    Name   = "Freedom-nonprod-redis-1",
    Client = var.Global-Tag["Client"],
     Environment = var.Global-Tag["Env"]
     Owner = var.Global-Tag["Owner"]
   }


}
##
resource "aws_security_group" "redis-2-sec-grp" {
#  depends_on = [aws_instance.UAT-create-nonprod]
  name        = "Freedom-UAT-create-nonprod-redis-2"
  description = "Freedom-UAT-create-nonprod-redis-2"
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
    cidr_blocks = ["106.198.81.152/32"]
  }
 ingress {
    description = "Internal-Routing"
    from_port   = 26379
    to_port     = 26379
    protocol    = "TCP"
    cidr_blocks = ["106.198.81.152/32"]
  }



  tags = {
    Name   = "Freedom-preprod-redis-2",
    Client = var.Global-Tag["Client"],
     Environment = var.Global-Tag["Env"]
     Owner = var.Global-Tag["Owner"]
   }


}
##


output "subnetid" {
  value = {
    for x in range(length(var.subnet_names)) :
    var.subnet_names[x] => aws_subnet.subnet[x].id
  }
}
