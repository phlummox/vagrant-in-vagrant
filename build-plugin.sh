#!/usr/bin/env bash

# script to be build libvirt plugin for vagrant
#
# Prerequisites: sudo and curl (and ca-certificates,
# to use https) should be installed

set -euo pipefail
set -x

sudo apt-get update

VAGRANT_VERSION="2.2.14"
curl -L https://releases.hashicorp.com/vagrant/${VAGRANT_VERSION}/vagrant_${VAGRANT_VERSION}_x86_64.deb > vagrant.deb

sudo apt install "$PWD/vagrant.deb"

cat > install_packages.sh <<END
DEBIAN_FRONTEND=noninteractive apt-get install \
    -y --no-install-recommends       \
        apt-transport-https          \
        bridge-utils                 \
        build-essential              \
        bzip2                        \
        git                          \
        libguestfs-tools             \
        libvirt-bin                  \
        libvirt-dev                  \
        libxml2-dev                  \
        libxslt-dev                  \
        locales                      \
        make                         \
        pkg-config                   \
        qemu-kvm                     \
        ruby-dev                     \
        software-properties-common   \
        tar                          \
        unzip                        \
        wget                         \
        xz-utils                     \
        zlib1g-dev                   \
        zip
END

sudo bash install_packages.sh

include_dir=`pkg-config --variable=includedir libvirt`
lib_dir=`pkg-config --variable=libdir libvirt`
CONFIGURE_ARGS="with-libvirt-include=$include_dir with-libvirt-lib=$lib_dir" \
    vagrant --debug plugin install --verbose vagrant-libvirt


