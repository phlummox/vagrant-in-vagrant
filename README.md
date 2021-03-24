# vagrant-in-vagrant

A vagrant box, containing vagrant.

(Plus the libvirt plugin for vagrant.)

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
