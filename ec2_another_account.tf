# Ultima ami ubuntu 2404
data "aws_ami" "ubuntu_2404" {
  provider    = aws.at-root
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical's AWS account ID
}


## Veeam test instance with KMS encription
resource "aws_instance" "veeam_lab" {
  provider      = aws.at-root
  ami           = data.aws_ami.ubuntu_2404.id
  instance_type = "t3.micro"
  key_name      = "veeam-test"
  subnet_id     = aws_subnet.private_lab[1].id
  security_groups = [aws_security_group.veeam_lab.name]
  tags = {
    Name = "veeam-lab"
  }

  root_block_device {
    volume_size = 32   # Set desired disk size in GB
    encrypted   = true # Enable encryption
    kms_key_id  = null # Omit or set to null for default AWS KMS key
  }
}

## Security Group for Veeam Lab Instance
resource "aws_security_group" "veeam_lab" {
  provider    = aws.at-root
  name        = "veeam-lab-sg"
  description = "Security group for Veeam lab instance"
  vpc_id      = aws_vpc.test_lab.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "worker_lab" {
  provider    = aws.at-root
  name        = "veeam-lab-sg"
  description = "Security group for Veeam lab instance"
  vpc_id      = aws_vpc.test_lab.id

egress {
    from_port                = 443           # or 0 for all ports
    to_port                  = 443           # or 0 for all ports
    protocol                 = "tcp"         # or "-1" for all protocols
    security_groups          = [aws_security_group.vpc_endpoint_sg.id]
    description              = "Allow outbound to VPC Endpoint SG on port 443"
  }
}