variable "instance_network" {
  description = "Network for the instance"
  default     = "mcnetwork"
}

variable "instance_name" {
    description = "name for instance"
    default     = "mcvm"
  }

variable "project_name" {
    description = "Project name where resources will be deployed"
    default     = "minecraft-server-terraform"
}

variable "region_name" {
    description = "Region where resources will be deployed"
    default     = "australia-southeast1"
}

variable "zone_name" {
    description = "Zone where resources will be deployed"
    default     = "australia-southeast1-a"
}


variable "machine_type" {
    description = "Type of instance to deploy"
    default     = "n1-standard-1"
}

variable "instance_image" {
    description = "Image for instance"
    default = "debian-cloud/debian-9"
}

variable "subnetwork" {
    description = "The name of the subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in. Either network or subnetwork must be provided."
    default     = ""
}

