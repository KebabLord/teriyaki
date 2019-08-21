# Mini Termux SSH Controller Script
To execute the script you should use `source <script>` command in order to store variables on that terminal session
You can also add an alias to `.bash_aliases` as `alias termux="source PATH_TO_SCRIPT.sh"`

```
λ termux --help
Mini Termux Controller - github/Kebablord
scan		    *  scan's ports to find phone's ip adress
cp-set <string>     -  copies the string to phone's clipboard
cp-get              -  return the string from phone's clipboard
pull  <src> <dest>  -  pull the file from phone src to dest
push  <src> <dest>  -  push the file to phone dest from local src
share <src>         -  Android's share menu prompts for specific string or file
mount <src> <dest>  -  use SSHFS to mount specific android folder to linux folder
```
