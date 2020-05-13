#!/bin/sh

set -e
set -x

SRC_DIR="/home/vagrant/build"
DEST_DIR=`realpath "$1"`
MY_FILENAME=`realpath $0`
MY_DIR=`dirname ${MY_FILENAME}`
SSH_CONFIG_FILE=`realpath ${MY_DIR}/../ssh_config`
export VAGRANT_CWD=`realpath ${MY_DIR}/..`

vagrant ssh-config > ${SSH_CONFIG_FILE}

rsync -av -e "ssh -F ${SSH_CONFIG_FILE}" default:${SRC_DIR}/ ${DEST_DIR}/
ls -al ${DEST_DIR}
