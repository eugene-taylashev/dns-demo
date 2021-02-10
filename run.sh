#!/usr/bin/env bash

IMG=dns01

docker rm $IMG

docker run -d \
--name $IMG \
-p 5353:53/udp \
-p 5354:53/tcp \
--mount source=~/dns-demo/dns-data,target=/var/named \
etaylashev/dns-demo
