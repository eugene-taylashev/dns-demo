#!/usr/bin/env bash

IMG=dns01

docker rm $IMG

docker run -d \
--name $IMG \
-p 5453:53/udp \
-p 5453:53/tcp \
-e VERBOSE=1 \
-v /home/eugene/dnsdemo/named:/var/named \
etaylashev/dns-demo

