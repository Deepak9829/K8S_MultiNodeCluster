terraform {
  backend "s3" {
    bucket  = "k8s-state-file"
    key     = "terraform.tfstate"
    region  = "ap-south-1"
    profile = "deepak_acc"
  }
}


resource "aws_security_group" "mysg" {
  depends_on  = [aws_vpc.myvpc, aws_subnet.mysubnet]
  name        = "MySG for Master & Slave"
  description = "Allow port no. 22"
  vpc_id      = aws_vpc.myvpc.id

  ingress {

    description = "allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]

  }


  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "My_SG"
  }
}



resource "aws_instance" "Slave" {
  depends_on                  = [aws_security_group.mysg]
  count                       = var.slave_machine_count
  subnet_id                   = aws_subnet.mysubnet.id
  ami                         = var.ami_image
  instance_type               = var.slave_instance_type
  key_name                    = "testvm"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.mysg.id]



  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 20
    http_tokens                 = "optional"
    instance_metadata_tags      = "enabled"
  }

  tags = {
    Name = "Slave-${count.index + 1}"

  }

}


resource "aws_instance" "Master" {
  depends_on                  = [aws_security_group.mysg]
  subnet_id                   = aws_subnet.mysubnet.id
  ami                         = var.ami_image
  associate_public_ip_address = true
  instance_type               = var.master_instance_type
  key_name                    = "testvm"
  vpc_security_group_ids      = [aws_security_group.mysg.id]





  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 20
    http_tokens                 = "optional"
    instance_metadata_tags      = "enabled"
  }

  tags = {
    Name = "Master"
  }
}


resource "local_file" "ipaddr" {

  filename = var.inventory_file_path
  content  = <<-EOT
    [Master]
    ${aws_instance.Master.public_ip}
    [Slave]
    %{for ip in aws_instance.Slave.*.public_ip~}
    ${ip} 
    %{endfor~}
  EOT
}


resource "null_resource" "nulllocal3" {
  depends_on = [local_file.ipaddr]
  provisioner "local-exec" {
    command = "ansible-playbook /home/deepaksaini/K8S_MultiNodeCluster/Ansible-Playbook/cluster.yml -i /home/deepaksaini/K8S_MultiNodeCluster/Ansible-Playbook/k8s.ini"
  }

}




resource "null_resource" "LabeltheNodes" {
  depends_on = [null_resource.nulllocal3]
  count      = length(aws_instance.Slave.*.private_dns)

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.aws_private_key_path)
    port        = 22
    host        = aws_instance.Master.public_ip
  }
  provisioner "remote-exec" {
    inline = [

      "sudo kubectl label node ${aws_instance.Slave[count.index].private_dns}  node-role.kubernetes.io/${aws_instance.Slave[count.index].tags.Name}=${aws_instance.Slave[count.index].tags.Name}"

    ]
  }
}