#!/bin/bash

#### Direct Download ####
# wget https://raw.githubusercontent.com/dewdeded/GrinHelper/master/GrinHelper.sh -O /bin/grinhelper; chmod +x /bin/grinhelper

#### Configuration ####
# Setup path to Grin server logfile
PathGrinLogFile=$HOME/mw/grin/server/grin.log
# Max logfile size
MaxLogSize=100M

#############################################################

#### Function definition ####
## Installer Rust
rust_installer() {
	while true; do
		read -p "Rust not found. Do you wish to install Rust now? " yn
		case $yn in
		[Yy]*) break ;;
		[Nn]*) exit ;;
		*) echo "Please answer yes or no." ;;
		esac
	done
	export TERM=xterm
	sudo apt-get update -y
	sudo apt-get install build-essential cmake -y

	curl https://sh.rustup.rs -sSf | sh
	source $HOME/.cargo/env
	echo source $HOME/.cargo/env >>$HOME/.bashrc
}

## Installer Clang
clang_installer() {
	while true; do
		read -p "Clang not found. Do you wish to install Clang now? " yn
		case $yn in
		[Yy]*) break ;;
		[Nn]*) exit ;;
		*) echo "Please answer yes or no." ;;
		esac
	done
	export TERM=xterm
	sudo apt-get update -y
	sudo apt-get install dialog psmisc -y
	sudo dpkg-reconfigure locales
	sudo apt-get install clang-3.8 -y
}

## Installer Grin
main_installer() {
	while true; do
		read -p "Do you wish to install Grin? " yn
		case $yn in
		[Yy]*) break ;;
		[Nn]*) exit ;;
		*) echo "Please answer yes or no." ;;
		esac
	done
	sudo apt-get install git psmisc -y
	echo export PATH=$HOME/mw/grin/target/debug:$PATH >>$HOME/.bashrc
	cd $HOME
	mkdir mw/
	cd mw
	git clone https://github.com/mimblewimble/grin.git
	cd grin
	git checkout milestone/testnet1
	source $HOME/.cargo/env
	cargo build --verbose
	mkdir node1 server
	cp grin.toml node1/
	cp grin.toml server/
	main_menu
}

## Starter Wallet Node
my_wallet() {
	cd $HOME/mw/grin/node1
	export PATH=$HOME/mw/grin/target/debug:$PATH
	if [ -f "$HOME/mw/grin/node1/wallet.seed" ]; then
		echo Grin Node is now running, please keep this window open
		grin wallet -p password -e listen
	else
		echo Grin Node is now running, please keep this window open
		grin wallet init
		grin wallet -p password -e listen
	fi
}

## Starter Mining Server
my_mining_server() {
	cd $HOME/mw/grin/server
	export PATH=$HOME/mw/grin/target/debug/:$PATH
	grin server -m run
}

## Starter Nonmining Server
my_nonmining_server() {
	cd $HOME/mw/grin/server
	export PATH=$HOME/mw/grin/target/debug/:$PATH
	grin server run
}

## Show Spend Balances
my_spendbalance() {
	cd $HOME/mw/grin/node1
	export PATH=/$HOME/mw/grin/target/debug/:$PATH
	if [ -f "$HOME/mw/grin/node1/wallet.seed" ]; then
		grin wallet -p password info
		echo "Press ENTER To Return"
		read continue
	else
		grin wallet init
		grin wallet -p password info
		echo "Press ENTER To Return"
		read continue
	fi
}

## Show Outputs
my_outputs() {
	cd $HOME/mw/grin/node1
	export PATH=$HOME/mw/grin/target/debug/:$PATH
	if [ -f "$HOME/mw/grin/node1/wallet.seed" ]; then
		grin wallet -p password outputs
		echo "Press ENTER To Return"
		read continue
	else
		grin wallet init
		grin wallet -p password outputs
		echo "Press ENTER To Return"
		read continue
	fi
}

## Term setup

term_setup() {
	if [ ! -f /etc/hostname ]; then
		hostname -a >/etc/hostname
	fi
	host=$(cat /etc/hostname)
	export TERM=xterm
}

