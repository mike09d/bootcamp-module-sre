## NETWORKING
data "aws_vpc" "default" {
    id = "vpc-0c2eb5aebaa7bb988"
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.default.id

  tags = {
    Reach = "public"
  }
}