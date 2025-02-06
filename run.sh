#!/bin/bash

# generate the a-records.conf file containing the block list
# many, ongoing thanks to: https://github.com/StevenBlack/hosts
docker rm unbound_updater; docker build -t unbound_updater .
docker run unbound_updater > a-records.conf

# start the unbound DNS server
# per: https://github.com/MatthewVance/unbound-docker
docker stop unbound; docker rm unbound;
docker run \
--name unbound \
--detach=true \
--publish=53:53/tcp \
--publish=53:53/udp \
--restart=unless-stopped \
--volume $(pwd)/a-records.conf:/opt/unbound/etc/unbound/a-records.conf:ro \
mvance/unbound:latest
