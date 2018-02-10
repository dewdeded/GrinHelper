#!/bin/bash
export TERM=xterm
clear
echo -e "\nDownloading GrinHelper.sh and GrinHelper-Remote.sh to $(pwd)"

wget -O ./grinhelper https://raw.githubusercontent.com/dewdeded/GrinHelper/master/GrinHelper.sh 2>&1 | grep "^wget:"
wget -O ./grinhelper-remote https://raw.githubusercontent.com/dewdeded/GrinHelper/master/GrinHelper-Remote.sh 2>&1 | grep "^wget:"

echo -e "\nMake GrinHelper & GrinHelper Remote script executable"
chmod +x ./grinhelper
chmod +x ./grinhelper-remote

while true; do
		read -p "Do you want to move GrinHelper (./grinhelper) to /bin?" yn
		case $yn in
		[Yy]*) echo -e "\nOk, I move GrinHelper to /bin"; sudo mv ./grinhelper /bin ; break ;;
		[Nn]*) echo -e "\nOk, the GrinHelper script stays in $(pwd).\nConsider moving it to: if you prefer choose /usr/bin, /usr/local/bin, ~/bin/, etc."; break ;;
        *) echo "Please answer yes or no." ;;
		esac
	done

while true; do
		read -p "Do you want to move GrinHelper-Remote (./grinhelper-remote) to /bin?" yn
		case $yn in
		[Yy]*) echo -e "\nOk, I move GrinHelper-Remote to /bin"; sudo mv ./grinhelper-remote /bin ; break ;;
		[Nn]*) echo -e "\nOk, the GrinHelper-Remote script stays in $(pwd)."; break ;;
		*) echo "Please answer yes or no." ;;
		esac
	done

echo "\n\nIf you like Camel Case notation, add these aliases for GrinHelper for more convenience."
echo "echo alias grinhelper=GrinHelper >> ~/.bashrc"
echo "echo alias GrinHelper-Remote=grinhelper-remote >> ~/.bashrc"