#!/bin/bash

export TZ=${TZ:-UTC}
export INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')

cd /home/container || exit 1

PARSED=$(sed -e 's/{{/${/g' -e 's/}}/}/g' <<< "$STARTUP" | eval echo)

echo -e "\033[1m\033[33mcontainer@vinahost~ \033[0m$PARSED"

exec env $PARSED
