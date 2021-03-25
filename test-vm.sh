#!/usr/bin/env bash

# script to test vagrant-in-vagrant vm

set -euo pipefail
set -x

vagrant box remove vinv || true

vagrant box add --name vinv --provider libvirt \
  output/vagrant_in_vagrant_0.0.1.box

tmpdir=`mktemp --tmpdir -d packer-test-XXXXXX`

cd "$tmpdir"

vagrant init vinv

vagrant up --provider libvirt

cat > /tmp/Vagrantfile << 'END'
Vagrant.configure("2") do |config|
  config.vm.box = "generic/alpine312"
  config.ssh.password = "vagrant"
  config.ssh.username = "vagrant"
  config.ssh.insert_key = false
end
END

cat > test-inner-vm.sh <<'END'
set -ex

sudo apt install -y --no-install-recommends \
    libvirt-bin \
    libvirt-dev

sudo systemctl start libvirtd
sudo systemctl status libvirtd

sudo iptables --list
sudo iptables -P INPUT ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -F

sudo iptables --list

vagrant box add --provider libvirt generic/alpine312
#vagrant init generic/alpine312
cp /tmp/Vagrantfile .

vagrant ssh-config | sed 's/PasswordAuthentication no/PasswordAuthentication yes/' > ssh-config

vagrant up --no-provision --debug --provider libvirt

sudo apt install sshpass

sshpass -pvagrant ssh -F ./ssh-config default pwd > pwd_result

pwd_result=`cat pwd_result`

[ "$pwd_result" = "/home/vagrant" ]
END

chmod a+rx test-inner-vm.sh

vagrant upload /tmp/Vagrantfile /tmp/Vagrantfile

vagrant upload ./test-inner-vm.sh /tmp/test-inner-vm.sh

vagrant ssh -- /tmp/test-inner-vm.sh


