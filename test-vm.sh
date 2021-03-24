#!/usr/bin/env bash

# script to test vagrant-in-vagrant vm

set -euo pipefail
set -x

vagrant box add --name vinv --provider libvirt \
  output/vagrant_in_vagrant_0.0.1.box

vagrant init vinv

vagrant up --provider libvirt

vagrant ssh -- bash -c "set -ex; vagrant init generic/alpine312; vagrant up --provider libvirt; vagrant ssh pwd"


