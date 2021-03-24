# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.boot_timeout = 1800
  config.vm.box = "phlummox/vagrant-in-vagrant"
  config.vm.hostname = "vagrant-in-vagrant.local"
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # pick a non-default network, so that when people
  # create a libvirt vm *within* the VM, they
  # can just use the default, and it won't clash.
  #
  # See e.g. https://nts.strzibny.name/inception-running-vagrant-inside-vagrant-with-kvm/
  config.vm.provider :libvirt do |p|
    p.management_network_name = 'vagrant-libvirt-new'
    p.management_network_address = '192.168.124.0/24'
  end

end
