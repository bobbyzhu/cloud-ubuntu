#!/bin/bash

TOP_DIR=$(cd $(dirname $0) && pwd)/..

source ${TOP_DIR}/config $*

[ -z "$ENCRYPT_CMD" ] && ENCRYPT_CMD=md5sum
[ -z "$CONTAINER_IP" ] && CONTAINER_IP=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' $CONTAINER_NAME`
[ -z "$PORT" ] && PORT=$LOCAL_VNC_PORT

VNC_DATA=$1
[ -z "$VNC_DATA" ] && VNC_DATA=vnc.record.data.1

if [ "$VNC_PORT" != "6080" ]; then
    token=`echo -n $VNC_PORT | $ENCRYPT_CMD | cut -d' ' -f1`
else
    token=`echo -n $CONTAINER_IP | $ENCRYPT_CMD | cut -d' ' -f1`
fi

URL="$HTTP://$HOST_NAME:$PORT/tests/vnc_playback.html?mode=realtime&data=$VNC_DATA"

echo "LOG: URL: $URL"

(chromium-browser $URL 2>&1>/dev/null &) 2>&1>/dev/null
