data "template_file" "ec2_private_user_data" {
  template = file("ec2_private_user_data.sh")
}

resource "aws_instance" "private_ec2" {
  
  count                  = 2
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  key_name               = "my-ssh-key1"
  user_data              = data.template_file.ec2_private_user_data.rendered
  vpc_security_group_ids = [var.private_ec2_security_group_id]

  subnet_id = var.private_subnet_id[count.index]

  tags = {
    Name = var.tags[0]
  }
}

resource "null_resource" "private_ips" {
  count = length(aws_instance.private_ec2)

  provisioner "local-exec" {
    command = "echo private-ip${count.index} ${aws_instance.private_ec2[count.index].private_ip} >> all-ips.txt"
  }
}