#!/bin/bash

#### Direct Download ####
# wget https://raw.githubusercontent.com/dewdeded/GrinHelper/master/GrinHelper.sh -O /bin/grinhelper; chmod +x /bin/grinhelper

#### Configuration ####
# Setup path to Grin server logfile
PathGrinServerLogFile=$HOME/mw/grin/server/grin.log
# Setup path to Grin wallet logfile
PathGrinWalletLogFile=$HOME/mw/grin/node1/grin.log
# Update URLs
UpdateURL1="https://raw.githubusercontent.com/dewdeded/GrinHelper/master/GrinHelper.sh"
UpdateURL2="https://raw.githubusercontent.com/dewdeded/GrinHelper/master/GrinHelper-Remote.sh"
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
		read -p "Rust not found. Do you wish to install Grin? " yn
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
	mkdir node1 server server/testnet2
	cp grin.toml node1/
	cp grin.toml server/
	#cp grin.toml server/testnet2
	main_menu
}

## Starter Wallet Node
my_wallet() {
	cd $HOME/mw/grin/node1
	export PATH=$HOME/mw/grin/target/debug:$PATH
	if [ -f "$HOME/mw/grin/node1/wallet.seed" ]; then
		echo Grin Server is now running, please keep this window open
		grin wallet -p password -e listen
	else
		echo Grin Server is now running, please keep this window open
		grin wallet init
		grin wallet -p password -e listen
	fi
}

## Starter Mining Server
my_mining_server() {
	cd $HOME/mw/grin/server
	sed -i '/chain_type/c\chain_type = "Testnet1"' grin.toml
	sed -i '/db_root/c\db_root = ".grin"' grin.toml
	echo "Starting Testnet1 Server: Mining enabled" > $PathGrinServerLogFile
	export PATH=$HOME/mw/grin/target/debug/:$PATH
	grin server -m run
}

## Starter Mining Server Testnet 2
my_mining_server_testnet2() {
	cd $HOME/mw/grin/server
	sed -i '/chain_type/c\chain_type = "Testnet2"' grin.toml
	sed -i '/db_root/c\db_root = ".grin-testnet"' grin.toml
	echo "Starting Testnet2 Server: Mining enabled" >$PathGrinServerLogFile
	export PATH=$HOME/mw/grin/target/debug/:$PATH
	grin server -m run
}

## Starter Nonmining Server
my_nonmining_server() {
	cd $HOME/mw/grin/server
	sed -i '/chain_type/c\chain_type = "Testnet1"' grin.toml
	sed -i '/db_root/c\db_root = ".grin"' grin.toml
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
		echo -e "\033[0;33mGrinhelper Suite @ $host\n\033[0m"
		echo "g1) Grin Wallet @ Testnet1				f1) Grin Wallet @ Testnet2"
		echo "g2) Grin Server: Mining enabled @ Testnet1		f2) Grin Server: Mining enabled @ Testnet2"
		echo "g3) Grin Server: Mining disabled @ Testnet1		f3) Grin Server: Mining disabled @ Testnet2"
		echo ""
		echo "l1) View Logfile: Grin Wallet @ Testnet1"
		echo "l2) View Logfile: Grin Server @ Testnet1"
		echo " "
		echo "s1) Show Balance"
		echo "s2) Show Outputs"
		echo "s3) Show Sync & Mining Stats"
		echo " "
		echo "c1) Check Grin Processes - Shows running Grin instances"
		echo "c2) Check Grin Connectivity - Checks public reachability of local Grins network ports"
		echo " "
		echo "k1) Killall Grin Processes - Stops all Grin instances"
		echo "k2) Kill Grin Wallet - Stops Grin Wallet"
		echo "k3) Kill Grin Server - Stops Grin Server"
		echo " "
		echo "u1) Update Grin - Update Grin to latest commit in master branch."
		echo "u2) Update GrinHelper - Update GrinHelper Suite"
		echo ""
		read -rep $'\033[31mMain Menu\033[0m - Select Option: ' m_menu

		case "$m_menu" in

		# Grin Testnet1
		g1) option_g1 ;;
		g2) option_g2 ;;
		g3) option_g3 ;;

		# Grin Testnet2
		f1) option_f1 ;;
		f2) option_f2 ;;
		f3) option_f3 ;;

		# Logfiles
		l1) option_l1 ;;
		l2) option_l2 ;;

		# Stats
		s1) option_s1 ;;
		s2) option_s2 ;;
		s3) option_s3 ;;

		# Checks
		c1) option_c1 ;;
		c2) option_c2 ;;

		# Kill
		k1) option_k1 ;;
		k2) option_k2 ;;
		k3) option_k3 ;;

		# Updates
		u1) option_u1 ;;
		u2) option_u2 ;;

		e) exit 0 ;;
		*)
			echo "Error, invalid input. Press E to exit GrinHelper."
			echo "Press ENTER to go back."
			read
			;;
		esac
	done
}

