#!/bin/bash
export TERM=xterm
clear
echo -e "\nDownloading GrinHelper.sh to $(pwd)/grinhelper"
echo -e "\nDownloading GrinHelper-Remote.sh to $(pwd)/grinhelper-remote"

wget -O ./grinhelper https://raw.githubusercontent.com/dewdeded/GrinHelper/master/GrinHelper.sh 2>&1 | grep "^wget:"
wget -O ./grinhelper-remote https://raw.githubusercontent.com/dewdeded/GrinHelper/master/GrinHelper-Remote.sh 2>&1 | grep "^wget:"

echo -e "\nMake GrinHelper & GrinHelper-Remote script executable\n"
chmod +x ./grinhelper
chmod +x ./grinhelper-remote

while true ; do
    	read -p "Do you want to move the GrinHelper-Remote script to /bin? (y/n): " yn
        case $yn in
        [Yy]*) echo -e "\nOk, I move GrinHelper-Remote to /bin.\n\n"; sudo mv ./grinhelper /bin ; break ;;
		[Nn]*) echo -e "Ok, the GrinHelper-Remote script stays in $(pwd).\n\n"; break ;;
        *) echo "Please answer yes or no." ;;
        esac
done


while true ; do
		read -p "Do you want to move the GrinHelper-Remote script to /bin? (y/n): " yn
		case $yn in
		[Yy]*) echo -e "\nOk, I move GrinHelper-Remote to /bin.\n\n"; sudo mv ./grinhelper-remote /bin ; break ;;
		[Nn]*) echo -e "Ok, the GrinHelper-Remote script stays in $(pwd).\n\n"; break ;;
		*) echo "Please answer yes or no." ;;
		esac
done

echo -e "\nRemoving install script."
rm -f Install.sh

echo -e "\n\nIf you like Camel Case notation, add these aliases for GrinHelper for more convenience.\n"
echo "echo \"alias grinhelper=GrinHelper\" >> ~/.bashrc"
echo "echo \"alias GrinHelper-Remote=grinhelper-remote\" >> ~/.bashrc"
echo -e "\n\n"
