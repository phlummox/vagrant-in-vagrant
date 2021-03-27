# vagrant-in-vagrant

[![build](https://github.com/phlummox/vagrant-in-vagrant/actions/workflows/ci.yml/badge.svg)](https://github.com/phlummox/vagrant-in-vagrant/actions/workflows/ci.yml)

Builds and uploads (to the GitHub releases page, and to the
Vagrant Cloud, in the case of the box):

- The [libvirt plugin][plugin] for Vagrant, built on Ubuntu 18.04.
- A [Vagrant][vagrant] box, based on Ubuntu 18.04, containing Vagrant
  and the libvirt driver.

[plugin]: https://github.com/vagrant-libvirt/vagrant-libvirt
[vagrant]: https://github.com/vagrant-libvirt/vagrant-libvirt

Together these can be used to run Vagrant boxes within Vagrant
boxes, even on Continuous Integration (CI) servers that don't support
(for instance) VirtualBox, or provide hardware-based acceleration.

Why would you want that? Usually, because you're wanting to
build and test virtual machines on a CI server.

## Prerequisites

`packer` and `vagrant` need to be installed - see the `.github` CI
file for how to do this.

The build also requires the following Ubuntu packages to be
installed:

- `pv` - used for giving progress feedback in the makefile
-  `qemu-utils` and `qemu-kvm`

## Building

```
make packer-build
```

## Using the plugin

Download `vagrant.d.tgz` from the [Releases][releases] page,
and un-tar it into your home directory.

[releases]: https://github.com/phlummox/vagrant-in-vagrant/releases/

## Using the box

```
$ vagrant init phlummox/vagrant-in-vagrant
$ vagrant up
```

<!--
  vim: ts=2 sw=2 et tw=72 :
-->
