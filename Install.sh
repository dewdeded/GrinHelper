#!/bin/sh
export TERM=xterm
clear
echo Downloading GrinHelper.sh and GrinHelper-Remote.sh to $(pwd)

wget -O ./grinhelper https://raw.githubusercontent.com/dewdeded/GrinHelper/master/GrinHelper.sh 2>&1 | grep "^wget:"
wget -O ./grinhelper-remote https://raw.githubusercontent.com/dewdeded/GrinHelper/master/GrinHelper-Remote.sh 2>&1 | grep "^wget:"

echo Make GrinHelper & GrinHelper Remote script executable
chmod +x ./grinhelper
chmod +x ./grinhelper-remote

while true; do
		read -p "Do you want to move GrinHelper (./grinhelper) to /bin?" yn
		case $yn in
		[Yy]*) echo "Ok, I move GrinHelper to /bin"; sudo mv ./grinhelper /bin ; break ;;
		[Nn]*) break ;;
		*) echo "Please answer yes or no." ;;
		esac
	done

while true; do
		read -p "Do you want to move GrinHelper-Remote (./grinhelper-remote) to /bin?" yn
		case $yn in
		[Yy]*) echo "Ok, I move GrinHelper-Remote to /bin"; sudo mv ./grinhelper-remote /bin ; break ;;
		[Nn]*) echo -e "Ok, the GrinHelper script stays in $(pwd).\nConsider moving it to: if you prefer choose /usr/bin, /usr/local/bin, ~/bin/, etc."; break ;;
		*) echo "Please answer yes or no." ;;
		esac
	done

echo "If you like Camel Case notation, add these aliases for GrinHelper for more convenience."
echo "echo alias grinhelper=GrinHelper >> ~/.bashrc"
echo "echo alias GrinHelper-Remote=grinhelper-remote >> ~/.bashrc"