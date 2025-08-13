# Create an EFS file system
resource "aws_efs_file_system" "lab_efs_test" {
  provider       = aws.at-root
  creation_token = "lab-efs"
  encrypted      = true
  tags = {
    Name = "lab-efs"
  }
}

# Create mount targets for the EFS in specific subnets (replace subnet IDs)
resource "aws_efs_mount_target" "mount_target_1" {
  provider        = aws.at-root
  file_system_id  = aws_efs_file_system.lab_efs_test.id
  subnet_id       = aws_subnet.private_lab[1].id
  security_groups = [aws_security_group.efs_sg.id]
}


resource "aws_security_group" "efs_sg" {
  provider    = aws.at-root
  name        = "efs_sg"
  description = "Security group for EFS mount targets"
  vpc_id      = aws_vpc.test_lab.id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.veeam_lab.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}