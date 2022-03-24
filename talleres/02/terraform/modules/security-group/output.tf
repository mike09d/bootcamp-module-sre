output "ids"{
    value = aws_security_group.main.*.id
}