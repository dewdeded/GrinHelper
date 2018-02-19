#!/bin/bash

### Definition Tor2Web-Proxies
#onion.link
#onion.to
t2wproxies=(
hiddenservice.net
onion.casa
)

clear
if [[ $1 = *"@gr.in"* ]]; then echo -e "\nCheck TXID:   Ok." 
else
echo -e "\nError, invalid TXID."
exit 1
fi
txid=`echo $1| awk -F@ '{print $1}'`

url1="http://hkrd3fcptk2cpbrf."

gate="`echo $RANDOM % 2 | bc`"
echo 
url2=${t2wproxies[$gate]}
url3="/$txid.html"
host=$url1$url2
finalurl=$url1$url2$url3
echo "Trying to retreive transfer secret for TXID: $txid"
echo "Via: $host"
wget --quiet --output-document=send.html --no-cookies --header "Cookie: disclaimer_accepted=1" $finalurl > /dev/null 2> /dev/null 

if grep -q Ok send.html; then echo -e "\nSuccess, the correct secret was retreived."
else
echo -e "\nError please try again! Check with Receiver if TXID is ok.\n"; 
fi
txsecret=`cat send.html|sed 's/<br>Ok//g'`
rm send.html
echo $txsecret