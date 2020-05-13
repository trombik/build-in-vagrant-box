#!/bin/sh

set -e
set -x

MY_FILENAME=`realpath $0`
MY_DIR=`dirname ${MY_FILENAME}`

SRC_FILE=`realpath $1`
SRC_FILE_BASENAME=`basename "${SRC_FILE}"`
DEST_DIR="/home/vagrant/build"

ENVVARS=$2

VAGRANT_CWD=`realpath ${MY_DIR}/..`
export VAGRANT_CWD

vagrant status
vagrant ssh --command "mkdir ${DEST_DIR}" default
vagrant upload "${SRC_FILE}" "${DEST_DIR}/${SRC_FILE_BASENAME}" default
vagrant ssh --command "ls -al ${DEST_DIR}" default
vagrant ssh --command "sh -c \"(cd ${DEST_DIR} && chmod +x ${SRC_FILE_BASENAME} && env ${ENVVARS} ./${SRC_FILE_BASENAME})\"" default
