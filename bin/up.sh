#!/bin/sh

set -e
set -x

DEFAULT_VAGRANT_PROVIDER="virtualbox"
VAGRANT_BOX=$1
VAGRANT_PROVIDER=$2

MY_FILENAME=`realpath $0`
MY_DIR=`dirname ${MY_FILENAME}`
VAGRANT_CWD=`realpath ${MY_DIR}/..`
export VAGRANT_CWD

if [ -z "${VAGRANT_PROVIDER}" ]; then
    VAGRANT_PROVIDER="${DEFAULT_VAGRANT_PROVIDER}"
fi

(
    cd "${VAGRANT_CWD}"
    sed -e "s|%%VAGRANT_BOX%%|${VAGRANT_BOX}|" Vagrantfile.template > Vagrantfile
)
VAGRANT_LOG=warn vagrant up --provider "${VAGRANT_PROVIDER}" --no-provision
