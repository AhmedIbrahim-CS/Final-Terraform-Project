resource "aws_instance" "public_ec2" {
  count         = 2
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = "my-ssh-key1"

  vpc_security_group_ids      = [var.public_ec2_security_group_id]
  subnet_id                   = var.public_subnet_id[count.index]
  associate_public_ip_address = true

  tags = {
    Name = "public-ec2"
  }


   provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install nginx -y",
      "sudo systemctl enable nginx",
      "sudo sed -i \"52 i proxy_pass http://${var.private_elb_dns_name};\" /etc/nginx/sites-available/default",
      "sudo systemctl restart nginx"
    ]
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("my-ssh-key1.pem")
    host        = self.public_ip
  }


}
resource "null_resource" "public_ips" {
  count = length(aws_instance.public_ec2)

  provisioner "local-exec" {
    command = "echo public-ip${count.index} ${aws_instance.public_ec2[count.index].public_ip} >> all-ips.txt"
  }
}
