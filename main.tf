locals {
  ami_id = "ami-02401e017434fd6cb"
  vpc_id = "vpc-058d2f6e"
  ssh_user = "ubuntu"
  key_name = "Java_key"
  private_key_path = "/home/ubuntu/mykeys/Java_key.pem"
}

provider "aws" {
  
  region = "us-east-2" 
}
/*This resource block creates a new security group within the VPC ID specified in the local variables*/

resource "aws_security_group" "Java_proj" {
  name = "Java_proj"
  vpc_id = local.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "Java_web" {
  ami = local.ami_id
  instance_type = "t3.micro"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.Java_proj.id]
  key_name = local.key_name

  tags = {
    Name = "Java test"
  }


 /*The connection block specifies the parameters for connectiong to this instance and
 it will be used by the provisioner to connect to the EC2 after launch*/

  connection {
    type = "ssh"
    host = self.public_ip
    user = local.ssh_user
    private_key = file(local.private_key_path)
    timeout = "4m"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Wait for SSH connection to be ready...'"
    ]
  }

  provisioner "local-exec" {
    #To populate the Ansible inventory file 
    command = "echo ${self.public_ip} > myhosts"
  }

  /* THIS IS A COMMENT provisioner "local-exec" {
    #To execute the ansible playbook
    command = "ansible-playbook -i myhosts --user ${local.ssh_user} --private-key ${local.private_key_path} varloop.yml"
  }
}*/
}

output "instance_ip" {
  #This will print out the public_ip of the EC2 instance
  value = aws_instance.Java_web.public_ip
}
