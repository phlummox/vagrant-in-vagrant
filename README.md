# vagrant-in-vagrant

Builds and uploads (to the GitHub releases page, and to the
Vagrant Cloud, in the case of the box):

- The libvirt plugin for vagrant, built on Ubuntu 18.04.
- A vagrant box, based on Ubuntu 18.04, containing vagrant
  and the libvirt driver.

Together these can be used to run vagrant boxes within vagrant
boxes, even on Continuous Integration (CI) servers that don't support
(for instance) VirtualBox, or provideahardware-based acceleration.

Why would you want that? Usually, because you're wanting to
build and test virtual machines on a CI server.

## Prerequisites

`packer` and `virtualbox` need to be installed - see the `.github` CI
file for how to do this.

The build also requires the following Ubuntu packages to be
installed:

- `pv` - used for giving progress feedback in the makefile
-  `qemu-utils` and `qemu-kvm`

## Building

```
make packer-build
```

<!--
  vim: ts=2 sw=2 et tw=72 :
-->
