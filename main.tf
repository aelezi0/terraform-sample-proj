provider "aws" {
  region = "us-west-2"
}

#vpc
resource "aws_vpc" "root_ec2_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "root-ec2-vpc"
  }
}

#internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.root_ec2_vpc.id
}


#route table
resource "aws_route_table" "root_ec2_rt" {
  vpc_id = aws_vpc.root_ec2_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "root-ec2-route-table"
  }
}

#subnet
resource "aws_subnet" "root_ec2_subnet" {
  vpc_id = aws_vpc.root_ec2_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    "Name" = "root-ec2-subnet"
  }
}

#route table association
resource "aws_route_table_association" "root_ec2_subnet_rt_link" {
  subnet_id      = aws_subnet.root_ec2_subnet.id
  route_table_id = aws_route_table.root_ec2_rt.id
}

#security group
resource "aws_security_group" "root_ec2_allow_ssh_sg" {
  name        = "root_ec2_allow_ssh_sg"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.root_ec2_vpc.id

  ingress {
    description = "TLS from VPC"
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


  tags = {
    Name = "allow_ssh"
  }
}



#network interface
resource "aws_network_interface" "root_ec2_nic" {
  subnet_id       = aws_subnet.root_ec2_subnet.id
  private_ips     = ["10.0.1.53"]
  security_groups = [aws_security_group.root_ec2_allow_ssh_sg.id]

}

#elastic ip
resource "aws_eip" "root_ec2_eip" {
  network_interface = aws_network_interface.root_ec2_nic.id
  vpc      = true
  associate_with_private_ip = "10.0.1.53"

  depends_on = [ aws_network_interface.root_ec2_nic]
}

#ec2 instance
resource "aws_instance" "aws_linux_instance" {
  ami = "ami-06999a8dddda0d0b3"
  instance_type = "t2.micro"
  availability_zone = "us-west-2a"
  key_name = "root-key"

  depends_on = [ aws_network_interface.root_ec2_nic]
  network_interface {
    device_index = 0
    network_interface_id=aws_network_interface.root_ec2_nic.id
  }
}

