#!/bin/bash
#
# On a computer that will always-on on your network. Steps with a caret imply using a linux/macos
# command prompt to run the command.
# 1. Install Docker: https://docs.docker.com/engine/install/
# 
# 2. give execution permission to this file:
# > chmod +x run.sh
#
# 3. Run this file to download Unbound and update it with 
# the domains to be sink-holed (aka blocked):
# > ./run.sh

# generate the a-records.conf file that will 
docker rm unbound_updater; docker build -t unbound_updater .
# append
# docker run unbound_updater >> a-records.conf
# overwrite
docker run unbound_updater > a-records.conf


# start the unbound DNS server
docker stop unbound; docker rm unbound;
docker run \
--name unbound \
--detach=true \
--publish=53:53/tcp \
--publish=53:53/udp \
--restart=unless-stopped \
--volume $(pwd)/a-records.conf:/opt/unbound/etc/unbound/a-records.conf:ro \
mvance/unbound:latest

# confirm unbound in docker has your file
# docker exec -it unbound more /opt/unbound/etc/unbound/a-records.conf

# replace 10.1.1.74 with the IP address you're running docker unbound on:
# nslookup twitter.com - 10.1.1.74 			# should return a public IP; twitter.com is not in the a-records.conf
# nslookup ads.twitter.com - 10.1.1.74		# should return 0.0.0.0 indicating the subdomain is sinkholed (blocked)
# nslookup xyz.twitter.com - 10.1.1.74		# should return nothing; this isn't in the a-records.conf and isn't real
