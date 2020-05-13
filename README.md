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
  - git clone https://github.com/trombik/build-in-vagrant-box
  - build-in-vagrant-box/bin/before_install.sh
```

A directory to download artifacts from the guest.

Finally, your repository must provide an execrable to do something.

## Usage

In your `.travis.yml`

```yaml
script:
  # do something, such as build and tests here...
  - mkdir dest
  - build-in-vagrant-box/bin/up.sh "${VAGRANT_BOX}"
  - build-in-vagrant-box/bin/run.sh build.sh
  - build-in-vagrant-box/bin/download.sh dest
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

## Examples

See [trombik/build-in-vagrant-box-test](https://github.com/trombik/build-in-vagrant-box-test).