## Main menu
main_menu() {
	while :; do
		clear
		figlet -f small "GrinHelper Suite";
	#	figlet -f small "$host"

		echo -e "\033[0;33mGrinhelper Suite @ $host:\033[0m \033[31mMain Menu\033[0m"
		echo -e "\n"
		echo "1) Grin Wallet Server (Start detached)"
		echo "2) Grin Mining Node (Start detached)"
		echo "3) Grin Non-mining Node (Start detached)"
		echo " "
		echo "4) View Wallet logfile"
		echo "5) View Node logfile"
		echo " "
		echo "8) Show balance"
		echo "9) Show outputs"
		echo " "
		echo "c) Check Grin processes"
		echo "s) Check sync & mining stats"
		echo " "
		echo "k) Killall Grin processes"
		echo "kw) Kill Grin Wallet"
		echo "ks) Kill Grin Node"
		echo " "
		echo "u1) Update Grin (to latest version in branch: master)"
		echo "u2) Update Grindhelper"
		echo " "
		echo "e) Exit"
		echo "====================================="
		read -rep $'Please select an option: ' m_menu

		case "$m_menu" in

		1) option_1 ;;
		2) option_2 ;;
		3) option_3 ;;
		4) option_4 ;;
		5) option_5 ;;
		6) option_6 ;;
		c) option_c ;;
		s) option_s ;;
		k) option_k ;;
		kw) option_kw ;;
		ks) option_ks ;;
		8) option_8 ;;
		9) option_9 ;;
		u1) option_u1 ;;
		u2) option_u2 ;;
	
		e) exit 0 ;;
		*)
			echo "Error, invalid input. Press ENTER to go back."
			read
			;;
		esac
	done
}

option_1() {
	##export function, run a new shell starting the wallet/node listener
	export -f my_wallet
	screen -dm -S grinwallet /bin/grinhelper my_wallet
}

option_2() {
	##export function, run a new shell starting the server
	export -f my_mining_server
	screen -dm -S grinserver /bin/grinhelper my_mining_server
}

option_3() {
	##export function, run a new shell starting the server
	export -f my_nonmining_server
	screen -dm -S grinserver /bin/grinhelper my_nonmining_server
}

option_4() {
	tail -f $HOME/mw/grin/node1/grin.log
	echo "Press ENTER To Return"
	read continue
	main_menu
}


option_5() {
	tail -f $PathGrinLogFile
	echo "Press ENTER To Return"
	read continue
	main_menu
}


option_6() {
	echo "option 6"
	##TODO
}

option_c() {
	echo " "
	echo "Checking services ..."
	echo " "
	if ps aux | grep -q "[m]y_wallet"; then echo "Wallet is running"; else echo "Wallet is NOT running"; fi
	if ps aux | grep -q "[m]y_mining_server"; then echo "Mining server is running"; else echo "Mining server is NOT running"; fi
	if ps aux | grep -q "[m]y_nonmining_server"; then echo "Non mining server is running"; else echo "Non mining server is NOT running"; fi
	echo " "
	LogFileSize=$(ls -lh $HOME/mw/grin/server/grin.log | awk '{print $5}')
	echo "Size Logfile: $LogFileSize"
	echo " "
	echo "Press ENTER To Return"
	read continue
	main_menu
}

option_s() {
	# tail -n 100 grin.log | grep Graphs|tail -n 1 |  cut -c21-
	echo " "
	echo "Network height:			$(curl -s https://grintest.net/v1/chain | jq .height)"
	echo "Network difficulty:		$(curl -s https://grintest.net/v1/chain | jq .total_difficulty)"
	echo " "
	echo "Local height:			$(curl -s http://127.0.0.1:13413/v1/chain | jq .height)"
	echo "Local difficulty:		$(curl -s http://127.0.0.1:13413/v1/chain | jq .total_difficulty)"
	echo " "
	if ps aux | grep -q "[m]y_mining_server"; then
		echo "Chain type: 			$(grep chain_type grin.toml | awk '{print $3}' | sed 's/"//g')."
		echo "Last graph time:		$(grep Graphs $PathGrinLogFile | tail -n 1 | awk ' { print $15 } ' | sed -e 's/;//g')"
		echo "Graphs per second:		$(grep Graphs $PathGrinLogFile | tail -n 1 | awk ' { print $19 } ')"
	else
		echo " "
		echo "Mining server is NOT running"
	fi

	echo " "

	echo "Press ENTER To Return"
	read continue
	main_menu
}

option_k() {
	echo "Killing Grin Wallet & Server"
	killall -9 grin
	killall -9 screen
	echo "Press ENTER To Return"
	read continue
	main_menu
}


option_kw() {
	echo "Killing Grin Wallet"
	screen -X -S grinwallet kill
	screen -wipe
	echo "Press ENTER To Return"
	read continue
	main_menu
}


option_ks() {
	echo "Killing Grin Server"
	screen -X -S grinserver kill
	screen -wipe
	echo "Press ENTER To Return"
	read continue
	main_menu
}

