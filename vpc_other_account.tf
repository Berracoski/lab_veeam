resource "aws_vpc" "test_lab" {
  provider             = aws.at-root
  cidr_block           = "10.127.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-lab-baas"
  }
}

data "aws_availability_zones" "available_oregon" {
  provider = aws.at-root
  state    = "available"
}

## Subredes Publicas

resource "aws_internet_gateway" "gw_lab" {
  provider = aws.at-root
  vpc_id   = aws_vpc.test_lab.id

  tags = {
    Name = "internet-gw"
  }
}

resource "aws_subnet" "public_lab" {
  provider                = aws.at-root
  count                   = 3
  vpc_id                  = aws_vpc.test_lab.id
  cidr_block              = cidrsubnet(aws_vpc.test_lab.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

# Route table publica
resource "aws_route_table" "public_lab" {
  provider = aws.at-root
  vpc_id   = aws_vpc.test_lab.id
  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "public_lab" {
  provider       = aws.at-root
  count          = 3
  subnet_id      = aws_subnet.public_lab[count.index].id
  route_table_id = aws_route_table.public_lab.id
}

resource "aws_route" "public_internet_access_lab" {
  provider               = aws.at-root
  route_table_id         = aws_route_table.public_lab.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw_lab.id
}

## Subredes Privadas

resource "aws_subnet" "private_lab" {
  provider          = aws.at-root
  count             = 3
  vpc_id            = aws_vpc.test_lab.id
  cidr_block        = cidrsubnet(aws_vpc.test_lab.cidr_block, 8, 3 + count.index)
  availability_zone = data.aws_availability_zones.available_oregon.names[count.index]
  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

#Route table privada
resource "aws_route_table" "private_lab" {
  provider = aws.at-root
  vpc_id   = aws_vpc.test_lab.id

  tags = {
    Name = "private"
  }
}

resource "aws_route_table_association" "private_lab" {
  provider       = aws.at-root
  count          = 3
  subnet_id      = aws_subnet.private_lab[count.index].id
  route_table_id = aws_route_table.private_lab.id
}

# resource "aws_route" "private_nat_gateway_route" {
#   route_table_id         = aws_route_table.private.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.nat.id
# }

# #Nat gateway
# resource "aws_eip" "nat" {
#   domain = "vpc"
# }

# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.public[0].id
#   tags = {
#     Name = "nat-gateway"
#   }
# }


## S3 Service Endpoint
resource "aws_vpc_endpoint" "s3_lab" {
  provider          = aws.at-root
  vpc_id            = aws_vpc.test_lab.id
  service_name      = "com.amazonaws.us-west-2.s3"
  vpc_endpoint_type = "Gateway"

  # Attach the endpoint to your private and public route tables
  route_table_ids = [
    aws_route_table.private_lab.id,
    aws_route_table.public_lab.id
  ]

  tags = {
    Name = "s3-gateway-endpoint"
  }
}

# Interface Endpoint for AWS Systems Manager (SSM)
resource "aws_vpc_endpoint" "ssm" {
  provider           = aws.at-root
  vpc_id             = aws_vpc.test_lab.id
  service_name       = "com.amazonaws.us-west-2.ssm"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.private_lab[0].id]
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]

  private_dns_enabled = true

  tags = {
    Name = "ssm-interface-endpoint"
  }
}

resource "aws_vpc_endpoint" "ssm_messages" {
  provider           = aws.at-root
  vpc_id             = aws_vpc.test_lab.id
  service_name       = "com.amazonaws.us-west-2.ssmmessages"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.private_lab[0].id]
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]

  private_dns_enabled = true

  tags = {
    Name = "ssm-messages-interface-endpoint"
  }
}

resource "aws_vpc_endpoint" "ssm_ec2messages" {
  provider           = aws.at-root
  vpc_id             = aws_vpc.test_lab.id
  service_name       = "com.amazonaws.us-west-2.ec2messages"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.private_lab[0].id]
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]

  private_dns_enabled = true

  tags = {
    Name = "ssm-ec2messages-interface-endpoint"
  }
}

# Interface Endpoint for Simple Queue Service (SQS)
resource "aws_vpc_endpoint" "sqs" {
  provider           = aws.at-root
  vpc_id             = aws_vpc.test_lab.id
  service_name       = "com.amazonaws.us-west-2.sqs"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.private_lab[0].id]
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]

  private_dns_enabled = true

  tags = {
    Name = "sqs-interface-endpoint"
  }
}

# Interface Endpoint for Elastic Block Store (EBS)
resource "aws_vpc_endpoint" "ebs" {
  provider           = aws.at-root
  vpc_id             = aws_vpc.test_lab.id
  service_name       = "com.amazonaws.us-west-2.ebs"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.private_lab[0].id]
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]

  private_dns_enabled = true

  tags = {
    Name = "ebs-interface-endpoint"
  }
}

# Interface Endpoint for Kinesis Data Streams
resource "aws_vpc_endpoint" "kinesis" {
  provider           = aws.at-root
  vpc_id             = aws_vpc.test_lab.id
  service_name       = "com.amazonaws.us-west-2.kinesis-streams"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.private_lab[0].id]
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]

  private_dns_enabled = true

  tags = {
    Name = "kinesis-interface-endpoint"
  }
}

# Security group for interface endpoints to allow required traffic
resource "aws_security_group" "vpc_endpoint_sg" {
  provider    = aws.at-root
  name        = "vpc-endpoint-sg"
  description = "Security group for VPC interface endpoints"
  vpc_id      = aws_vpc.test_lab.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.test_lab.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}