


resource "aws_security_group" "freedom_nonprod_lb_pub_sg" {
  vpc_id      = aws_vpc.vpc.id
  name        = "Freedom-nonprod-pub-sg"
  description = "Freedom nonprod pub security group listen only 443"
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
 tags=  {    
    Name = "freedom_nonprod_lb_public_sg"
    Team = "Freedom"
    ENV  = "uat"
  }
}

resource "aws_lb" "Freedom-nonprod-external-LB" {
  name               = "Freedom-nonprod-internal-LB"
  internal           = false
 # count              = length(var.subnet_names)    
  subnets            = ["${aws_subnet.subnet[0].id}", "${aws_subnet.subnet[1].id}"]
  security_groups    = ["${aws_security_group.freedom_nonprod_lb_pub_sg.id}"]
  idle_timeout       = 300
  tags = {
    Name = "Freedom-nonprod-External-LB"
    Env  = "uat"
  }
}
/*
resource "aws_lb_listener" "freedom-nonprod-console-app" {
  load_balancer_arn  = aws_lb.Freedom-nonprod-external-LB.arn
  port               = "443"
  protocol           = "HTTPS"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.console-app.arn
  }
}
*/
##################################################################
resource "aws_security_group" "freedom_nonprod_lb_pvt_sg" {
  vpc_id      = aws_vpc.vpc.id
  name        = "Freedom-nonprod-pvt-sg"
  description = "Freedom nonprod pvt security group"
  ingress {
    from_port   = 8082
    to_port     = 8082
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
ingress {
    from_port   = 8083
    to_port     = 8083
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
ingress {
    from_port   = 8084
    to_port     = 8084
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }


 tags=  {
    Name = "freedom_nonprod_lb_public_sg"
    Team = "Freedom"
    ENV  = "uat"
  }
}


resource "aws_lb" "Freedom-nonprod-internal-LB" {
  name               = "Freedom-nonprod-internal-LB"
  internal           = true
  subnets            = ["${aws_subnet.subnet[0].id}", "${aws_subnet.subnet[1].id}"]
  security_groups    = ["${aws_security_group.freedom_nonprod_lb_pvt_sg.id}"]
  idle_timeout       = 300
  tags = {
    Name = "Freedom-nonprod-Internal-LB"
    Env  = "uat"
  }
}



resource "aws_lb_listener" "freedom-nonprod-polygot-engine" {
  load_balancer_arn  = aws_lb.Freedom-nonprod-internal-LB.arn
  port               = "8084"
  protocol           = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.polygot-engine.arn
  }
}
resource "aws_lb_listener" "freedom-nonprod-script-engine" {
  load_balancer_arn  = aws_lb.Freedom-nonprod-internal-LB.arn
  port               = "8083"
  protocol           = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.script-engine.arn
  }
}
resource "aws_lb_listener" "freedom-nonprod-service" {
  load_balancer_arn  = aws_lb.Freedom-nonprod-internal-LB.arn
  port               = "8082"
  protocol           = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service.arn
  }
}



