resource "aws_instance" "UAT-create-nonprod" {
  ami           = var.UAT-nonprod["ami"]
  instance_type = var.UAT-nonprod["instance_type"]
  availability_zone = var.UAT-nonprod["avail_zone"] 
  #security_groups = [aws_security_group.seg_public.name]
  vpc_security_group_ids = [aws_security_group.seg_public.id]
  subnet_id = "${aws_subnet.subnet[0].id}"
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
