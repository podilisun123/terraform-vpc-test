### Projecct variables
variable "project_name" {
  type        = string 
}
variable "environment" {
  type        = string 
}
variable "common_tags" {
    type = map
}

### Vpc Variables
variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}
variable "enable_dns_hostnames" {
    type = bool
    default = true
}
variable "vpc_tags" {
    type = map
    default = {}
}
### internet gateway variables
variable "igw_tags" {
    type = map
    default = {}
}
### public subnet 
variable "public_subnet_cidrs" {
    type = list
    validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "please give valid 2 public subnet cidrs"
  }
}
variable "public_subnet_tags" {
    type = map
    default = {}
}
### private subnet 
variable "private_subnet_cidrs" {
    type = list
    validation {
    condition     = length(var.private_subnet_cidrs) == 2
    error_message = "please give valid 2 private subnet cidrs"
  }
}
variable "private_subnet_tags" {
    type = map
    default = {}
}
### database subnet 
variable "database_subnet_cidrs" {
    type = list
    validation {
    condition     = length(var.database_subnet_cidrs) == 2
    error_message = "please give valid 2 database subnet cidrs"
  }
}
variable "database_subnet_tags" {
    type = map
    default = {}
}
### database subnet group 
variable "db_subnet_group_tags" {
    type = map
    default = {}
}
### nat gateway 
variable "ngw_tags" {
    type = map
    default = {}
}
### route table tags
variable "public_route_table_tags" {
    type = map
    default = {}
}
variable "private_route_table_tags" {
    type = map
    default = {}
}
variable "database_route_table_tags" {
    type = map
    default = {}
}
### peering variables
variable "is_peering_required" {
    type = bool
}
variable "acceptor_vpc_id" {
    type = string
    default = ""
}
variable "peering_tags" {
    type = map
    default = {}
}
