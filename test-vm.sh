#!/usr/bin/env bash

# script to test vagrant-in-vagrant vm

set -euo pipefail
set -x

vagrant box add --name vinv --provider libvirt \
  output/vagrant_in_vagrant_0.0.1.box

vagrant init vinv

: "show id"

id

vagrant up --provider libvirt

vagrant ssh -- bash -c "echo ssh-ing; set -ex; vagrant box add --provider libvirt generic/alpine312;  vagrant init generic/alpine312; vagrant up --debug --provider libvirt; vagrant ssh pwd"


