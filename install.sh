echo "Update raspberry : "
sudo apt update
sudo apt upgrade

echo "Install necesary pachage : "
sudo apt-get install git curl wget make automake autoconf fish
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
curl -L https://get.oh-my.fish | fish

echo "Install nas with samba : "
sudo mkdir /home/shares
sudo mkdir /home/shares/public
sudo chown -R root:users /home/shares/public
sudo chmod -R ug=rwx,o=rx /home/shares/public
sudo apt install samba samba-common-bin

echo "Install seedbox : "
sudo apt install transmission-daemon

echo "Install pi-hole : "
curl -sSL https://install.pi-hole.net | bash

echo "Install Raspberry cast (for cast video to the rasp) : "
wget https://raw.githubusercontent.com/vincelwt/RaspberryCast/master/setup.sh && sudo sh setup.sh

