#!/usr/bin/env bash

# extract plugin tar from docker container

# Prerequisites: sudo and curl (and ca-certificates,
# to use https) should be installed

set -euo pipefail
set -x

image=phlummox/libvirt-plugin:0.1

container_id=`docker create $image`
docker cp $container_id:vagrant.d.tgz .
docker rm $container_id

