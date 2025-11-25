# Create an RDS subnet group with private subnets
resource "aws_db_subnet_group" "private_subnet_group" {
  provider   = aws.at-root
  name       = "my-private-db-subnet-group"
  subnet_ids = aws_subnet.private_lab[*].id

  tags = {
    Name = "Private DB Subnet Group"
  }
}

# Generate a random secure password for the RDS admin user
resource "random_password" "rds_admin_password" {
  length  = 16
  special = false

  min_upper   = 2
  min_lower   = 4
  min_numeric = 2
}

# Create an AWS Secrets Manager secret to store the RDS admin credentials
resource "aws_secretsmanager_secret" "rds_admin" {
  provider    = aws.at-root
  name        = "rds_admin_password"
  description = "Admin password for RDS MySQL instance"
  tags = {
    Environment = "lab"
  }
}

# Put the generated password into a new secret version (actual secret value stored here)
resource "aws_secretsmanager_secret_version" "rds_admin_version" {
  provider  = aws.at-root
  secret_id = aws_secretsmanager_secret.rds_admin.id

  # Store a JSON string with username and password in secret_string
  secret_string = jsonencode({
    username = "mydbadmin"
    password = random_password.rds_admin_password.result
  })
}



# Security group for the RDS instance allowing MySQL inbound from private subnet CIDR or SG
resource "aws_security_group" "rds_sg" {
  provider    = aws.at-root
  name        = "rds_sg"
  description = "Allow MySQL from private subnet"
  vpc_id      = aws_vpc.test_lab.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.test_lab.cidr_block] # Or specify private subnet CIDRs if more restrictive
    # Alternatively, you can allow security group id:
    # security_groups = [<your_ec2_or_app_security_group_id>]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the RDS MySQL instance inside private subnets
resource "aws_db_instance" "mysql_instance" {
  provider               = aws.at-root
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = "mydatabase"
  username               = "mydbadmin"
  password               = random_password.rds_admin_password.result
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  publicly_accessible    = false # Not publicly accessible
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.private_subnet_group.name
  identifier             = "my-rds-mysql-instance"

  tags = {
    Name = "MyPrivateMySQLRDS"
  }
}

# Create the RDS PostgreSQL instance inside private subnets
resource "aws_db_instance" "postgres_instance" {
  provider               = aws.at-root
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "15" # Latest stable PostgreSQL version; adjust as needed
  instance_class         = "db.t3.micro"
  db_name                = "mydatabase"
  username               = "mydbadmin"
  password               = random_password.rds_admin_password.result
  parameter_group_name   = "default.postgres15"
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.private_subnet_group.name
  identifier             = "my-rds-postgres-instance"

  tags = {
    Name = "MyPrivatePostgresRDS"
  }
}

# Create a DynamoDB table
resource "aws_dynamodb_table" "veeam_lab_table" {
  provider     = aws.at-root
  name         = "veeam_lab_table"
  billing_mode = "PAY_PER_REQUEST" # On-demand capacity

  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = "Veeam-LAB DynamoDB Table"
  }
}
