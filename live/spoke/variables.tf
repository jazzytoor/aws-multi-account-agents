variable "service" {
  type = string
}

variable "region" {
  type = string
}

variable "ado" {
  type = map(string)
}

variable "spoke_account_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "stack" {
  type = string
}

variable "vpc_id" {
  type = string
}
