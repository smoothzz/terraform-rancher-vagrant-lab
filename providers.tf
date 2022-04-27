provider "rke" {
  log_file = "rke_debug.log"
}

provider "rancher2" {
  api_url    = var.rancher_url
  access_key = var.rancher2_access_key
  secret_key = var.rancher2_secret_key
  insecure   = "true"
}