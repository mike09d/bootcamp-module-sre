variable "project_name"{
    type = string
}

variable "sg_id"{
    type = string
}

variable "subnet_ids_private" {
    type = list(string)
}

variable "vpc_id" {
    type = string
}


variable "ag_backend_id"{
    type = string
}