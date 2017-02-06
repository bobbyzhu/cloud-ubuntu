#!/bin/bash

TOP_DIR=$(cd $(dirname $0) && pwd)/../

UNIX_PWD=`pwgen -c -n -s -1 25` ENCRYPT_CMD=md5sum LAB_SECURITY=0 VNC_PLAYER=1 DEFAULT_PORT_MAP="-p 6081:6080" ${TOP_DIR}/scripts/web-ubuntu.sh
