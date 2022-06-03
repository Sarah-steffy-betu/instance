resource "aws_security_group" "SG-ADMIN" {
        name = "SG-ADMIN"
        description = "SG-ADMIN"
        vpc_id = "${aws_vpc.Gr10_vpc.id}"

	
	ingress {
	                description = "Auto Generated Rule"
	                from_port = 22
	                to_port = 22
	                protocol = "tcp"
	                cidr_blocks = ["0.0.0.0/0"]
	}


        egress {
                description = "Allow out Traffic"
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["0.0.0.0/0"]
                ipv6_cidr_blocks = []
        }
}