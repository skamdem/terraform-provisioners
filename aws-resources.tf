resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"  
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.vpc.id  
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = aws_vpc.vpc.cidr_block
    map_public_ip_on_launch = true
    availability_zone = "us-east1a"
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }  
}

resource "aws_route_table_association" "gateway_route" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "rules" {
    name = "example"
    vpc_id = aws_vpc.vpc.id

    ingress {
        from_port = 22
        to_port = 22
        proctocol = "tcp"
        cidr_blocks = ["${var.my_ip}/32"]
    }  
}