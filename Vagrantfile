require 'json'

VAGRANTFILE_API_VERSION ||= "2"

rootPath = File.dirname(__FILE__)
vagrantDir = rootPath + "/vagrant"
provisionDir = vagrantDir + "/provision"
finalScript = vagrantDir + "/final.sh"
startScript = vagrantDir + "/start.sh"
configFile = vagrantDir + "/config.json"
bootedFlag = vagrantDir + "/booted"

defaultProvider = "virtualbox"
defaultBox = "centos/7"
defaultHostName= "vagrant"

# load settings
settings = JSON.parse(File.read(configFile))  

# Set The VM Provider
ENV['VAGRANT_DEFAULT_PROVIDER'] = settings["provider"] ||= defaultProvider

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    # disable check update
    config.vm.box_check_update = false
    config.vm.post_up_message = "Ok now. Your machine booted!"

    # ssh key config
    config.ssh.insert_key = false

    # if the completed flag file is existed, 
    # it means the custom ssh public key is added into the guest authorized_key file
    # it is possible to use the custom private key now
    if File.exist? bootedFlag then
        config.ssh.private_key_path = settings["key"]
    end

    # Configure The Public Key For SSH Access
    if settings.include? 'authorize'
        if File.exists? File.expand_path(settings["authorize"])
            config.vm.provision "shell" do |s|
                s.inline = "echo $1 | grep -xq \"$1\" /home/vagrant/.ssh/authorized_keys || echo \"\n$1\" | tee /home/vagrant/.ssh/authorized_keys"
                s.args = [File.read(File.expand_path(settings["authorize"]))]
            end
        end
    end


    # Prevent TTY Errors
    config.ssh.shell = "sudo bash -c 'BASH_ENV=/etc/profile exec bash'"

    # Configure The Box
    config.vm.box = settings["box"] ||= defaultBox
    config.vm.hostname = settings["hostname"] ||= defaultHostName

    # Configure A Private Network IP
    config.vm.network :private_network, ip: settings["ip"] ||= "192.168.10.10"

    # Configure Additional Networks
    if settings.has_key?("networks")
      settings["networks"].each do |network|
        config.vm.network network["type"], ip: network["ip"], bridge: network["bridge"] ||= nil
      end
    end

    # Configure A Few VirtualBox Settings
    config.vm.provider "virtualbox" do |vb|
      vb.name = settings["name"] ||= "vagrant-vm"
      vb.customize ["modifyvm", :id, "--memory", settings["memory"] ||= "2048"]
      vb.customize ["modifyvm", :id, "--cpus", settings["cpus"] ||= "1"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--ostype", "RedHat_64"]
    end

     # Standardize Ports Naming Schema
    if (settings.has_key?("ports"))
        settings["ports"].each do |port|
            port["guest"] ||= port["to"]
            port["host"] ||= port["send"]
            port["protocol"] ||= "tcp"
        end
    else
        settings["ports"] = []
    end

    # Add Custom Ports
    if settings.has_key?("ports")
      settings["ports"].each do |port|
        config.vm.network "forwarded_port", guest: port["guest"], host: port["host"], protocol: port["protocol"], auto_correct: true
      end
    end

    # Register All Of The Configured Shared Folders
    if settings.include? 'folders'
        settings["folders"].each do |folder|
            if File.exists? File.expand_path(folder["map"])
                mount_opts = []

                if (folder["type"] == "nfs")
                    mount_opts = folder["mount_options"] ? folder["mount_options"] : ['actimeo=1', 'nolock']
                elsif (folder["type"] == "smb")
                    mount_opts = folder["mount_options"] ? folder["mount_options"] : ['vers=3.02', 'mfsymlinks']
                end

                # For b/w compatibility keep separate 'mount_opts', but merge with options
                options = (folder["options"] || {}).merge({ mount_options: mount_opts })

                # Double-splat (**) operator only works with symbol keys, so convert
                options.keys.each{|k| options[k.to_sym] = options.delete(k) }

                config.vm.synced_folder folder["map"], folder["to"], type: folder["type"] ||= nil, **options

                # Bindfs support to fix shared folder (NFS) permission issue on Mac
                if (folder["type"] == "nfs")
                    if Vagrant.has_plugin?("vagrant-bindfs")
                        config.bindfs.bind_folder folder["to"], folder["to"]
                    end
                end
            else
                config.vm.provision "shell" do |s|
                    s.inline = ">&2 echo \"Unable to mount one of your folders. Please check your folders in config.json\""
                end
            end
        end
    end

    # run script after booted
    if File.exist? startScript then
        config.vm.provision "shell", path: startScript, privileged: false, keep_color: true
    end

    # run provisions
    if settings.include? 'provisions'
      settings["provisions"].each do |provision|
        config.vm.provision "shell" do |s|
          s.path = provisionDir + "/" + provision + ".sh"
        end
      end
    end

    # nginx site
    if settings.include? 'sites'
        settings["sites"].each do |site|
            config.vm.provision "shell" do |s|
                s.name = "Creating Site: " + site["map"]
                if site.include? 'params'
                    params = "("
                    site["params"].each do |param|
                        params += " [" + param["key"] + "]=" + param["value"]
                    end
                    params += " )"
                end
                s.path = provisionDir + "/create-nginx-site.sh"
                s.args = [site["map"], site["to"], site["port"] ||= "80", site["ssl"] ||= "443"]
            end
        end
    end

    # run script after booted
    if File.exist? finalScript then
        config.vm.provision "shell", path: finalScript, privileged: false, keep_color: true
    end
end
