variable "rgname"{
    type = string
    description = "resource name"
}
variable "rgloc"{
    type = string
    description = "place of the resource to deployed"
}

variable "virnet"{
    type = string
    description = "name of the virtual network"
}

variable "addrspace"{
    type = string
    description = "cidr address space for virtual network"
}

variable "sunet"{
    type = string
    description ="name of the subnet"
}

variable "snetaddrsp"{
    type = string
    description = "cidr address space for subnet"
}