variable "vpc_cidr" {
    default = "10.0.0.0/16"
  
}

variable "subnet_cidr" {
  
    default = "10.0.1.0/24"
  
}

variable "azs" {
    default = "ap-south-1a"
  
}

variable "aws_region" {
    default = "ap-south-1"
}

variable "ami_image" {
    default = "ami-079b5e5b3971bd10d"
  
}


variable "slave_instance_type" {
    default = "t2.micro"
  
}

variable "master_instance_type" {
    default = "t2.medium"
  
}


variable "inventory_file_path" {
  default = "/home/deepaksaini/K8S_MultiNodeCluster/Ansible-Playbook/k8s.ini"
}


variable "aws_private_key_path" {
  default = "/home/deepaksaini/Downloads/testvm.pem"
}


variable "slave_machine_count" {
  default = 2
}













/*
resource "null_resource" "LabeltheNodes" {
depends_on =[ null_resource.nulllocal3]

connection {
type = "ssh"
user = "ec2-user"
private_key = file("/home/deepaksaini/Downloads/testvm.pem")
port = 22
host = aws_instance.Master.public_ip
}
provisioner "remote-exec" {
inline = [<<EOT
        %{ for dns in aws_instance.Slave.*.private_dns ~}
         echo ${dns} >> /home/ec2-user/dns.txt
         %{ endfor ~}
        %{ for name in aws_instance.Slave.*.tags.Name ~}
        echo ${name} >> /home/ec2-user/name.txt
       %{ endfor ~}

        sudo kubectl label node ${i}  node-role.kubernetes.io/${j}=${j}
       
       EOT
]
}
}
*/


/*
resource "local_file" "ipaddr" {
    
    content  = "[Master]\n${aws_instance.Master.public_ip}\n[Slave]\n${aws_instance.Slave[count.index]}\n"
    filename = "/home/deepaksaini/Inventory/inventory.txt"
}*/

/*
resource "local_file" "ipaddr" {
    count = length(tolist([aws_instance.Slave]))
    content  = "[Master]\n ${element(aws_instance.Slave.*.public_ip, count.index,)}\n"
    filename = "/home/deepaksaini/Inventory/inventory.txt"
}
*/
