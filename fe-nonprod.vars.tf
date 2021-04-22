variable "aws_region" {
	default = "ca-central-1"

}

variable "vpcCIDRblock" {
	default = "10.0.0.0/22"
}

variable "availabilityZone" {
	type= list(string)
	default = ["ca-central-1a","ca-central-1b"]
}

variable "subnetcidr" {
	type = list(string)
	default = ["10.0.0.0/28","10.0.0.16/28"]
	
} 

variable "subnet_names" {
	type =list(string)
	default = ["Freedom-nonprod-subnet-1a","freedom-nonprod-subnet-1b"]
	
}

variable "rt_table_names" {
	type = list(string)
	default = ["freedom-nonprod-rtb-1a","freedom-nonprod-rtb-1b"]
}


variable "UAT-nonprod" {
  type    = map(string)
  default = {
    "ami" = "ami-09934b230a2c41883"
    "instance_type" = "t2.micro"
    "avail_zone" = "ca-central-1a"
    "instance_name" = "Freedom-UAT-create-nonprod"
    "volume_size" = "12"
    
  }
}

variable "Global-Tag" {
  type = map(string)
  default = {
    "Client" = "Freedom"
    "Owner" = "Hemanth"
    "Env"= "UAT"
  }
}








