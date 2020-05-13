# `build-in-vagrant-box`

Build something in vagrant box using Travis CI, download the artifacts from
the guest.

This repository contains helper scripts, and expected to be `git` cloned in
your Travis CI build.

This is useful when you:

- build something on different OSes other than `linux` or `macOS`
- build something on different arch or machine

An example project can be found at
[trombik/build-in-vagrant-box-test](https://github.com/trombik/build-in-vagrant-box-test).

## Rationale

`go` claims to be able to cross-compile binaries for multiple targets. But it
cannot when some C libraries are required.

Many projects do not provide pre-built binaries for platforms not available in
CI service.

Thanks to recent additions to Travis CI, you can launch nested virtual
machines in Travis build environment. This project makes it easy to build in
various platform/arch/machine in Travis CI.

## Supported provider

- `virtualbox` (default)
- `libvirt`

### Requirements

The Travis CI platform must be `linux`, and the dist must be `bionic`.

Your `.travis.yml` must include the following `addons` section.

```yaml
addons:
  apt:
    update: true
    packages:
      - python-pip
      - curl
      - bridge-utils
      - dnsmasq-base
      - ebtables
      - libvirt-bin
      - libvirt-dev
      - qemu-kvm
      - qemu-utils
      - ruby-dev
```

Your `.travis.yml` must include the following `before_install` section.

```yaml
before_install:
  - |
    if [ ! -d vagrant-run ]; then
      git clone https://github.com/trombik/build-in-vagrant-box || exit 1
    fi
  - vagrant-run/bin/before_install.sh
```

A directory to download artifacts from the guest.

Finally, your repository must provide an execrable to do something.

## Usage

In your `.travis.yml`

```yaml
script:
  # do something, such as build and tests here...
  - mkdir dest
  - vagrant-run/bin/up.sh "${VAGRANT_BOX}"
  - vagrant-run/bin/run.sh build.sh
  - vagrant-run/bin/download.sh dest
```

### `up.sh`

```
up.sh vagrant-box-name [provider]
```

Create and boot the VM. `vagrant-box-name` must be publicly available from
`vagrant` cloud. The default provider is `virtualbox`.

### `before_install.sh`

```
before_install.sh
```

Install necessary files, such as `vagrant`, `virtualbox`, etc.

This should be called `before_install` in `.travis.yml`.

### `run.sh`

```
run.sh file
```

Run `file` in the VM. The `file` is assumed to be an execrable file, usually a
shell script. The file is copied to an empty build directory on the VM, and
executed.

### `download.sh`

```
download.sh dest-dir
```

Download all the files in the build directory on the guest to `dest-dir` on
the host, using `rsync`. The `dest-dir` must exist.

## Example `.travis.yml`

The following `.travis.yml` runs four jobs. A guest specified in `VAGRANT_BOX`
is created in each job. `build.sh`, an example build script is executed in the
guest. The artifacts are downloaded to `dest` directory on the host.

```yaml
---
os: linux
dist: bionic
language: ruby

env:
  - VAGRANT_BOX=trombik/ansible-freebsd-12.1-amd64
  - VAGRANT_BOX=trombik/ansible-openbsd-6.6-amd64
  - VAGRANT_BOX=trombik/ansible-ubuntu-18.04-amd64
  - VAGRANT_BOX=trombik/ansible-centos-7.4-x86_64

addons:
  apt:
    update: true
    packages:
      - python-pip
      - curl
      - bridge-utils
      - dnsmasq-base
      - ebtables
      - libvirt-bin
      - libvirt-dev
      - qemu-kvm
      - qemu-utils
      - ruby-dev

before_install:
  - yes | gem update --system --force
  - gem install bundler
  - |
    if [ ! -d vagrant-run ]; then
      git clone https://github.com/trombik/build-in-vagrant-box || exit 1
    fi
  - vagrant-run/bin/before_install.sh

script:
  - mkdir dest
  - vagrant-run/bin/up.sh "${VAGRANT_BOX}"
  - vagrant-run/bin/run.sh build.sh
  - vagrant-run/bin/download.sh dest
  - grep file1 dest/file1
  - grep file2 dest/foo/file2
```

An example `build.sh`

```sh
#!/bin/sh

echo "file1" >> file1
mkdir -p foo
echo "file2" >> foo/file2
```
