# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.boot_timeout = 1800
  config.vm.box = "phlummox/vagrant-in-vagrant"
  config.vm.hostname = "vagrant-in-vagrant.local"
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provider :libvirt do |lv|
    # pick a non-default network, so that when people
    # create a libvirt vm *within* the VM, they
    # can just use the default, and it won't clash.
    #
    # See e.g. https://nts.strzibny.name/inception-running-vagrant-inside-vagrant-with-kvm/
    lv.management_network_name = 'vagrant-libvirt-new'
    lv.management_network_address = '192.168.124.0/24'

    # Use 'kvm' as a driver, by default; if end-user wants
    # to use some other driver, they can specify explicitly.
    #
    # Why? Because it seems if we tell packer to use the default
    # ("choose kvm if available, otherwise software accel")
    # then this seems to result in the package .box not using
    # kvm by default -- and we want it to, usually.
    lv.driver = 'kvm'
  end

end
