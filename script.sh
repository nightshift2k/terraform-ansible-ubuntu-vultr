#!/bin/bash
# Get variables
USER=$1
KEY=$2
PASS=$3

# update system
sudo apt-get update -y
sudo apt-get upgrade -y


# Add user and group
sudo /usr/sbin/groupadd $USER
sudo /usr/sbin/useradd  $USER -g  $USER -G sudo -d /home/$USER --shell /bin/bash --create-home
sudo usermod --password $PASS $USER
sudo echo "$USER        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/$USER
sudo chmod 440 /etc/sudoers.d/$USER
sudo mkdir /home/$USER/.ssh
sudo chmod 700 /home/$USER/.ssh
sudo echo "$KEY" > /home/$USER/.ssh/authorized_keys
sudo chmod 600 /home/$USER/.ssh/authorized_keys
sudo chown -R $USER:$USER /home/$USER/.ssh

# install packages
sudo apt-get install python2.7 -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install postfix -y

# disable password auth
sudo sed 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo service sshd restart
