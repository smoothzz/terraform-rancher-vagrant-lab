machines = {
  "rke01" => {"memory" => "4096", "cpu" => "4", "ip" => "200", "image" => "centos/7"},
  "rke02" => {"memory" => "1024", "cpu" => "1", "ip" => "210", "image" => "centos/7"},
  "rke03" => {"memory" => "1024", "cpu" => "1", "ip" => "220", "image" => "centos/7"},
  "rke04" => {"memory" => "1024", "cpu" => "1", "ip" => "230", "image" => "centos/7"},
}

Vagrant.configure("2") do |config|
  machines.each do |name, conf|
    config.vm.define "#{name}" do |machine|
      machine.vm.box = "#{conf["image"]}"
      machine.vm.network "private_network", ip: "192.168.56.#{conf["ip"]}"
      machine.vm.provider "virtualbox" do |vb|
        vb.name = "#{name}"
        vb.memory = conf["memory"]
        vb.cpus = conf["cpu"]
      end
      machine.vm.provision "shell" do |s|
        ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
        s.inline = <<-SHELL
          echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
          mkdir /root/.ssh
          echo #{ssh_pub_key} >> /root/.ssh/authorized_keys
          systemctl disable firewalld --now
          swapoff -a
          curl -fsSL https://get.docker.com/ | sh
          usermod -aG docker vagrant
          systemctl enable docker --now
          hostnamectl set-hostname #{name}
        SHELL
      end
    end
  end
end