# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.vm.box = "trusty64_vmware"
  config.vm.box_url = 'https://oss-binaries.phusionpassenger.com/vagrant/boxes/latest/ubuntu-14.04-amd64-vmwarefusion.box'
  config.ssh.forward_agent = true
  config.dns.tld = "dev"

  current_path = File.expand_path('..', __FILE__)
  Dir[File.join(current_path, 'projects', '**', 'Vagrantfile')].each do |m|
    eval(File.read(m), binding, m)
  end
end
