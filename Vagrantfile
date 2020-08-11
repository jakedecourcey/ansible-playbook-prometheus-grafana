# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "test" do |test|
    test.vm.box = "ubuntu/bionic64"
    test.vm.network :forwarded_port, guest: 9090, host: 9090
    test.vm.network :forwarded_port, guest: 9100, host: 9100
    test.vm.network :forwarded_port, guest: 3000, host: 3000
    test.vm.network :forwarded_port, guest: 9093, host: 9093
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
    ansible.groups = {
      "server" => ["test"]
    }
    ansible.extra_vars = {
      grafana_auth_anonymous_org_name: "admin@localhost",
      prometheus_host_files_source: "roles/prometheus/files/vagrant-hosts/"
    }
  end

end
