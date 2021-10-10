module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "ue1-vpc"
  cidr = "10.10.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  public_subnets  = ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

# WEBAPP
resource "aws_instance" "webapp" {
  ami = "ami-02e136e904f3da870"
  instance_type = "t2.micro"
  subnet_id = module.vpc.public_subnets[0]
  key_name = "dev"
  vpc_security_group_ids = [aws_security_group.web-sg.id]

  tags = {
    Name = "web-app"
  }

}

resource "aws_security_group" "web-sg" {
  name = "web-sg"
  description = "allow traffic to web server"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "web-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web-sg.id
}

resource "aws_security_group_rule" "web-ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["45.19.53.76/32"]
  security_group_id = aws_security_group.web-sg.id
}

resource "aws_security_group_rule" "web-http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["45.19.53.76/32"]
  security_group_id = aws_security_group.web-sg.id
}

# JENKINS
resource "aws_instance" "jenkins" {
  ami = "ami-02e136e904f3da870"
  instance_type = "t2.micro"
  subnet_id = module.vpc.public_subnets[0]
  key_name = "dev"
  vpc_security_group_ids = [aws_security_group.jenkins-sg.id]

  tags = {
    Name = "jenkins-app"
  }

}
resource "aws_security_group" "jenkins-sg" {
  name = "jenkins-sg"
  description = "allow traffic to jenkins server"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "jenkins-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins-sg.id
}

resource "aws_security_group_rule" "jenkins-ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["45.19.53.76/32"]
  security_group_id = aws_security_group.jenkins-sg.id
}

resource "aws_security_group_rule" "jenkins-8080" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["45.19.53.76/32"]
  security_group_id = aws_security_group.jenkins-sg.id
}