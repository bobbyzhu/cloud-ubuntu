#!/bin/bash

TOP_DIR=$(cd $(dirname $0) && pwd)/../

[ -z "$VNC_RECORD_DIR" ] && VNC_RECORD_DIR=${TOP_DIR}/noVNC/recordings/

${TOP_DIR}/system/web/noVNC/utils/websockify/websockify/generate-records.py $VNC_RECORD_DIR
