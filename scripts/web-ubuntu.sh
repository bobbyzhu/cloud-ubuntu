#!/bin/bash
#
# web-ubuntu.sh
#
# 1. Record the screen session into noVNC/recordings/
#
#    $ VNC_RECORD=1 ./scripts/web-ubuntu.sh
#
# 2. Playback
#
#    http://localhost:6080/tests/vnc_playback.html?data=vnc.record.data.1&mode=realtime
#

TOP_DIR=$(cd $(dirname $0) && pwd)/../

source ${TOP_DIR}/config $* 2>&1 >/dev/null

DEFAULT_PORT_MAP=" -p $LOCAL_VNC_PORT:$VNC_PORT -p $LOCAL_SSH_PORT:$SSH_PORT -p $LOCAL_WEBSSH_PORT:$WEBSSH_PORT "

# Available encrypt cmds: sha1sum, sha224sum, cksum, sha256sum, sha512sum, md5sum, sha384sum, sum
[ -z "$ENCRYPT_CMD" ] && ENCRYPT_CMD="cat"
[ -n "$UNIX_PWD" ] && UNIX_PWD=`echo -n $UNIX_PWD | $ENCRYPT_CMD | cut -d' ' -f1`
[ -n "$VNC_PWD" ] && VNC_PWD=`echo -n $VNC_PWD | $ENCRYPT_CMD | cut -d' ' -f1`
[ -z "$VNC_RECORD" ] && VNC_RECORD=0
[ -z "$VNC_TIMEOUT" ] && VNC_TIMEOUT=0

if [ $VNC_RECORD -eq 1 ]; then
    VNC_RECORD_DIR=/noVNC/recordings
    VNC_RECORD_FILE=$VNC_RECORD_DIR/vnc.record.data
    LOCAL_RECORD_DIR=$TOP_DIR/$VNC_RECORD_DIR
    [ ! -d $LOCAL_RECORD_DIR ] && mkdir $LOCAL_RECORD_DIR
    VOLUME_MAP=" -v $LOCAL_RECORD_DIR:$VNC_RECORD_DIR "
    echo "LOG: VNC screen recorded in $VNC_RECORD_FILE"
fi

echo "PORTS: VNC=$LOCAL_VNC_PORT SSH=$LOCAL_SSH_PORT WEBSSH=$LOCAL_WEBSSH_PORT"
EXTRA_ARGS="$EXTRA_ARGS -e PROXY_SPEED_LIMIT=0 -e NOSSL=$NOSSL"
EXTRA_ARGS="$EXTRA_ARGS -e VNC_RECORD=$VNC_RECORD -e VNC_TIMEOUT=$VNC_TIMEOUT -e VNC_RECORD_FILE=$VNC_RECORD_FILE $VOLUME_MAP" \
    UNIX_PWD="$UNIX_PWD" VNC_PWD="$VNC_PWD" PORT_MAP="$DEFAULT_PORT_MAP" ${TOP_DIR}/run web
