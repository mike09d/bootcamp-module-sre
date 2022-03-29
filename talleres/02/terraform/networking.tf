## NETWORKING
data "aws_vpc" "default" {
    id = "vpc-080aa58352099dcb7"
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.default.id

  tags = {
    tier = "private"
  }
}