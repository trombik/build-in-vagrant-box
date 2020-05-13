#!/bin/sh

set -e
set -x

MY_FILENAME=`realpath $0`
MY_DIR=`dirname ${MY_FILENAME}`
BOX=$1
PROVIDER=$2
SCRIPT=$3
ENVVARS=$4
DEST_DIR=$5

mkdir -p ${DEST_DIR}
${MY_DIR}/up.sh ${BOX} ${PROVIDER}
${MY_DIR}/run.sh ${SCRIPT} "${ENVVARS}"
${MY_DIR}/download.sh ${DEST_DIR}
