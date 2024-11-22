region               = "ap-south-1"
vpc_cidr             = "26.0.0.0/16"
vpc_name             = "project-vpc-1"
cidr_public_subnet   = ["26.0.1.0/24", "26.0.2.0/24"]
cidr_private_subnet  = ["26.0.3.0/24", "26.0.4.0/24"]
us_availability_zone = ["ap-south-1a", "ap-south-1b"]
ec2_ami_id           = "ami-08718895af4dfa033"