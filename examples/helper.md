# Commands Helper

All the commands (except exercises) from the slides are in this file, so you can just copy & paste to speed up the process

### Slide 5

```bash
#List contents of home directory of current user with help of USER environment variable
ls -lah /home/$USER
```

### Slide 14

```bash
# To see all installed SELinux Packages run as root
rpm -qa | grep selinux
```

### Slide 16

```bash
# We can run the getenforce command to check the current SELinux mode.
# Run as either normal or super user

getenforce

# We can also run the sestatus command:
# Run as either normal or super user

sestatus

# The later should also give additional info regarding SELinux status,
# if it is enabled in either Enforcing or Permissive mode.
```

### Slide 17

```bash
# We can run the following command to view config file contents:

cat /etc/selinux/config
```

### Slide 18

```bash
# In permissive mode Log in to your VM again and search
# for the string "SELinux is preventing" from the contents of the /var/log/messages file.

cat /var/log/messages | grep "SELinux is preventing"

# If there are no errors reported, we can safely move to the next step. However, it would 
# still be a good idea to search for text containing "SELinux" in /var/log/messages file

cat /var/log/messages | grep "SELinux"

# We can also temporarily switch between enforcing and permissive modes with setenforce:

setenforce permissive
```

### Slide 27

```bash
# The sestatus command shows the policy store # name. 
# The semodule -l command lists the SELinux 
# policy 
# modules currently loaded into memory.

semodule -l | less

# semodule can be used for a number other 
# tasks like installing, removing, reloading, 
# upgrading, enabling and disabling SELinux 
# policy modules.
```

### Slide 28

```bash
# If there are any modules available – you can check them with

ls -l /etc/selinux/targeted/modules/active/modules/

# The combined binary version of this loaded policy can be found under the 
# /etc/selinux/targeted/policy directory

ls -l /etc/selinux/targeted/policy/

```

### Slide 29

```bash
# Show the different switches that can be turned on or off,
# what they do, and their current statuses.

semanage boolean -l | less

# To change any of the settings, we can use the setsebool command
# check
getsebool ftpd_anon_write
# set
setsebool ftpd_anon_write on
# check again
getsebool ftpd_anon_write
```

### Slide 32

```bash
# regular ls -l command against the /etc directory
ls -l /etc

# now add the -Z flag
ls -Z /etc
```

### Slide 33

```bash
ls -Z /etc | grep yum.conf
ls -Z /etc | grep locale.conf
```

### Slide 34

```bash
# Restart the Apache and SFTP services
systemctl restart httpd && systemctl restart vsftpd

# We can run the ps command with a few flags to show the Apache and SFTP processes running
ps -efZ | grep 'httpd\|vsftpd'
```


### Slide 36

```bash
# The default home directory for the web server is /var/www/html.
# Let's create a file within that directory and check its context

touch /var/www/html/index.html
ls -Z /var/www/html/*

# We can use the sesearch command to check the type of access allowed for the httpd daemon
sesearch --allow --source httpd_t --target httpd_sys_content_t --class file

# The flags used with the command are fairly self-explanatory:
# 1. the source domain is httpd_t (the domain Apache is running in)
# 2. We are interested about target resources that are classified as files
# 3. and have a type context of httpd_sys_content_t. 
```

### Slide 37

```bash
nano /var/www/html/index.html
```

Place the following content into the file:

```html
<html>
    <title>
        This is a test web page
    </title>
    <body>
        <h1>Hello Luxembourg Security :)</h1>
    </body>
</html>
```

or simply do:

```bash
cat /vagrant/examples/index.html > /var/www/html/index.html
```

```bash
# Next, we will change the permission of the 
# /var/www/ folder and its contents, followed by 
# a restart of the httpd daemon

chmod -R 755 /var/www
systemctl restart httpd
```

### Slide 38

```bash
# The --type flag for the command allows us to specify a new type for the target resource.
# We are changing the file type to var_t
chcon --type var_t /var/www/html/index.html
# Confirm the change
ls -Z /var/www/html/
```

```bash
# The -v switch shows the change of context labels
restorecon -v /var/www/html/index.html
```

### Slide 39

```bash
# Check directory
ls -Z /var/www
# Copy to another directory
cp /var/www/html/index.html /var/
# Check file
ls -Z /var/index.html

# This change of context can be overridden by the --preserver=context clause
# in the cp command.
# Now move and check
mv /var/index.html /etc/ 
ls -Z /etc/index.html
```

### Slide 40

```bash
# Create new directory and check its context (should be default_t)
mkdir -p /www/html && ls -Z /www/

# Copy our website :). It should get the default_t type
cp /var/www/html/index.html /www/html/

# Edit Apache config
nano /etc/httpd/conf/httpd.conf

# Find the following section and change it
# to look like right snippet
# then restart Apache using command:
systemctl restart httpd
```

### Slide 41

