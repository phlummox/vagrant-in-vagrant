#!/usr/bin/env bash

# script to test vagrant-in-vagrant vm

set -euo pipefail
set -x

vagrant box remove vinv || true

vagrant box add --name vinv --provider libvirt \
  output/vagrant_in_vagrant_0.0.1.box

tmpdir=`mktemp --tmpdir -d packer-test-XXXXXX`

cd "$tmpdir"

# if running on a CI server (probably GitHub) --
# assume we don't have kvm acceleration and must
# use the slower but more general qemu driver.
# Else assume we have access to kvm.
if [ -z "$CI" ]; then
  LIBVIRT_DRIVER=kvm;
else
  LIBVIRT_DRIVER=qemu;
fi

cat > Vagrantfile <<EOF
Vagrant.configure("2") do |config|
  config.vm.box = "vinv"
  config.vm.provider :libvirt do |lv|
    lv.driver = '$LIBVIRT_DRIVER'
  end
end
EOF

# check conts

grep -n ^ /dev/null Vagrantfile

vagrant up --provider libvirt

# Vagrantfile for "nested" vm
# to bring up.

cat > /tmp/Vagrantfile <<EOF
Vagrant.configure("2") do |config|
  config.vm.box = "generic/alpine312"
  config.ssh.password = "vagrant"
  config.ssh.username = "vagrant"
  config.ssh.insert_key = false
end
EOF

# Test to be run on the vagrant VM -
# can we bring up an inner VM?

cat > test-inner-vm.sh <<'END'
set -ex

sudo apt install -y --no-install-recommends \
    libvirt-bin \
    libvirt-dev \
    sshpass

sudo systemctl start libvirtd
sudo systemctl status libvirtd

vagrant box add --provider libvirt generic/alpine312
cp /tmp/Vagrantfile .

vagrant up --no-provision --debug --provider libvirt

: "ssh config conts"

vagrant ssh-config | sed 's/PasswordAuthentication no/PasswordAuthentication yes/' > ssh-config

: "ssh config conts"

grep -n ^ /dev/null ssh-config

sshpass -pvagrant ssh -F ./ssh-config default pwd > pwd_result

pwd_result=`cat pwd_result`

[ "$pwd_result" = "/home/vagrant" ]
END

chmod a+rx test-inner-vm.sh

vagrant upload /tmp/Vagrantfile /tmp/Vagrantfile

vagrant upload ./test-inner-vm.sh /tmp/test-inner-vm.sh

vagrant ssh -- /tmp/test-inner-vm.sh


