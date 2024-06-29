variable "proxmox_ip" {
  default =  "192.168.0.11"
}

#####################################################
#           resrource.tf                            #
#####################################################

variable "os_template" {
  default = "vztmpl/ubuntu-23.10-standard_23.10-1_amd64.tar.zst"
}

variable "vmid" {
  default = 111
  type = number
}

variable "hostname" {
  default = "SRINP01"
}

variable "cores" {
  default = 2 
  type = number
  description = "Cores iniciais"
}

variable "memory" {
  default = 2048
  type = number
  description = "Memoria inicial do servidor"
}

variable "disk_size" {
  default = "90G"
  description = "Valor em GB que o SO deve ter"
}

variable "ip" {
  default = "192.168.0.4"
}

variable "gateway" {
  default = "192.168.0.10"
}

variable "nameserver" {
  default = "192.168.0.20"
}