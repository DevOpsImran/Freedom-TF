resource "aws_instance" "UAT-create-nonprod" {
  ami           = var.UAT-nonprod["ami"]
  instance_type = var.UAT-nonprod["instance_type"]
  availability_zone = var.UAT-nonprod["avail_zone"] 
  #security_groups = [aws_security_group.seg_public.name]
  vpc_security_group_ids = [aws_security_group.seg_public.id]
  subnet_id = "${aws_subnet.subnet[0].id}"
  associate_public_ip_address = "true"
	depends_on = [aws_security_group.seg_public, aws_iam_role.role]
#	iam_instance_profile ="${aws_iam_role.role.id}" 
	key_name="freedom-nonprod"
  
  root_block_device {
    volume_size           = var.UAT-nonprod["volume_size"]
    volume_type           = "gp2"
    delete_on_termination = "true"
  }
  tags = {
     Name = var.UAT-nonprod["instance_name"],
     Client = var.Global-Tag["Client"],
     Environment = var.Global-Tag["Env"]
     Owner = var.Global-Tag["Owner"] 
 }
}

resource "aws_instance" "UAT-create-nonprod-redis-1" {
  ami           = var.UAT-nonprod-redis-1["ami"]
  instance_type = var.UAT-nonprod-redis-1["instance_type"]
  availability_zone = var.UAT-nonprod-redis-1["avail_zone"]
  vpc_security_group_ids = [aws_security_group.redis-2-sec-grp.id]
  subnet_id = "${aws_subnet.subnet[0].id}"
  associate_public_ip_address = "true"
        depends_on = [aws_security_group.redis-2-sec-grp, aws_iam_role.role]
#       iam_instance_profile ="${aws_iam_role.role.id}"
        key_name="freedom-nonprod"

  root_block_device {
    volume_size           = var.UAT-nonprod-redis-1["volume_size"]
    volume_type           = "gp2"
    delete_on_termination = "true"
  }
  tags = {
     Name = var.UAT-nonprod-redis-1["instance_name"],
     Client = var.Global-Tag["Client"],
     Environment = var.Global-Tag["Env"]
     Owner = var.Global-Tag["Owner"]
 }
}

resource "aws_instance" "UAT-create-nonprod-redis-2" {
  ami           = var.UAT-nonprod-redis-2["ami"]
  instance_type = var.UAT-nonprod-redis-2["instance_type"]
  availability_zone = var.UAT-nonprod-redis-2["avail_zone"]
  vpc_security_group_ids = [aws_security_group.redis-2-sec-grp.id]
  subnet_id = "${aws_subnet.subnet[0].id}"
  associate_public_ip_address = "true"
    #    depends_on = [aws_security_group.seg_public, aws_iam_role.role]
#       iam_instance_profile ="${aws_iam_role.role.id}"
        key_name="freedom-nonprod"

  root_block_device {
    volume_size           = var.UAT-nonprod-redis-2["volume_size"]
    volume_type           = "gp2"
    delete_on_termination = "true"
  }
  tags = {
     Name = var.UAT-nonprod-redis-2["instance_name"],
     Client = var.Global-Tag["Client"],
     Environment = var.Global-Tag["Env"]
     Owner = var.Global-Tag["Owner"]
 }
}


