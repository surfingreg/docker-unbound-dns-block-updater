# docker-unbound-dns-block-updater
Run your own DNS sinkhole server to block 120k+ ad domains

## Background
These repos have done all the work. By default this will block over 123,000 ad and fake domains. Kinda like PiHole except run it on your own hardware. These two files (run.sh and Dockerfile) only combine these repos and one of my own to insert the continuously maintained and open-sourced database of yucky domains into Unbound. On any Linux or Mac (maybe Win too with Linux subsystem) just run this bash script and in a few seconds you'll have a blocking DNS server.

## Sources
https://github.com/MatthewVance/unbound-docker
https://github.com/StevenBlack/hosts
https://github.com/surfingreg/rust-unbound-dns-block

## Usage
> git clone https://github.com/surfingreg/docker-unbound-dns-block-updater
> cd docker-unbound-dns-block-updater
> chmod +x run.sh
> ./run.sh
> nslookup ads.twitter.com [your_ip_address]

This setup doesn't automatically refresh the @StevenBlack data. Run run.sh every time you want a refresh:
> ./run.sh

To see if it's running:
> docker ps

To confirm Unbound is using the mega block list:
> docker exec -it unbound more /opt/unbound/etc/unbound/a-records.conf

Run some tests:
``` 
# replace 10.1.1.74 with the IP address you're running docker unbound on:
nslookup twitter.com - 10.1.1.74 			# should return a public IP; twitter.com is not in the a-records.conf
nslookup ads.twitter.com - 10.1.1.74		# should return 0.0.0.0 indicating the subdomain is sinkholed (blocked)
nslookup xyz.twitter.com - 10.1.1.74		# should return nothing; this isn't in the a-records.conf and isn't real
```
