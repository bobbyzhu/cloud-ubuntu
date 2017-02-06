#!/bin/bash

TOP_DIR=$(cd $(dirname $0) && pwd)/../

UNIX_PWD=`pwgen -c -n -s -1 25` ENCRYPT_CMD=md5sum LAB_SECURITY=0 VNC_RECORD=1 ${TOP_DIR}/scripts/web-ubuntu.sh
