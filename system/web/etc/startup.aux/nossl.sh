#!/bin/bash
#
# nossl.sh -- Disable ssl feature for gateone/vnc?
#

[ -z "$NOSSL" ] && NOSSL=0

if [ $NOSSL -eq 1 ]; then
    sed -i -e 's%/usr/local/bin/gateone%/usr/local/bin/gateone --disable_ssl%g' /etc/supervisor/conf.d/gateone.conf

    mv /etc/nginx/sites-enabled/nossl /etc/nginx/sites-enabled/default
else
    rm /etc/nginx/sites-enabled/nossl
fi
