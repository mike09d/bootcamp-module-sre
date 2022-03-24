## SECURITY GROUP

resource "aws_security_group" "main" {
    count = length(var.ports)
    name = "${var.project_name}-${var.ports[count.index]}"
    description = "Allow http and https traffict only"
    vpc_id = var.vpc_id
    

    ingress {
        description = "TLS from VPC and the net"
        from_port   = var.ports[count.index]
        to_port     = var.ports[count.index]
        protocol    = "tcp"
        cidr_blocks = [var.cidr_block, "0.0.0.0/0"]
    }
    
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}