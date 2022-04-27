resource "rke_cluster" "cluster" {
  
  ssh_key_path = "~/.ssh/id_rsa"

  nodes {
    address = "192.168.56.200"
    user    = "vagrant"
    role    = ["controlplane", "worker", "etcd"]
  }
  nodes {
    address = "192.168.56.210"
    user    = "vagrant"
    role    = ["worker"]
  }
  nodes {
    address = "192.168.56.220"
    user    = "vagrant"
    role    = ["worker"]
  }
#   nodes {
#     address = "192.168.56.230"
#     user    = "vagrant"
#     role    = ["worker"]
#   }
  
  upgrade_strategy {
    max_unavailable_worker = "20%"
    drain                  = true
    drain_input {
      ignore_daemon_sets = true
    }
  }

  network {
    plugin = "calico"
  }

  services {
    etcd {
      backup_config {
        interval_hours = 12
        retention      = 6
      }
    }
  }
}

resource "local_file" "kube_cluster_yaml" {
  filename = "${path.root}/kube_config_cluster.yml"
  content  = rke_cluster.cluster.kube_config_yaml
}

resource "rancher2_cluster" "rke-cluster" {
  name = "rke-cluster"

  provisioner "local-exec" {
    command = <<-EOF
      curl --insecure -sfLo manifest.yaml \
      ${rancher2_cluster.rke-cluster.cluster_registration_token.0.manifest_url}
    EOF
  }
  provisioner "local-exec" {
    command = <<-EOF
      export KUBECONFIG=${local_file.kube_cluster_yaml.filename} \
       && kubectl apply -f manifest.yaml
    EOF
  }
}