option_g1() {
	##export function, run a new shell starting the wallet/node listener
	export -f my_wallet
	screen -dm -S grinwallet /bin/grinhelper my_wallet
	echo "Starting Grin Wallet."
	sleep 2
}

option_g2() {
	##export function, run a new shell starting the server
	export -f my_mining_server
	rm $PathGrinServerLogFile
	screen -dm -S grinserver /bin/grinhelper my_mining_server
	echo "Starting Testnet1 Server: Mining enabled" >> $PathGrinServerLogFile
	echo "Starting Testnet1 Server: Mining enabled"
	sleep 2
}

option_g3() {
	##export function, run a new shell starting the server
	export -f my_nonmining_server
	rm $PathGrinServerLogFile
	screen -dm -S grinserver /bin/grinhelper my_nonmining_server
	echo "Starting Testnet1 Grin Server: Mining disabled" >> $PathGrinServerLogFile
	echo "Starting Testnet1 Grin Server: Mining disabled"
	sleep 2
}

option_f1() {
	echo "Todo"
	sleep 2
}

option_f2() {
	##export function, run a new shell starting the server
	export -f my_mining_server_testnet2
	rm $PathGrinServerLogFile
	screen -dm -S grinserver /bin/grinhelper my_mining_server_testnet2
	echo "Starting Testnet2 Server: Mining enabled" >> $PathGrinServerLogFile
	echo "Starting Testnet2 Server: Mining enabled"
	sleep 2
}


option_f3() {
	echo "Todo"
	sleep 2
}

option_l1() {
	tail -f $PathGrinWalletLogFile
	echo "Press ENTER To Return"
	read continue
	main_menu
}

option_l2() {
	tail -f $PathGrinServerLogFile
	echo "Press ENTER To Return"
	read continue
	main_menu
}

option_c1() {
	echo " "
	echo "Checking services ..."
	echo " "
	if ps aux | grep -q "[m]y_wallet"; then echo "Wallet is running"; else echo "Wallet is NOT running"; fi
	if ps aux | grep -q "[m]y_mining_server"; then echo "Mining server is running"; else echo "Mining server is NOT running"; fi
	if ps aux | grep -q "[m]y_nonmining_server"; then echo "Non mining server is running"; else echo "Non mining server is NOT running"; fi
	echo " "
	LogFileSize=$(ls -lh $PathGrinServerLogFile | awk '{print $5}')
	echo "Size Logfile: $LogFileSize"
	echo " "
	echo "Press ENTER To Return"
	read continue
	main_menu
}

option_c2() {
	echo " "
	echo "Checking if Grins ports are publicly reachable ..."
	echo " "

	if netstat -an | grep -q "13413"; then echo "Standard port 13413 is open."; else echo "Standard port 13413 is NOT open."; fi
	if netstat -an | grep -q "13414"; then echo "Standard port 13414 is open."; else echo "Standard port 13414 is NOT open."; fi
	if netstat -an | grep -q "13415"; then echo "Standard port 13415 is open."; else echo "Standard port 13415 is NOT open."; fi
	export myip=$(curl -s icanhazip.com)
	echo -e "\nChecking if port 13413 is publicly reachable."
	nc -w 2 $myip 13413 </dev/null
	if [ "$?" == "0" ]; then echo Success, port 13413 is reachable.; else echo Fail, port 13413 is NOT reachable.; fi
	echo -e "\nChecking if port 13414 is publicly reachable."
	nc -w 2 $myip 13414 </dev/null
	if [ "$?" == "0" ]; then echo Success, port 13414 is reachable.; else echo Fail, port 13414 is NOT reachable.; fi
	echo -e "\nChecking if port 13415 is publicly reachable."
	nc -w 2 $myip 13415 </dev/null
	if [ "$?" == "0" ]; then echo Success, port 13415 is reachable.; else echo Fail, port 13415 is NOT reachable.; fi

	echo " "
	echo "Press ENTER To Return"
	read continue
	main_menu
}
option_s1() {
	my_spendbalance
}

