#!/bin/sh
set -e
set -x

PACKAGES="realpath bridge-utils dnsmasq-base ebtables libvirt-bin libvirt-dev qemu-kvm qemu-utils ruby-dev"
VAGRANT_RELEASE_URL="https://releases.hashicorp.com/vagrant"
VAGRANT_RELEASE_VERSION="2.2.9"
VAGRANT_RELEASE_FILENAME="vagrant_${VAGRANT_RELEASE_VERSION}_x86_64.deb"

wget "${VAGRANT_RELEASE_URL}/${VAGRANT_RELEASE_VERSION}/${VAGRANT_RELEASE_FILENAME}"
sudo dpkg -i "${VAGRANT_RELEASE_FILENAME}"
rm -f "${VAGRANT_RELEASE_FILENAME}"
vagrant --version
vagrant plugin install vagrant-libvirt
sudo chmod go+rw /var/run/libvirt/libvirt-sock

sudo apt-get install "linux-headers-`uname -r`"
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O - | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian `lsb_release -cs` contrib"
sudo apt-get update
sudo apt-get install virtualbox-6.1
