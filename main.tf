provider "aws" {
  region = "us-west-2"
}



# resource "aws_instance" "my_first_server" {
#   ami           = "ami-07dd19a7900a1f049"
#   instance_type = "t2.micro"
# }

# resource "aws_vpc" "my_first_vpc" {
#   cidr_block = "10.0.0.0/16"
#   tags = {
#     Name = "first-vpc"
#   }
# }

# resource "aws_subnet" "my_subnet" {
#   vpc_id = aws_vpc.my_first_vpc.id
#   cidr_block = "10.0.1.0/24"
#   map_public_ip_on_launch = true

#   tags = {
#     Name="my-subnet"
#   }
# }

# resource "aws_subnet" "my_subne_2" {
#   vpc_id = aws_vpc.my_first_vpc.id
#   cidr_block = "10.0.2.0/24"
#   map_public_ip_on_launch = true

#   tags = {
#     Name="my-subnet-2"
#   }
# }