# Create Elastic IP for Bastion Host
# Resource - depends_on Meta-Argument
resource "aws_eip" "bastion_eip" {
  depends_on = [aws_instance.kubectl_vm, module.vpc ]
  instance = aws_instance.kubectl_vm.id
  # vpc      = true
  tags = local.common_tags  
}