```bash
# extract from one of the files
cat /etc/selinux/targeted/contexts/files/file_contexts | less
```

### Slide 42

```bash
# Step 1: Set file contexts for both directories
semanage fcontext --add --type httpd_sys_content_t "/www(/.*)?"
semanage fcontext --add --type httpd_sys_content_t "/www/html(/.*)?"

# Check if contexts are added
cat /etc/selinux/targeted/contexts/files/file_contexts.local

# Step 2: restorecon with recursive(-R) flag
restorecon -Rv /www

# Verify the correct context before and after restorecon
matchpathcon -V /www/html/index.html
```

### Slide 44

```bash
# Check system context
ps -eZ  | grep init

# Check vsftpd binary context
ls -Z /usr/sbin/vsftpd

# Check vsftpd process
ps -eZ | grep vsftpd
```

### Slide 46

```bash
# See if source domain has execute permission on entry point
# flags: -s – source, -t – target, -c – class, -p – permission,
# -A – allow rules, -d – direct name match
sesearch -s init_t -t ftpd_exec_t -c file -p execute -Ad

# Check if binary is entry point for target domain
sesearch -s ftpd_t -t ftpd_exec_t -c file -p entrypoint -Ad

# Check if there is a transition permission
sesearch -s init_t -t ftpd_t -c process -p transition -Ad
```

### Slide 49

```bash
# To view user mapping
semanage login -l
```

### Slide 50

```bash
# See what SELinux users are available in the system
semanage user -l
```

### Slide 51

```bash
# run as root user
id -Z

# Go to GUI and log in as regular user (login: reguser & password: regpass)
# run same command
id -Z
```

### Slide 52

```bash
# Use Vbox GUI
# The regular user switches to the switched user account.
# We assume he knows the password for switched user (it’s swpass :) )
su - swuser

# Go to root user terminal
# (-a – add a record of specified type, -s SEUSER – SELinux user type)
semanage login -a -s user_u reguser

# update contexts
restorecon -RFv /home/reguser/
```

### Slide 53

First:

```bash
nano /etc/sudoers
```

in the file, add the following line, save and exit

```
restuser ALL=(ALL)      ALL
```

Then:

```bash
# As root user stop Apache
systemctl stop httpd

# Go to GUI and log in as restricted user (login: restuser & password: respass)
# assume he doesn’t know root password
systemctl start httpd

# Go to GUI after adding to sudoers
sudo systemctl start httpd

# in root terminal
semanage login -a -s user_u restuser

# verify user_u access to roles and user_r role access to domains (root terminal)
# There are a number of httpd related domains, but httpd_t is not one of them.
seinfo -uuser_u -x
seinfo -ruser_r -x | grep httpd

# as restricted user try to start httpd again
sudo systemctl start httpd
```

### Slide 54

```bash
# -m – modify a record of specified object
# -r – security range for MLS/MCS
semanage login -m -S targeted -s "user_u" -r s0 __default__
# verify with
semanage login -l
```

```bash
# more permissive role
semanage login -a -s "sysadm_u" guestuser

# update contexts
restorecon -RFv /home/guestuser/
```

### Slide 56

```bash
# The first command is ausearch. We can make use of this command if the auditd daemon is running.
# For example, let’s check our Apache server, -m – message, -c – command (process) name
ausearch -m avc -c httpd
```

### Slide 60

```bash
# Check if there are any errors in the logs
cat /var/log/messages | grep "SELinux is preventing"

# Check detailed info about the error
sealert -l <your-error-id>

# Or we can use audit2why that parses the logs and shows the reason in readable form
# first lets search the logs for today’s errors with ausearch and pipe it to audit2why
# -ts – time stamp to start the search
ausearch -m avc -ts today | audit2why
```

### Slide 64

```bash
# try to figure why we encounter ANOTHER error :)
# hint use ausearch command
ausearch -m avc -c vsftpd

# or sealert on the latest entry in logfile
tail /var/log/messages -n 4 | grep "SELinux is preventing"
sealert -l <error-id>

# or audit2why 
ausearch -m avc -c vsftpd | audit2why
```

### Slide 65

```bash
sesearch --allow --source ftpd_t --target public_content_t -d
```

### Slide 66

```bash
ausearch -c 'vsftpd' --raw | audit2allow -a -m my-vsftpd > my-vsftpd.te

# -M – MLS enabled, -m – non-base policy (can be added to existing policy), -o - output
checkmodule -M -m -o my-vsftpd.mod my-vsftpd.te

semodule_package -o my-vsftpd.pp -m my-vsftpd.mod
semodule -i my-vsftpd.pp
```

### Slide 80

```bash
# Macros location
/usr/share/selinux/devel/include/

# contains quite a few *.if` files with default macros‘
# for SELinux base policy and their description
# Example
cat /usr/share/selinux/devel/include/system/userdomain.if
```