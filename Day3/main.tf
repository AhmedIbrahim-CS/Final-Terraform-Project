provider "aws" {

}

resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "my-tfstate-bucket-2020220"


  # lifecycle {
  #   prevent_destroy = true

  #   }

  tags = {
    Name = "Terraform State Bucket"

  }

}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "my-tfstate-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Terraform State Lock Table"

  }

}

terraform {
  backend "s3" {
    bucket         = "my-tfstate-bucket-2020220"  
    key            = "terraform.tfstate" 
    region         = "us-east-1"   
    dynamodb_table = "my-tfstate-lock"
    encrypt        = true
  }
}


module "ami" {
  source = "./aws_ami"
}
module "nat_gateway" {
  source = "./nat_gateway"

  subnet_id = module.public_subnet.public_subnet_id_1
  tags      = "NAT Gateway"

}

module "private_ec2_sg" {
  source = "./private_ec2_sg"
  vpc_id = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port = 80,
      to_port   = 80,
      protocol  = "tcp",
      cidr_blocks = ["0.0.0.0/0"],

    },
    {
      from_port   = 443,
      to_port     = 443,
      protocol    = "tcp",
      cidr_blocks = ["0.0.0.0/0"],
    },
    {
      from_port   = 22,
      to_port     = 22,
      protocol    = "tcp",
      cidr_blocks = ["0.0.0.0/0"],
    }


  ]

  egress_rules = [
    {
      from_port   = 0,
      to_port     = 0,
      protocol    = "-1",
      cidr_blocks = ["0.0.0.0/0"],
    }
  ]

  tags = ["My Private EC2 Security Group"]

  depends_on = [module.private_lb_sg]
}



module "private_ec2" {
  source = "./private_instances"

  ami_id = module.ami.instance_id

  private_ec2_security_group_id = module.private_ec2_sg.private_ec2_security_group_id

  private_subnet_id = [module.private_subnets.private_subnet_id_1, module.private_subnets.private_subnet_id_2]

  tags = ["My Private EC2 Instance"]

  depends_on = [module.private_subnets, module.private_ec2_sg, module.nat_gateway]

}




module "private_lb_sg" {
  source = "./private_lb_sg"
  vpc_id = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]

    }

  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = ["My Private Load Balancer"]



}


module "private_subnets" {
  source = "./private_subnet"

  vpc_id = module.vpc.vpc_id

  tags = ["My Private Subnets"]

}



module "private_rt" {
  source = "./private_rt"

  vpc_id = module.vpc.vpc_id

  nat_id = module.nat_gateway.nat_gateway_id

  tags = ["My Private Route Table"]
  subnet_ids = [
    module.private_subnets.private_subnet_id_1,
    module.private_subnets.private_subnet_id_2
  ]

}





module "private_lb" {
  source = "./private_loadbalancer"

  name               = "privatelb1"
  load_balancer_type = "application"
  subnets            = [module.private_subnets.private_subnet_id_1, module.private_subnets.private_subnet_id_2]
  security_grouplb   = [module.private_lb_sg.private_lb_security_group_id]



  vpc_id = module.vpc.vpc_id

  private_target_group_name = "TargetB"

  protocol    = "HTTP"
  port        = 80
  private_ec2 = module.private_ec2.private_ec2_ids

}






module "public_ec2_sg" {
  source = "./public_ec2_sg"
  vpc_id = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port   = 80,
      to_port     = 80,
      protocol    = "tcp",
      cidr_blocks = ["0.0.0.0/0"],

    },
    {
      from_port   = 22,
      to_port     = 22,
      protocol    = "tcp",
      cidr_blocks = ["0.0.0.0/0"],
    },

    {
      from_port   = 443,
      to_port     = 443,
      protocol    = "tcp",
      cidr_blocks = ["0.0.0.0/0"],
    }





  ]

  egress_rules = [
    {
      from_port   = 0,
      to_port     = 0,
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = ["My public EC2 Security Group"]


}




module "public_ec2" {
  source                       = "./public_instances"
  ami_id                       = module.ami.instance_id
  instance_type                = "t2.micro"
  public_ec2_security_group_id = module.public_ec2_sg.public_ec2_security_group_id
  public_subnet_id             = [module.public_subnet.public_subnet_id_1, module.public_subnet.public_subnet_id_2]
  private_elb_dns_name         = module.private_lb.private_lb_dns_name

  depends_on = [module.public_subnet, module.public_ec2_sg, module.vpc]

}





module "public_lb_sg" {
  source = "./public_lb_sg"
  vpc_id = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },

    {
      from_port   = 443,
      to_port     = 443,
      protocol    = "tcp",
      cidr_blocks = ["0.0.0.0/0"],
    }

  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

  ]
  tags = ["My public Load Balancer sg"]

}


module "public_lb" {
  source = "./public_loadbalancer"

  name                     = "publiclb"
  load_balancer_type       = "application"
  subnets                  = [module.public_subnet.public_subnet_id_1, module.public_subnet.public_subnet_id_2]
  vpc_id                   = module.vpc.vpc_id
  port                     = 80
  protocol                 = "HTTP"
  public_target_group_name = "targetA"
  security_grouplb    = [module.public_lb_sg.public_lb_security_group_id]

  public_ec2 = module.public_ec2.public_ec2_ids


}







module "public_rt" {
  source = "./public_rt"

  vpc_id = module.vpc.vpc_id

  tags = ["Public Route Table"]

  igw_id    = module.vpc.igw_id
  subnet_id = [module.public_subnet.public_subnet_id_1, module.public_subnet.public_subnet_id_2]

}




module "public_subnet" {
  source = "./public_subnet"

  vpc_id = module.vpc.vpc_id

  tags = ["My Public Subnets"]
}




module "vpc" {
  source = "./vpc"

  tags = ["vpc"]
}
