#!/bin/bash
export pw=`< /dev/urandom tr -dc A-Za-z0-9 | head -c20; echo`

ssh-keygen -C "$pw@gr.in" -t rsa -N '' -f ~/.ssh/anonsend-$pw > /dev/null
sleep 5
cmd1="/bin/cat /Users/x/.ssh/anonsend-$pw.pub" 
cmd2="/usr/local/bin/netcat anon.grinpool.co 9999"
result=$($cmd1|$cmd2|tr -d '\0')

if echo $result|grep -q onion; then echo -e "\nSuccess, your key was uploaded."
echo -e "Tell the sender to send to: $pw@gr.in\n"; 
fi