option_8() {
	my_spendbalance
}

option_9() {
	my_outputs
}


option_u1() {
	echo "Updating Grin to latest version branch: master"
	cd $HOME/mw/grin/
	git checkout master
	git pull
    cargo build
	cp node1/grin.toml node1/grin.toml-bu-$(date +%Y%m%d)
	cp server/grin.toml server/grin.toml-bu-$(date +%Y%m%d)
	
    cp grin.toml node1/
	cp grin.toml server/
	echo "Grin update update successful."
	echo "New grin.toml deployed. Old grin.toml backupped."
	echo -e "\nPress ENTER To Return"
	read continue
	/bin/grinhelper
	exit 0
}


option_u2() {
	echo "Updating"
	wget -q https://raw.githubusercontent.com/dewdeded/GrinHelper/master/GrinHelper.sh -O /bin/grinhelper
	chmod +x /bin/grinhelper
	clear
	echo "Grinhelper update successful"
	echo "Press ENTER To Return"
	read continue
	/bin/grinhelper
	exit 0
}

##### Autofix Logfile size
autofix_logfilesize() {
	# Delete to big logfile
	find "$PathGrinLogFile" -size +$MaxLogSize -delete

	# Restart Grin services
	if [ ! -f $PathGrinLogFile ]; then
		if ps aux | grep -q "[m]y_wallet"; then
			screen -S grinwallet -X quit
			option_1
		fi
		if ps aux | grep -q "[m]y_mining_server"; then
			screen -S grinserver -X quit
			option_2
		fi
		if ps aux | grep -q "[m]y_nonmining_server"; then
			screen -S grinserver -X quit
			option_3
		fi
		screen -wipe
	fi
}

remote_stats() {
	echo "Local height:			$(curl -s http://127.0.0.1:13413/v1/chain | jq .height)"
	echo "Local difficulty:		$(curl -s http://127.0.0.1:13413/v1/chain | jq .total_difficulty)"
	echo "Graphs per second:		$(grep Graphs $PathGrinLogFile | tail -n 1 | awk ' { print $19 } ')"
	LogFileSize=$(ls -lh $HOME/mw/grin/server/grin.log | awk '{print $5}')
	echo "Size Logfile:			$LogFileSize"

	if ps aux | grep -q "[m]y_wallet"; then echo "Wallet is running"; else echo "Wallet is NOT running"; fi
	if ps aux | grep -q "[m]y_mining_server"; then echo "Mining server is running"; else echo "Mining server is NOT running"; fi
	if ps aux | grep -q "[m]y_nonmining_server"; then echo "Non mining server is running"; else echo "Non mining server is NOT running"; fi
}

#############################################################
### Begin Main Script
#############################################################

# Test and install script deps
which sudo  >/dev/null 2>&1 || {
	apt-get update -y
	apt-get install -y sudo
}

which sudo figlet jq screen curl >/dev/null 2>&1 || {
	sudo apt-get update -y
	sudo apt-get install -y figlet jq screen curl
}

## Check if Clang is installed
if type -p clang-3.8 >/dev/null; then
	:
else
	clang_installer
	clear
	echo "Clang installed, restart GrinHelper."
	exit 0
fi

## Check if Rust is installed
if [ -f $HOME/.cargo/env ]; then
	source $HOME/.cargo/env
fi

if type -p rustc >/dev/null; then
	:
else
	rust_installer
	clear
	echo "Rust installed, restart GrinHelper."
	source $HOME/.cargo/env
	exit 0
fi

## Check if Grin is installed
if [ ! -d "$HOME/mw/grin/" ]; then
	main_installer
fi

# trap ctrl-c and call ctrl_c() for quitting log file viewing
trap ctrl_c INT

function ctrl_c() {
	echo "** Trapped CTRL-C"
}

## Check if CLI argument passed to direct start wallet node
if [ "$1" == "my_wallet" ]; then
	my_wallet
fi

## Check if CLI argument passed to direct start grin mining server
if [ "$1" == "my_mining_server" ]; then
	my_mining_server
	exit 1
fi

## Check if CLI argument passed to direct start grin nonming server
if [ "$1" == "my_nonmining_server" ]; then
	my_nonmining_server
	exit 1
fi

## Check if CLI argument passed to view remote stats
if [ "$1" == "remote_stats" ]; then
	remote_stats
	exit 1
fi

autofix_logfilesize
term_setup
figlet GrinHelper Suite
main_menu
