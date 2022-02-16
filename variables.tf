##### Provider
# - Arguments to configure the VMware vSphere Provider
variable "vultr_api_key" {
  description = "API Key for programmatic access to Vultr"
  default     = "NBCA5UNLVVJDVZ7AC5DXJBZIYHSLPUMBHPNA"
}

##### Instance Parameters

# see https://api.vultr.com/v2/regions
variable "vultr_instance_region" {
  description = "The Vultr datacenter in which the resources should reside"
  default     = "nrt" # Tokyo / Asia
}

# see https://api.vultr.com/v2/plans
variable "vultr_instance_plan" {
  description = "instance size from available VULTR plans"
  default     = "vc2-2c-4gb" # cloud compute, 1 vCPU, 1 GB
}

# see https://api.vultr.com/v2/os
variable "vultr_instance_os_id" {
  description = "numeric ID of the desired OS flavor"
  default     = "387" # Ubuntu 20.04 x64
}

# Name of the user account created
variable "instance_user" {
  description = "user to be created inside the instance"
  default     = "vultr"
}

# Prefix for the instance(s) created
variable "instance_prefix" {
  description = "vm prefix for generated instances"
  default     = "myvps"
}

# Amount of instances
variable "instance_count" {
  description = "amount of instances to create"
  default     = "2"
}
