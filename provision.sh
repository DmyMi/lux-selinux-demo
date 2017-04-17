#!/usr/bin/env bash

# Update List of Packages
yum update -y

# install software for testing
yum install nano java-1.7.0-openjdk-headless epel-release httpd vsftpd -y

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
