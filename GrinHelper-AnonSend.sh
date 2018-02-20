#!/bin/bash

#### Configuration ####
BaseDir="/root/mw"

### Definition Tor2Web-Proxies
# onion.link
# onion.to
t2wproxies=(
	hiddenservice.net
	onion.casa
)

#### Begin main script ####
#source "$ConfigFile"


### Functions Sender
# Function Retrieve Secret
function_Retrieve_Secret() {
	clear

	echo "Enter TXID to check: "
	read m_checkid
	
	if [[ $m_checkid == *"@gr.in"* ]]; then echo -e "\nCheck TXID:   Ok."
	else
		echo -e "\nError, invalid TXID."
		echo -e "\033[0;33m\nPress ENTER To Return\033[0m"
		read continue
		main_menu
	fi
	txid=$(echo $m_checkid | awk -F@ '{print $1}')

	url1="http://hkrd3fcptk2cpbrf."

	gate="$(echo $RANDOM % 2 | bc)"
	echo
	url2=${t2wproxies[$gate]}
	url3="/$txid.html"
	host=$url1$url2
	finalurl=$url1$url2$url3
	echo "Trying to retreive transfer secret for TXID: $txid"
	echo "Trying via TOR2Web proxy: $url2"

	wget --quiet --output-document=send.html --no-cookies --header "Cookie: disclaimer_accepted=1" $finalurl >/dev/null 2>/dev/null

	if grep -q Ok send.html; then echo -e "\nSuccess, the correct secret was retreived."
	else
		echo -e "\nError please try again! Check with Receiver if TXID is ok.\n"
		echo -e "\033[0;33m\nPress ENTER To Return\033[0m"
		read continue
		main_menu
	fi
	txsecret=$(cat send.html | sed 's/<br>Ok//g')
	#return $txsecret
	
}

# Function Update Grinhelper
function_Send_Transaction() {
	clear
	function_Retrieve_Secret
    echo $txsecret

	while true; do
		read -p "Do you want to continue and send Grin now: (y/n): " yn
		case $yn in
		[Yy]*) break ;;
		[Nn]*) main_menu ;;
		*) echo "Please answer yes or no." ;;
		esac
	done

	read -p "How much Grin do you want to send: [1-10000]: " amn

	if ! [[ "$amn" =~ ^[0-9]+$ ]]; then
		exec >&2
		echo "error: Not a number"
		exit 1
	fi

	if (($amn > 10000)); then
		exec >&2
		echo "error: Amount to big"
		exit 1
	fi

	if (($amn < 1)); then
		exec >&2
		echo "error: Amount to small"
		exit 1
	fi

	echo "Generating transaction JSON file."
	echo "Encrypt transaction JSON file."
	echo "Publish transaction."


	tree > finaltx.txt
	openssl enc -aes-256-cbc -salt -in finaltx.txt -out filesend.enc -k $txsecret

	curl --upload-file ./finalsend.enc https://transfer.sh/hello.txt

	rm send.html
	rm finalsend.enc

	echo -e "\033[0;33m\nPress ENTER To Return\033[0m"
	read continue
}

# Function Check Finalization (Receiver)
function_Check_Finalization() {
	clear
	echo "Enter TXID to check: "
	read m_checkid
	echo $m_checkid
	echo -e "\033[0;33m\nPress ENTER To Return\033[0m"
	read continue
}


### Functions Receiver
# Function Publish Secret (Receiver)
function_Publish_Secret() {
	clear
	clear
	echo "Generating transfer secret ..."

	export txid=$(
		tr </dev/urandom -dc A-Za-z0-9 | head -c20
		echo
	)
	export txsecret=$(
		tr </dev/urandom -dc A-Za-z0-9 | head -c100
		echo
	)

	echo "Finished generating transfer secret."

	url1="http://g4eb3vctboop2v3o."

	gate="$(echo $RANDOM % ${#t2wproxies[@]} | bc)"
	echo
	url2=${t2wproxies[$gate]}
	url3="/receive/$txid/$txsecret"
	host=$url1$url2
	finalurl=$url1$url2$url3
	echo "Trying to upload secret to our rendezvous point on the TOR network: g4eb3vctboop2v3o.onion"
	echo "Trying via TOR2Web proxy: $url2"
	wget --quiet --output-document=upload.html --no-cookies --header "Cookie: disclaimer_accepted=1" $finalurl >/dev/null 2>/dev/null

	if grep -q Ok upload.html; then
		echo -e "\nSuccess, your key was uploaded."
		echo -e "Tell the sender to send to: $txid@gr.in\n"
	else
		echo -e "Error please try again!\n"
		exit 1
	fi
	rm upload.html
	echo $txid >.history
	echo -e "\033[0;33m\nPress ENTER To Return\033[0m"
	read continue
}

# Function Check Completion (Receiver)
function_Completion() {
	clear
    function_Retrieve_Secret


	openssl enc -aes-256-cbc -d -in file.txt.enc -out file.txt -k $txsecret
	echo -e "\033[0;33m\nPress ENTER To Return\033[0m"
	read continue
}


## Main menu
main_menu() {
	while :; do
		clear
		echo "=========================================================================="
		figlet -f small -f small GrinHelper Suite
		figlet -f small -f small AnonSend
		echo "p) Receiver: Publish Secret"
		echo "c) Receiver: Check Completion"
		echo ""
		echo "s) Sender: Retreive Secret & Send Transaction"
		#echo "f) Sender: Check Finalization"
		echo ""

		echo "e) Exit"
		echo "=========================================================================="
		echo ""
		echo "Please select an option: "
		read m_menu

		case "$m_menu" in

		p) function_Publish_Secret ;;
		c) function_Completion ;;
		s) function_Send_Transaction ;;
		f) function_Check_Finalization ;;
		e) exit 0 ;;
		*)
			echo "Error, invalid input. Press ENTER to go back."
			read
			;;

		esac
	done
}

main_menu
