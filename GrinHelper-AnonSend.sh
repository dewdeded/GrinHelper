#!/bin/bash

key="BPqh04thV5k22jjekPuQ"

### Tor2Web-Proxies
t2wproxies=(
onion.link
onion.to
hiddenservice.net
onion.casa
)

url1="https://g4eb3vctboop2v3o."

gate="`echo $RANDOM % 4 | bc`"
echo 
url2=${t2wproxies[$gate]}
url3="/$key"
url4=".html"
url=$url1$url2$url3$url4
echo $url
#curl 