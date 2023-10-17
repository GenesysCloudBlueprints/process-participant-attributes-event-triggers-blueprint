terraform {
  required_version = ">= 1.1.4" 
  required_providers {
    archive = {
      version = ">= 2.0"
      source  = "hashicorp/archive"
    }
    genesyscloud = {
      source = "myPureCloud/genesyscloud"
      version = "1.23.0"
    }
  }
}