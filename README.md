# Vagrant machine for the PineCube SDK

This is a vagrant machine to build the PineCube SDK.
The SDK build system depends on a specific version of Ubuntu and a set of quite old packages.
You can use this machine to avoid polluting your environment with these dependencies.

## Recommended setup

We will assume that you have a functional vagrant install with a provider configured.
This repo has been tested with the virtualbox provider.
The machine is configured to have a 20GB disk and 16GB of RAM. You can change these settings in the Vagrant file, but take into account that the build will fail if you go down to 4GB of RAM. 8GB is the recommended minimum.

The steps to get the machine up are the following:
- checkout this repo
- if you already downloaded the SDK, copy it to the root of the repo
- if you didn't download the SDK, the boot script will. However, the download can take hours and the script will simply do a `wget`, so it's probably best to have the SDK pre-downloaded.
- run `vagrant up`
- when the machine is up (it can take a few minutes), you can access it with `vagrant ssh`

Assuming you have the SDK already and it's in ~/Downloads, this would be the sequence of commands to 
issue to get the machine up and log into it:

```
git clone git@github.com:elimo-engineering/pinecube-sdk-vagrant.git
cd pinecube-sdk-vagrant
mv ~/Downloads/PineCube\ Stock\ BSP-SDK\ ver1.0.7z ./
vagrant up
vagrant ssh

```

## Usage

Once logged in, you can follow the build instructions on the [PineCube Wiki](https://wiki.pine64.org/index.php?title=PineCube)

For example, to simply run a build, you can run the following:

```
cd pinecube-sdk/camdroid
source build/envsetup.sh
lunch
mklichee
make -j3
pack
```
