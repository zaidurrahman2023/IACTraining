variable "subscription_id" {
  type        = string
  description = "The subscription ID to use for the Azure resources"
}

variable "location" {
  type        = string
  description = "The Azure region to use for the resources"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group to create"
}

