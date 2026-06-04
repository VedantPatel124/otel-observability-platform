variable "region" {
    description = "The AWS region to deploy resources in."
    type        = string
    default     = "us-east-1"
}

variable "vpc_cidr" {
    description = "The CIDR block for the VPC."
    type        = string
    default     = "10.0.0.0/16"
}

variable "availability_zones" {
    description = "List of availability zones to use for the subnets."
    type        = list(string)
    default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "public_subnet_cidrs" {
    description = "List of CIDR blocks for public subnets."
    type        = list(string)
    default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
    description = "List of CIDR blocks for private subnets."
    type        = list(string)
    default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "cluster_name" {
    description = "The name of the EKS cluster."
    type        = string
    default     = "demo-eks-cluster"
}

variable "cluster_version" {
    description = "The Kubernetes version for the EKS cluster."
    type        = string
    default     = "1.30"
}

variable "node_groups" {
    description = "List of node group configurations for the EKS cluster."
    type = map(object({
        instance_types   = list(string)
        capacity_type   = string
        scaling_config = object({
            desired_size     = number
            min_size         = number
            max_size         = number
        })
    }))
    default = {
        general = {
            instance_types   = ["t3.medium"]
            capacity_type   = "ON_DEMAND"
            scaling_config = {
                desired_size     = 2
                min_size         = 1
                max_size         = 3
            }
        }
    }
}