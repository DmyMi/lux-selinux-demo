#!/usr/bin/env bash

# Update to the latest kernel
yum -y install kernel-devel

# Update List of Packages
yum update -y

# install software for testing
yum install nano java-1.7.0-openjdk-headless epel-release httpd vsftpd lftp -y

# 7zip to extract the test application
yum install p7zip -y

# Start the http server
systemctl start httpd.service
# Start the ftp server
systemctl start vsftpd.service

# Install SELinux packages
yum install policycoreutils policycoreutils-python selinux-policy selinux-policy-targeted libselinux-utils setroubleshoot-server setools setools-console mcstrans -y

# Install SELinux packages for creating custom
# SELinux module
yum install policycoreutils-devel selinux-policy-devel policycoreutils-newrole -y

# Creating test users
echo "Creating users"
useradd -c "Regular User" reguser
useradd -c "Switched User" swuser
useradd -c "Guest User" guestuser
useradd -c "Restricted Role User" restuser
echo "done"
# Setting passwords
echo "Setting user password"
echo 'reguser:regpass' | chpasswd
echo 'swuser:swpass' | chpasswd
echo 'guestuser:gpass' | chpasswd
echo 'restuser:respass' | chpasswd
echo "done"

# Extract test application
7za x -o/opt /vagrant/jnode.7z

yum install linux-headers-$(uname -r) build-essential dkms -y
wget -c http://download.virtualbox.org/virtualbox/5.1.20/VBoxGuestAdditions_5.1.20.iso -O /opt/VBoxGuestAdditions_5.1.20.iso > /dev/null 2>&1
mount -o loop,ro /opt/VBoxGuestAdditions_5.1.20.iso /mnt
echo "yes" | sudo sh /mnt/VBoxLinuxAdditions.run uninstall
echo "yes" | sudo sh /mnt/VBoxLinuxAdditions.run --nox11
groupadd vboxusers
usermod -a -G vboxusers $USER
ln -sf /opt/VBoxGuestAdditions-5.1.20/lib/VBoxGuestAdditions/mount.vboxsf /sbin/mount.vboxsf
ln -s /opt/VBoxGuestAdditions-5.1.20/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions