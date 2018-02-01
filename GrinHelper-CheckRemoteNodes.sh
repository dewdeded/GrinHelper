#!/bin/bash

### Deps
# Needs GrinHelper ( https://github.com/dewdeded/grin on remote node)

### Configuration
configfile="`pwd`/GrinHelper-NodeList.conf"
source "$configfile"


### Begin main script

# Function Check Stats
option_1()
{
clear  
echo "Network height:			$(curl -s https://grintest.net/v1/chain | jq .height)"
	
for host in "${hosts[@]}"; do
    IFS=":" names=( $host )
    echo -e "\nHostname: ${names[2]} (IP: ${names[1]})\n"
    
    ssh ${names[1]} /bin/grinhelper remote_stats

done
echo ""
echo -e "\nPress ENTER To Return"
read continue
}

# Function Check Outputs
option_2()
{
clear  

for host in "${hosts[@]}"; do
    IFS=":" names=( $host )
    echo -e "\nHostname: ${names[2]} (IP: ${names[1]})\n"
    ssh -t -t ${names[1]} << EOF
    cd /root/mw/grin/node1/ 
    grin wallet -p password outputs
    exit 
EOF
    
done

echo -e "\nPress ENTER To Return"
read continue
}

# Function Check Balances
option_3()
{
clear  

for host in "${hosts[@]}"; do
    IFS=":" names=( $host )
    echo -e "\nHostname: ${names[2]} (IP: ${names[1]})\n"
    balance=$(ssh -o LogLevel=QUIET ${names[1]} -t "export PATH="/root/.cargo/bin:/root/mw/grin/target/debug:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"; pushd "/root/mw/grin/node1" > /dev/null ; grin wallet -p password info|grep Spend" | awk '{print $4}')
    echo "${names[2]} has $balance"
done

echo -e "\nPress ENTER To Return"
read continue
}

# Function Update Grinhelper
option_u()
{
clear  

for host in "${hosts[@]}"; do
    IFS=":" names=( $host )
    echo -e "\nUpdating Grinhelper at Hostname: ${names[2]} (IP: ${names[1]})\n"
    ssh ${names[1]} "wget -q http://grin.bz/grinhelper.sh -O /bin/grinhelper; chmod +x /bin/grinhelper"
    echo "Finished updating Grinhelper at ${names[2]}"
    
done

echo -e "\nPress ENTER To Return"
read continue
}


## Check if CLI argument passed to start updating nodes
if [ "$1" == "update" ];
then
	echo Updating nodes
    option_u
    exit 0;
fi



while :
do
    clear
	figlet Check Grin Nodes
    
    echo " "
    echo -e "Please select an option to be executed on all your grin nodes:\n"
    echo "1) Check Stats"
    echo "2) Check Outputs"
    echo "3) Check Balance"
    echo ""
    echo "u) Update Grinhelper"
    echo "e) Exit"
    echo "=========================================================================="
	
	read m_menu
	
	case "$m_menu" in
	
    1) option_1;;
    2) option_2;;
    3) option_3;;
    u) option_u;;
    e) exit 0;;
    *) echo "Error, invalid input. Press ENTER to go back."; read;;
	
    esac
done
}

