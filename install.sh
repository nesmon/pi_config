echo "Update raspberry : "
sudo apt update
sudo apt upgrade

echo "Install necesary pachage : "
sudo apt-get install git curl wget make automake autoconf fish
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
curl -L https://get.oh-my.fish | fish

echo "Install vnc server : "
sudo apt-get install x11vnc
mkdir /home/$USER/.config/autostart
echo "
[Desktop Entry]
Type=Application
Exec=x11vnc --forever
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enable=true
" >> /home/$USER/.config/autostart/vnc.desktop

echo "Install Web Server with Nginx : "
sudo echo “deb http://mirrordirector.raspbian.org/raspbian/ buster main contrib non-free rpi” > /etc/apt/sources.list.d/php.list
sudo apt-get update
sudo apt-get install php7.1 php7.1-fpm nginx mysql-client mysql-server php7.1-mysql php7.1-dev php-xdebug  
sudo service nginx restart
sudo service php7.1-fpm restart

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

