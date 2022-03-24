variable "project_name"{
    type = string
}

variable "vpc_id" {
    type = string
}

variable "cidr_block"{
    type = string
}

variable "ports"{
    type = list(string)
}