#!/usr/bin/env bash

# script to provision vagrant-in-vagrant vm
#
# Prerequisites:
# - the libvirt plugin must have been built
#   and be at /tmp/vagrant.d.tgz
# - sudo, curl and ca-certificates must
#   already be installed (which they should be, for most
#   vagrant boxes)

set -euo pipefail
set -x

sudo apt-get update

VAGRANT_VERSION="2.2.14"
curl -L https://releases.hashicorp.com/vagrant/${VAGRANT_VERSION}/vagrant_${VAGRANT_VERSION}_x86_64.deb > /tmp/vagrant.deb

sudo apt install "/tmp/vagrant.deb"

cat > /tmp/install_packages.sh <<END
DEBIAN_FRONTEND=noninteractive apt-get install \
    -y --no-install-recommends      \
        bzip2                       \
        libvirt-bin                 \
        qemu-kvm                    \
        qemu-utils                  \
        tar                         \
        unzip                       \
        virtinst                    \
        wget                        \
        xz-utils                    \
        zip
END

sudo bash /tmp/install_packages.sh

sudo adduser $USER libvirt
sudo adduser $USER kvm

tar xf /tmp/vagrant.d.tgz -C ~

