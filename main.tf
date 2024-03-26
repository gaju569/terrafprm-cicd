provider "aws" {
  region = "us-east-1"
}

// Create Key Pair
resource "aws_key_pair" "example_key_pair" {
  key_name   = "example_key" // Name for your key pair
  public_key = file("~/.ssh/id_rsa.pub") // Path to your public key file
}

// Create VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "ExampleVPC"
  }
}

// Create Subnet
resource "aws_subnet" "example_subnet" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "ExampleSubnet"
  }
}

// Create Internet Gateway
resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id
  tags = {
    Name = "ExampleIGW"
  }
}

// Create Route Table
resource "aws_route_table" "example_route_table" {
  vpc_id = aws_vpc.example_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id
  }

  tags = {
    Name = "ExampleRouteTable"
  }
}

// Associate Route Table with Subnet
resource "aws_route_table_association" "example_route_table_association" {
  subnet_id      = aws_subnet.example_subnet.id
  route_table_id = aws_route_table.example_route_table.id
}

// Create Security Group
resource "aws_security_group" "example_security_group" {
  vpc_id = aws_vpc.example_vpc.id

  // Inbound rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] // Allow SSH from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] // Allow HTTP from anywhere
  }

  // Outbound rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ExampleSecurityGroup"
  }
}

// Create EC2 instance
resource "aws_instance" "example_instance" {
  ami           = "ami-080e1f13689e07408" // Example AMI, replace it with your desired AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.example_subnet.id
  security_groups = [aws_security_group.example_security_group.id]
  key_name      = aws_key_pair.example_key_pair.key_name // Use the created key pair

  // Assign a public IP address
  associate_public_ip_address = true

  tags = {
    Name = "ExampleInstance"
  }
}
