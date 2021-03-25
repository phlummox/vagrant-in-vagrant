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

cat > test-inner-vm.sh <<'END'
set -ex
vagrant box add --provider libvirt generic/alpine312
vagrant init generic/alpine312
vagrant up --debug --provider libvirt
the_pwd=`vagrant ssh -- pwd`
[ "$the_pwd" = "/home/vagrant" ]
END

chmod a+rx test-inner-vm.sh

vagrant upload ./test-inner-vm.sh /tmp/test-inner-vm.sh

vagrant ssh -- /tmp/test-inner-vm.sh


