terraform {
  required_providers {
    rke = {
      source = "rancher/rke"
      version = "1.3.0"
    }
    rancher2 = {
      source = "rancher/rancher2"
      version = "1.23.0"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}