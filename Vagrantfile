VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Configure The Box
  config.vm.box = 'bento/centos-5.11'
  config.vm.hostname = 'nssbox-co5'

  # Don't Replace The Default Key https://github.com/mitchellh/vagrant/pull/4707
  config.ssh.insert_key = false

  if Vagrant.has_plugin?("vagrant-cachier")
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box
  end

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', '2048']
    vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    vb.gui = true
    vb.linked_clone = false if Vagrant::VERSION =~ /^1.8/
  end

  config.vm.provider :vmware_fusion do |v|
    v.memory = 2048
    v.cpus = 2
    v.gui = true
    v.linked_clone = false
  end

  # Configure Port Forwarding
  config.vm.network 'forwarded_port', guest: 80, host: 8000, auto_correct: true
  config.vm.network 'forwarded_port', guest: 443, host: 4430, auto_correct: true
  config.vm.network 'forwarded_port', guest: 3306, host: 33060, auto_correct: true
  config.vm.network 'forwarded_port', guest: 5432, host: 54320, auto_correct: true
  config.vm.network 'forwarded_port', guest: 35729, host: 35729, auto_correct: true

  config.vm.synced_folder './', '/vagrant', disabled: true

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = true
  end

  # Run The Base Provisioning Script
  config.vm.provision 'shell', path: './scripts/virtualbox_tools-centos.sh'
  config.vm.provision 'shell', path: './scripts/update-centos.sh'
  config.vm.provision 'shell', path: './scripts/vmware_tools-centos.sh'
  config.vm.provision :reload

  config.vm.provision 'shell', path: './provision/install.yum-repo.sh'
  config.vm.provision 'shell', path: './provision/install.linux.core.sh'
  config.vm.provision 'shell', path: './provision/configure.security.sh'
  config.vm.provision 'shell', path: './provision/install.apache.sh'
  config.vm.provision 'shell', path: './provision/install.postgres.sh'
  config.vm.provision 'shell', path: './provision/install.php-5.4.sh'
  config.vm.provision 'shell', path: './provision/install.scm.sh'

  config.vm.provision 'shell', path: './provision/install.jdk8.sh'
  config.vm.provision 'shell', path: './provision/install.composer.sh'
  config.vm.provision 'shell', path: './provision/install.jdk6.sh'

  config.vm.provision 'shell', path: './provision/install.tomcat.sh'
  config.vm.provision 'shell', path: './provision/install.activemq.sh'
  config.vm.provision :reload


end
