# Get latest AMI ID for Amazon Linux2 OS
data "aws_ami" "amz_linux3" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.1.20230809.0-kernel-6.1-x86_64"]
    
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
    filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

