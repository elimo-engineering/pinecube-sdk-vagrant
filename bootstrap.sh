#!/usr/bin/env bash

set -e

# configuration variables
PINECUBE_SDK_NAME='PineCube Stock BSP-SDK ver1.0'
PINECUBE_SDK_URL='http://files.pine64.org/SDK/PineCube/PineCube%20Stock%20BSP-SDK%20ver1.0.7z'
MAKE_REV="make-3.82"

# derived from the above
MAKE_ARCHIVE="${MAKE_REV}.tar.gz"
MAKE_URL="https://ftp.gnu.org/gnu/make/${MAKE_ARCHIVE}"

echo "Install deps that are available as debs"
sudo apt-get update
sudo apt-get -y full-upgrade

sudo apt-get -y install python p7zip-full git make u-boot-tools libxml2-utils bison build-essential zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32z1-dev fastjar
sudo apt-get -y install gcc-arm-linux-gnueabi g++-arm-linux-gnueabi 

echo "Extract PineCube SDK"
if [ ! -r "/vagrant/${PINECUBE_SDK_NAME}.7z" ]; then
    echo "The PineCube SDK is not present/readable at /vagrant/${PINECUBE_SDK_NAME}.7z on the VM."
    echo "It will now be downloaded from ${PINECUBE_SDK_URL}."
    echo "This can take a long time (hours!), so if you already have the file, interrupt now "
    echo "and place it next to the Vagrantfile and avoid this download."
    sleep 5
    cd /vagrant
    wget ${PINECUBE_SDK_URL}
else
    echo "The PineCube SDK found at /vagrant/${PINECUBE_SDK_NAME}.7z."
fi
echo "Decompressing SDK..."
cd /home/vagrant
7z x "/vagrant/${PINECUBE_SDK_NAME}.7z"
mv "${PINECUBE_SDK_NAME}" pinecube-sdk
chown -R vagrant:vagrant pinecube-sdk

echo "Download and install Make"
pushd /tmp
wget -nv ${MAKE_URL}
tar xfv ${MAKE_ARCHIVE}
cd ${MAKE_REV}
./configure
make
sudo apt purge -y make
sudo ./make install
cd ..

echo "Install Java VM"
cd /vagrant
chmod +x jdk-6u45-linux-x64.bin 
./jdk-6u45-linux-x64.bin 
sudo mkdir /opt/java/
sudo mv jdk1.6.0_45/ /opt/java/
sudo update-alternatives --install /usr/bin/javac javac /opt/java/jdk1.6.0_45/bin/javac 1
sudo update-alternatives --install /usr/bin/java java /opt/java/jdk1.6.0_45/bin/java 1
sudo update-alternatives --install /usr/bin/javaws javaws /opt/java/jdk1.6.0_45/bin/javaws 1
sudo update-alternatives --config javac
sudo update-alternatives --config java
sudo update-alternatives --config javaws
popd
