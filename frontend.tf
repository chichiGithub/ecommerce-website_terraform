# Create ELB
resource "aws_elb" "frontend_elb" {
  name               = "frontend-elb"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"] 
  security_groups    = ["sg-083271f649f036b02"]

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }
}

# Create Launch Configuration
resource "aws_launch_configuration" "frontend_lc" {
  name                 = "frontend-lc"
  image_id             = "ami-0a1179631ec8933d7" 
  instance_type        = "t2.micro"    
  security_groups      = [aws_security_group.frontend_sg.id]
  key_name             = "terraform" 
  user_data            = file("frontend_user_data.sh")
  
}

# Create Auto Scaling Group
resource "aws_autoscaling_group" "frontend_asg" {
  launch_configuration = aws_launch_configuration.frontend_lc.id
  min_size              = 2  
  max_size              = 5 
  desired_capacity      = 2 
  vpc_zone_identifier   = [aws_subnet.public.id]
  health_check_type     = "ELB"
  load_balancers        = [aws_elb.frontend_elb.name]
}
