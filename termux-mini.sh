#!/usr/bin/bash
PHONE_MAC="<YOUR_PHONES_MAC_ADRESS>" # Mac adresses are static
PHONE_KEY="~/.ssh/<YOUR_SECRET_KEY>" # Secret key to use while connect to phone

MACtoIP() { #GETS THE CURRENT IP ADRESS OF PHONE FROM IT'S MAC ADRESS
    printf "$1 updating the ip adress...\r" # $1 is the reason as parameter
    PHONE_IP=$(sudo arp-scan -l | grep $PHONE_MAC | awk '{print $1}')
    echo $PHONE_IP>/home/owo/.local/phone_ip.tmp
    printf "Updated! Current phone ip is: $PHONE_IP              \n"
}

if [ -e /home/owo/.local/phone_ip.tmp ] # Check if previous tmp file exists
    then PHONE_IP=`cat /home/owo/.local/phone_ip.tmp`
elif [ $1 != "scan" ]
    then MACtoIP "Launching for the first time,"
fi

PHONE_SSH="ssh $PHONE_IP -p 8022 -i $PHONE_KEY"

case $1 in
    run)
        eval "$PHONE_SSH ${@:2}"
        ;;
    cp-set)
        eval "$PHONE_SSH termux-clipboard-set '$2'" &
        ;;
    cp-get)
        $PHONE_SSH termux-clipboard-get
        ;;
    pull)
        scp -P 8022 -i $PHONE_KEY $PHONE_IP:$2 $3
        ;;
    push)
        scp -P 8022 -i $PHONE_KEY $2 $PHONE_IP:$3
        ;;
    share)
        eval "$PHONE_SSH rm -rf ./tmp/*"
        scp -P 8022 -i $PHONE_KEY $2 $PHONE_IP:./tmp/
        eval "$PHONE_SSH termux-share -a send ./tmp/*"
        ;;
    mount)
        sshfs -p 8022 -o IdentityFile=$PHONE_KEY $PHONE_IP:$2 $3
        ;;
    scan)
        MACtoIP "Manually"
        ;;
    sms)
        termux run su -c cp /data/data/com.textra/databases/messaging.db /sdcard/tmp/sms.db
        termux pull  /sdcard/tmp/sms.db /tmp/ >/dev/null
        sqlite3 -line /tmp/sms.db 'select text from messages order by _id desc limit 1' |
        awk -F " = " '{print $2}'
        ;;
    *)
        echo "Mini Termux Controller - github/Kebablord

scan                *  scan for phone's ip,useful if you encounter a problem 
run <param>         -  run ssh command or connect ssh terminal if no arg passed
cp-set <string>     -  copies the string to phone's clipboard
cp-get              -  return the string from phone's clipboard
sms                 -  display latest sms (useful for verification codes)
pull  <src> <dest>  -  pull the file from phone src to dest
push  <src> <dest>  -  push the file to phone dest from local src
share <src>         -  Android's share menu prompts for specific string or file
mount <src> <dest>  -  use SSHFS to mount specific android folder to linux folder
"
    ;;
esac
