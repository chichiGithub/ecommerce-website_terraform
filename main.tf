provider "aws" {
  region = "us-east-1" 
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"  
}

# Create public subnet
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24" 
  availability_zone = "us-east-1a"   
  map_public_ip_on_launch = true
}

# Create private subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"  
  availability_zone = "us-east-1a"  
}

# Create security group for frontend
resource "aws_security_group" "frontend_sg" {
  vpc_id = aws_vpc.main.id

  # Define ingress rules for frontend
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Define egress rules for frontend
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create security group for backend
resource "aws_security_group" "backend_sg" {
  vpc_id = aws_vpc.main.id

  # Define ingress rules for backend
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.0.2.0/24"]  
  }

  # Define egress rules for backend
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
