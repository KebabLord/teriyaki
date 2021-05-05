# Mini Termux SSH Controller Script
![preview](https://u.teknik.io/CMMqD.gif)

```
λ ./teriyaki
Mini Termux Controller - Github/Kebablord
scan                *  scan network to update phone's current IP adress
run <param>         -  run ssh commands or connect ssh terminal if no arg passed
cp-set <string>     -  copy the string to phone clipboard
cp-get              -  return the string from phone clipboard
sms                 -  display latest sms, useful for verification codes (root)
pull  <src> <dest>  -  pull the file from phone to computer
push  <src> <dest>  -  push the file to phone from computer
share <src>         -  share the media from computer to phone apps like whatsapp, telegram
mount <src> <dest>  -  use SSHFS to mount specific phone folder to linux folder
```

## Dependencies
Dependencies without asterisk are optional for their regarded options.

#### PC side
- **arp-scan***  - for scanning phone's IP adress from it's MAC
- **ssh***  - core of whole script
- **sshfs**  - for mounting folder option

#### Termux side
- `openssh*`
- `termux-api*`

# How to use / Configure the script
Please check [wiki page](https://github.com/KebabLord/teriyaki/wiki/Configuring-the-script)
