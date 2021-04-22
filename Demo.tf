/*
variable "project" {
  description = "Map of project names to configuration."
  type        = map
  default     = {
    console-app = {
       name    = "Freedom-Preprod-console-APP"
       port     = 443
       protocol = "HTTPS"
       target_type = "instance"
    },
    polygot-engine = {
    name     = "freedom-preprod-polyglot-engine"
    port     = 8084
    protocol = "HTTP"
    target_type = "instance"
    }
  }
}


resource "aws_lb_target_group" "target-1" {
 vpc_id   = aws_vpc.vpc.id
 for_each = var.project
   name     = each.value.name
   port     = each.value.port
   protocol = each.value.protocol
   target_type = each.value.target_type

## The above code works fine for multiple map with for each
## The below code is not working.vThese can't be used for target attachement 
 
resource "aws_lb_target_group_attachment" "console-app-attachement" {
  for_each  = var.project
  target_group_arn = aws_lb_target_group.target-1.arn
  target_id        = aws_instance.UAT-create-nonprod.id
  port             = 443
}
}

*/

