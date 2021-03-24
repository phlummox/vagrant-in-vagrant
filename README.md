# vagrant-in-vagrant

A vagrant box, containing vagrant.

(Plus the libvirt plugin for vagrant.)

## Prerequisites

`packer` and `virtualbox` need to be installed - see the `.github` CI
file for how to do this.

The build also requires the Ubuntu packages `pv` and `qemu-utils` to be
installed.

## Building

```
make packer-build
```

<!--
  vim: ts=2 sw=2 et tw=72 :
-->
