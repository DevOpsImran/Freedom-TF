resource "aws_lb_target_group" "console-app" {
  name     = "Freedom-Preprod-console-APP"
  port     = 443
  protocol = "HTTPS"
  target_type = "instance"
  vpc_id   = aws_vpc.vpc.id

health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/login"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
  tags = {
    Name = "Freedom-nonprod-target-group-console-app"
    Env  = "uat"
  }
}

resource "aws_lb_target_group" "polygot-engine" {
  name     = "Freedom-Preprod-polygot-engine"
  port     = 8084
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = aws_vpc.vpc.id

health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
  tags = {
    Name = "Freedom-nonprod-target-group-polygot-engine"
    Env  = "uat"
  }
}

resource "aws_lb_target_group" "script-engine" {
  name     = "Freedom-Preprod-script-engine"
  port     = 8083
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = aws_vpc.vpc.id

health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
  tags = {
    Name = "Freedom-nonprod-target-group-script-engine"
    Env  = "uat"
  }
}

resource "aws_lb_target_group" "service" {
  name     = "Freedom-Preprod-service"
  port     = 8082
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = aws_vpc.vpc.id

health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/healthCheck"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
  tags = {
    Name = "Freedom-nonprod-target-group-service"
    Env  = "uat"
  }
}



resource "aws_lb_target_group_attachment" "console-app-attachement" {
  target_group_arn = aws_lb_target_group.console-app.arn
  target_id        = aws_instance.UAT-create-nonprod.id
  port             = 443
}
resource "aws_lb_target_group_attachment" "polygot-attachement" {
  target_group_arn = aws_lb_target_group.polygot-engine.arn
  target_id        = aws_instance.UAT-create-nonprod.id
  port             = 8084
}
resource "aws_lb_target_group_attachment" "script-engine-attachement" {
  target_group_arn = aws_lb_target_group.script-engine.arn
  target_id        = aws_instance.UAT-create-nonprod.id
  port             = 8083
}
resource "aws_lb_target_group_attachment" "service-attachement" {
  target_group_arn = aws_lb_target_group.service.arn
  target_id        = aws_instance.UAT-create-nonprod.id
  port             = 8082
}


 
