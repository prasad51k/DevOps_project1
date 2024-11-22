provider "aws" {
  region = var.location
}

resource "aws_instance" "server-1" {
 ami = var.os_name
 key_name = var.key 
 instance_type  = var.instance-type
 associate_public_ip_address = true
subnet_id = aws_subnet.eks_subnet-1.id
vpc_security_group_ids = [aws_security_group.eks-vpc-sg.id]
}

// Create VPC
resource "aws_vpc" "eks-vpc" {
  cidr_block = var.vpc-cidr
}

// Create Subnet
resource "aws_subnet" "eks_subnet-1" {
  vpc_id     = aws_vpc.eks-vpc.id 
  cidr_block = var.subnet1-cidr
  availability_zone = var.subent_az
  map_public_ip_on_launch = "true"

  tags = {
    Name = "eks-subnet1"
  }
}

resource "aws_subnet" "eks_subnet-2" {
  vpc_id     = aws_vpc.eks-vpc.id 
  cidr_block = var.subnet2-cidr
  availability_zone = var.subent-2_az
  map_public_ip_on_launch = "true"

  tags = {
    Name = "eks-subnet2"
  }
}

// Create Internet Gateway

resource "aws_internet_gateway" "eks-igw" {
  vpc_id = aws_vpc.eks-vpc.id

  tags = {
    Name = "eks-igw"
  }
}

resource "aws_route_table" "eks-rt" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks-igw.id
  }
  tags = {
    Name = "eks-rt"
  }
}

// associate subnet with route table 
resource "aws_route_table_association" "eks-rt_association-1" {
  subnet_id      = aws_subnet.eks_subnet-1.id 
  route_table_id = aws_route_table.eks-rt.id
}

resource "aws_route_table_association" "eks-rt_association-2" {
  subnet_id      = aws_subnet.eks_subnet-2.id 
  route_table_id = aws_route_table.eks-rt.id
}

// create a security group 

resource "aws_security_group" "eks-vpc-sg" {
  name        = "eks-vpc-sg"
 
  vpc_id      = aws_vpc.eks-vpc.id

  ingress {

    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }



  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

module "sgs" {
  source = "./sg_eks"
  vpc_id = aws_vpc.eks-vpc.id
}

module "eks" {
  source = "./eks"
  sg_ids = module.sgs.security_group_public
  vpc_id = aws_vpc.eks-vpc.id
  subnet_ids = [aws_subnet.eks_subnet-1.id,aws_subnet.eks_subnet-2.id]
}
