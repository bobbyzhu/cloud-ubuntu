#!/bin/bash
#
# proxy-client-transparent.sh -- launch the transparent proxy client
#
# Usage:
#
#    EXTRA_ARGS="-p 1080:1080" ENV_VARS="-e PROXY_SERVER=IP:PORT -e PROXY_PWD=PASSWORD [-e PROXY_PORT=1080]" ./scripts/proxy-client.sh
#

TOP_DIR=$(cd $(dirname $0) && pwd)/../

${TOP_DIR}/run proxy_client_transparent