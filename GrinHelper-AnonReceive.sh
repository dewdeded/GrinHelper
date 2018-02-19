#!/bin/bash

### Tor2Web-Proxies
#onion.link
#onion.to
t2wproxies=(
hiddenservice.net
onion.casa
)

clear
echo "Generating transfer secret ..."

export txid=`< /dev/urandom tr -dc A-Za-z0-9 | head -c20; echo`
export txsecret=`< /dev/urandom tr -dc A-Za-z0-9 | head -c100; echo`

echo "Finished generating transfer secret."

url1="http://g4eb3vctboop2v3o."

gate="`echo $RANDOM % 2 | bc`"
echo 
url2=${t2wproxies[$gate]}
url3="/receive/$txid/$txsecret"
host=$url1$url2
finalurl=$url1$url2$url3
echo "Trying to upload via $host"
wget --quiet --output-document=upload.html --no-cookies --header "Cookie: disclaimer_accepted=1" $finalurl > /dev/null 2> /dev/null 

if grep -q Ok upload.html; then echo -e "\nSuccess, your key was uploaded."
echo -e "Tell the sender to send to: $txid@gr.in\n"; 
else
echo -e "Error please try again!\n"; 
fi
rm upload.html