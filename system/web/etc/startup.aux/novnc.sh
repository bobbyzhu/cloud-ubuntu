#!/bin/bash
#
# novnc.sh
#

VNC_LAUNCH=/noVNC/utils/launch.sh

[ -z "$VNC_TIMEOUT" ] && VNC_TIMEOUT=0

if [ $VNC_TIMEOUT -eq 0 ]; then
    sed -i -e "s%--timeout=1800%%g" $VNC_LAUNCH
else
    sed -i -e "s%--timeout=1800%--timeout=$VNC_TIMEOUT%g" $VNC_LAUNCH
fi
