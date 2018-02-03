#!/bin/bash

#### Deps ####
# Needs GrinHelper ( https://github.com/dewdeded/GrinHelper on remote node)

#### Configuration ####
ConfigFile="$(pwd)/GrinHelper-NodeList.conf"
UpdateURL="https://raw.githubusercontent.com/dewdeded/GrinHelper/master/GrinHelper.sh"
BaseDir="/root/mw"
RustDir="~/.cargo/bin"

#### Begin main script ####
source "$ConfigFile"

# Function Check Stats
option_1() {
	clear
	echo -e "\033[0;33mNetwork height:			$(curl -s https://grintest.net/v1/chain | jq .height)\033[0m"
	echo -e "\033[0;33mNetwork difficulty:		$(curl -s https://grintest.net/v1/chain | jq .total_difficulty)\033[0m"

	for host in "${hosts[@]}"; do
		IFS=":" names=($host)
		echo -e "\033[0;34m\nHostname: ${names[2]} (IP: ${names[1]})\n\033[0m\n"

		ssh ${names[1]} /bin/grinhelper remote_stats

	done
	echo ""
	echo -e "\033[0;33m\nPress ENTER To Return\033[0m"
	read continue
}

# Function Check Outputs
option_2() {
	clear

	for host in "${hosts[@]}"; do
		IFS=":" names=($host)
		echo -e "\nHostname: ${names[2]} (IP: ${names[1]})\n"
		cmd="export PATH=\"$BaseDir/grin/target/debug:$RustDir/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\" ; cd $BaseDir/grin/node1; grin wallet -p password outputs"
		ssh -o LogLevel=QUIET ${names[1]} -t "$cmd"
	done

	echo -e "\033[0;33m\nPress ENTER To Return\033[0m"
	read continue
}

# Function Check Balances
option_3() {
    clear

	for host in "${hosts[@]}"; do
		IFS=":" names=($host)
		echo -e "\nHostname: ${names[2]} (IP: ${names[1]})\n"
		cmd="export PATH=\"$BaseDir/grin/target/debug:$RustDir/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\"; pushd "$BaseDir/grin/node1" > /dev/null ; grin wallet -p password info|grep Spend"
		balance=$(ssh -o LogLevel=QUIET ${names[1]} -t "$cmd" | awk '{print $4}')
		echo "${names[2]} has $balance"
	done

	echo -e "\033[0;33m\nPress ENTER To Return\033[0m"
	read continue
}

# Function Update Grinhelper
option_u() {
	clear

	for host in "${hosts[@]}"; do
		IFS=":" names=($host)
		echo -e "\nUpdating Grinhelper at Hostname: ${names[2]} (IP: ${names[1]})\n"
		ssh ${names[1]} "wget -q $UpdateURL -O /bin/grinhelper; chmod +x /bin/grinhelper"
		echo "Finished updating Grinhelper at ${names[2]}"

	done

	echo -e "\033[0;33m\nPress ENTER To Return\033[0m"
	read continue
}

## Check if CLI argument passed to start updating nodes
if [ "$1" == "update" ]; then
	echo Updating nodes
	option_u
	exit 0
fi

while :; do
	clear
	echo "=========================================================================="
	figlet G H Check
	figlet Remote Nodes
	echo -e "All functions, will be executed on all your Grin nodes."
	echo "1) Check Sync & Mining Stats"
	echo "2) Check Outputs"
	echo "3) Check Balance"
	echo ""
	echo "u) Update Grinhelper"
	echo "e) Exit"
	echo "=========================================================================="
	echo ""
	echo "Please select an option: "
	read m_menu

	case "$m_menu" in

	1) option_1 ;;
	2) option_2 ;;
	3) option_3 ;;
	u) option_u ;;
	e) exit 0 ;;
	*)
		echo "Error, invalid input. Press ENTER to go back."
		read
		;;

	esac
done
