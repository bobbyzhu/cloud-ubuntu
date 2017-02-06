#!/bin/bash
#
# novnc.sh
#

VNC_LAUNCH=/noVNC/utils/launch.sh

[ -z "$VNC_TIMEOUT" ] && VNC_TIMEOUT=0
[ -z "$VNC_RECORD" ] && VNC_RECORD=0

VNC_CONFIG=""

if [ $VNC_TIMEOUT -eq 1 ]; then
    VNC_CONFIG="$VNC_CONFIG --timeout=$VNC_TIMEOUT"
fi

if [ $VNC_RECORD -eq 1 ]; then
    [ -z "$VNC_RECORD_FILE" ] && VNC_RECORD_FILE=/tmp/vnc.record.data
    VNC_CONFIG="$VNC_CONFIG --record $VNC_RECORD_FILE"
fi

sed -i -e "s%--timeout=1800%$VNC_CONFIG%g" $VNC_LAUNCH
