
variable "instance_type"{
    type = string
    default = "t2.micro"
}

variable "project_name"{
    type = string
}

variable "sg_id"{
    type = string
}

variable "subnet_ids_private" {
    type = list(string)
}


variable "lb_target_arn" {
    type = string
}