option_s2() {
	my_outputs
}

option_s3() {
	echo " "
	echo "Network height:			$(curl -s https://grintest.net/v1/chain | jq .height)"
	echo "Network difficulty:		$(curl -s https://grintest.net/v1/chain | jq .total_difficulty)"
	echo " "
	echo "Local height:			$(curl -s http://127.0.0.1:13413/v1/chain | jq .height)"
	echo "Local difficulty:		$(curl -s http://127.0.0.1:13413/v1/chain | jq .total_difficulty)"
	echo " "
	if ps aux | grep -q "[m]y_mining_server"; then
		echo "Chain type: 			$(grep chain_type $HOME/mw/grin/server/grin.toml | awk '{print $3}' | sed 's/"//g')"
		echo "Last graph time:		$(grep Graphs $PathGrinServerLogFile | tail -n 1 | awk ' { print $15 } ' | sed -e 's/;//g')"
		echo "Graphs per second:		$(grep Graphs $PathGrinServerLogFile | tail -n 1 | awk ' { print $19 } ')"
	else
		echo " "
		echo "Mining server is NOT running"
	fi

	echo " "

	echo "Press ENTER To Return"
	read continue
	main_menu
}

option_k1() {
	echo "Killing Grin Wallet & Server"
	killall -9 grin
	killall -9 screen
	echo "Press ENTER To Return"
	read continue
	main_menu
}

option_k2() {
	echo "Killing Grin Wallet"
	screen -X -S grinwallet kill
	screen -wipe
	echo "Press ENTER To Return"
	read continue
	main_menu
}

option_k3() {
	echo "Killing Grin Server"
	screen -X -S grinserver kill
	screen -wipe
	echo "Press ENTER To Return"
	read continue
	main_menu
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
	main_menu
}

option_u2() {
	echo "Updating"
	sudo wget -q $UpdateURL1 -O /bin/grinhelper; 
	sudo chmod +x /bin/grinhelper;
	if [ ! -f "/bin/GrinHelper" ]; then sudo ln -s /bin/grinhelper /bin/GrinHelper; fi;
	sudo wget -q $UpdateURL2 -O /bin/GrinHelper-Remote;
	sudo chmod +x /bin/GrinHelper-Remote"
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
	find "$PathGrinServerLogFile" -size +$MaxLogSize -delete

	# Restart Grin services
	if [ ! -f $PathGrinServerLogFile ]; then
		if ps aux | grep -q "[m]y_wallet"; then
			screen -S grinwallet -X quit
			option_g1
		fi
		if ps aux | grep -q "[m]y_mining_server"; then
			screen -S grinserver -X quit
			option_g2
		fi
		if ps aux | grep -q "[m]y_nonmining_server"; then
			screen -S grinserver -X quit
			option_g3
		fi
		screen -wipe
	fi
}

remote_stats() {
	echo "Local height:			$(curl -s http://127.0.0.1:13413/v1/chain | jq .height)"
	echo "Local difficulty:		$(curl -s http://127.0.0.1:13413/v1/chain | jq .total_difficulty)"
	echo "Graphs per second:		$(grep Graphs $PathGrinServerLogFile | tail -n 1 | awk ' { print $19 } ')"
	LogFileSize=$(ls -lh $PathGrinServerLogFile | awk '{print $5}')
	echo "Size Logfile:			$LogFileSize"

	if ps aux | grep -q "[m]y_wallet"; then echo "Wallet is running"; else echo "Wallet is NOT running"; fi
	if ps aux | grep -q "[m]y_mining_server"; then echo "Mining server is running"; else echo "Mining server is NOT running"; fi
	if ps aux | grep -q "[m]y_nonmining_server"; then echo "Non mining server is running"; else echo "Non mining server is NOT running"; fi
}

#############################################################
### Begin Main Script
#############################################################

### Checks 
# Test and install script deps
which sudo >/dev/null 2>&1 || {
	apt-get update -y
	apt-get install -y sudo
}

which figlet jq screen curl >/dev/null 2>&1 || {
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

########### Begin programm logic
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

## Check if CLI argument passed to direct start grin mining server
if [ "$1" == "my_mining_server_testnet2" ]; then
	my_mining_server_testnet2
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
clear
figlet -f small Launching
figlet GrinHelper Suite
sleep 1.5
clear
main_menu