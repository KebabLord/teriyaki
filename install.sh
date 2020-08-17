echo "Installing dependencies..."
sudo apt update > /dev/null
sudo apt install arp-scan > /dev/null

echo "Creating symbolic link..."
sudo ln -s $PWD/termux-mini.sh /usr/local/bin/termux > /dev/null

echo "Termux script installed! Type 'termux --help' for more details"
