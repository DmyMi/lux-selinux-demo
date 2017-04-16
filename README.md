# lux-selinux-demo

The commands, packages, and files shown that we are going to see today will be shown on CentOS 7. The concepts remain the same for other distributions.

We will be running the commands as the root user unless otherwise stated. If you don't have access to the root account and use another account with sudo privileges, you need to precede the commands with the `sudo` keyword.

## Test System

We will start with a bare installation of CentOS 7 with minimal packages installed and install additional software on the VM with default configurations.

We will also create a few test user accounts for training purpose. Finaly, will install needed SELinux-related packages. This is to ensure we can work with the latest SELinux commands.

To speed up the process we will use a combination of Vagrant VM provisioner and Virtualbox VM provider. 

### Additional software
We will need some additional software to run the course

#### git version control system
For windows/mac users can be download at: [Official Website](https://git-scm.com/downloads)

#### ssh client
We can use either git-bash (for windows) or native ssh client for linux/mac

#### Virtualbox & Vagrant
Virtualbox can be downloaded at [Official website](https://www.virtualbox.org/) for all supported platforms

Same goes for Vagrant [Official site](https://www.vagrantup.com/downloads.html)

### Cloning Vagrant scripts

```
git clone https://github.com/DmyMi/lux-selinux-demo.git
cd lux-selinux-demo
vagrant up # start provisioning, will take 5-15 minutes
vagrant ssh # when provisioning is successful
```

