#!/usr/bin/bash
PHONE_MAC="<YOUR_PHONES_MAC_ADRESS>" # Mac adresses are static
PHONE_KEY="~/.ssh/<YOUR_SECRET_KEY>" # Secret key to use while connect to phone

updateIP() { #GET IP ADRESS OF THE PHONE FROM BELOW MAC ADRESS
	printf "$1 updating the ip adress...\r"
	nmap -sn 192.168.1.0/24>/dev/null
	PHONE_IP=`for ((i=1; i<=255; i++));do arp -a 192.168.1.$i; done | grep $PHONE_MAC | awk '{print $2}' | sed -e 's/(//' -e 's/)//'`
	echo $PHONE_IP>/tmp/phone_ip.tmp
	printf "Updated!                                               \n"
}

if [ -e /tmp/phone_ip.tmp ]
	then
		PHONE_IP=`cat /tmp/phone_ip.tmp`
		if [[ `arp -a $PHONE_IP` == *'no'* ]] # if ip is unavailable
			then updateIP "Renewing needed,"
		fi
	else									  # if no ip saved before
		updateIP "Launching for the first time,"
fi

PHONE_SSH="ssh $PHONE_IP -p 8022 -i $PHONE_KEY"

if [ -z $1 ]
	then
		printf "Connecting to SSH...\r"
		eval $PHONE_SSH
else
	if [ $1 == "cp-set" ]
		then eval "$PHONE_SSH termux-clipboard-set '$2'" &
	elif [ $1 == "cp-get" ]
		then $PHONE_SSH termux-clipboard-get
	elif [ $1 == "pull" ]
		then scp -P 8022 -i $PHONE_KEY $PHONE_IP:$2 $3
	elif [ $1 == "push" ]
		then scp -P 8022 -i $PHONE_KEY $2 $PHONE_IP:$3
	elif [ $1 == "share" ]
		then
			eval "$PHONE_SSH rm -rf ./tmp/*"
			scp -P 8022 -i $PHONE_KEY $2 $PHONE_IP:./tmp/
			eval "$PHONE_SSH termux-share -a send ./tmp/*"
	elif [ $1 == "mount" ]
		then sshfs -p 8022 -o IdentityFile=$PHONE_KEY $PHONE_IP:$2 $3
	elif [ $1 == "scan" ]
		then updateIP "Manually"
	else
		echo "Mini Termux Controller - github/Kebablord

scan                *  update phone's ip,u can use it if you encounter a problem
cp-set <string>     -  copies the string to phone's clipboard
cp-get              -  return the string from phone's clipboard
pull  <src> <dest>  -  pull the file from phone src to dest
push  <src> <dest>  -  push the file to phone dest from local src
share <src>         -  Android's share menu prompts for specific string or file
mount <src> <dest>  -  use SSHFS to mount specific android folder to linux folder
"
	fi
fi
