# AWS EC2 Instance Terraform Module
# Bastion Host - EC2 Instance that will be created in VPC Public Subnet
# module "ec2_public" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   #version = "~> 3.0"
#   #version = "3.3.0"
#   version = "5.0.0"  

#   name = "${local.name}-BastionHost"
#   ami                    = data.aws_ami.amz_linux3.id
#   instance_type          = var.instance_type
#   key_name               = var.instance_keypair
#   #monitoring             = true
#   subnet_id              = module.vpc.public_subnets[0]
#   vpc_security_group_ids = [module.public_bastion_sg.security_group_id]
  
#   tags = local.common_tags

# }

resource "aws_instance" "kubectl_vm" {
  ami                    = data.aws_ami.amz_linux3.id
  instance_type          = var.instance_type
  # user_data = file("${path.module}/app1-install.sh")
  key_name               = var.instance_keypair
  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.public_bastion_sg.security_group_id]
  tags                   = local.common_tags


  provisioner "local-exec" {
    working_dir = "${path.module}"
    command     = "scp -i demokp.pem -r charts/ ec2-user@${self.public_dns}:/home/ec2-user/"
  }

}


resource "null_resource" "installer_script" {
  depends_on = [aws_instance.kubectl_vm]
  
  provisioner "remote-exec" {
    # inline = [
    #   "mv charts/install.sh ~/install.sh",
    #   "chmod +x install.sh",
    #   "sudo ./install.sh"
    # ]
      inline = [
    "yum install -y git",
    "curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3",
    "chmod 700 get_helm.sh",
    "./get_helm.sh",
    "rm get_helm.sh"
  ]

    connection {
      type        = "ssh"
      host        = aws_instance.kubectl_vm.public_ip
      user        = "ec2-user"
      private_key = file("demokp.pem")
    }
  }
}
