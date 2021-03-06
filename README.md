# Pi Config
Ce repo est une boué de sauvetage pour mon rasp.

Script pour installer :
```
curl -o- https://raw.githubusercontent.com/nesmon/pi_config/master/install.sh | bash
```

## 1. Update :
Faite un coup de `sudo raspi-config` pour modifier certain point du raspberry (expend filesystem, password ...)

## 2. Changer le nom de son rasp (a executer en sudo) :
Editer le fichier `/etc/hosts` et remplacer raspberrypi par le nom que vous voulais a la dernier ligne
Puis éditer le fichier `/etc/hostname` et remplacer raspberrypi par le meme nom donnez précédement

## 3. Installer php 7.1
PHP7.1 n'est pas dispo dans le depot stretch de raspbian, il faut donc utiliser le repo buster de raspbian (ce dépot s'install via le setup.sh du repo):
```
sudo echo “deb http://mirrordirector.raspbian.org/raspbian/ buster main contrib non-free rpi” > /etc/apt/sources.list.d/php.list
sudo apt-get update
```
Attention ne pas faire de `sudo apt-get dist-upgrade` pour eviter de casser son OS(reinstalation obligatoire dans se cas).

Ensuite installer php + nginx + mysql (avec les packages utile pour php) en fesant :
```
sudo apt-get install php7.1 php7.1-fpm nginx mysql-client mysql-server php7.1-mysql php7.1-dev php-xdebug  
```

Pour terminer relancer PHP et nginx pour que tout fonctionne sans probleme :
```
sudo service nginx restart
sudo service php7.1-fpm restart
```

Lance ton navigateur et tappe dans la bar d'url :
localhost:80

## 4. Config fish
Installer le theme cbjohnson avefc la commande suivante :
```omf install cbjohnson```
Dans fish

### 4.1 Utiliser nvm avec fish
De base nvm n'est pas utilisable avec fish il faut installer un package pour l'utiliser avec celui-ci :
```omf install nvm```
Evidément nvm doit etre préalablement installer.

## 5. Pour la seedbox : 
Tout d'abord desactiver transmision comme ceci :
```
sudo /etc/init.d/transmission-daemon stop
```

Editer les ligne suivante dans le fichier `/etc/transmission-daemon/settings.json` :
- "download-dir"
- rpc-authentication-required : a mettre sur true ou false (permet de se conecter a la seedbox via des code)
- "rpc-username": "transmission",
- "rpc-password": "{356c072a1bc5d97132bbe6ccd26854798b801dcf8kL7gaRF",

Ouis faire `sudo /etc/init.d/transmission-daemon start` pour redemarer la seedbox.

## 6. Pour samba :
### 6.1 Config de samba :
sudo nano /etc/samba/smb.conf
Chercher :
```
##### Authentification #####
```
Et add en dessous :
```
security = user
```
Puis chercher : 
```
[homes]
```
Verifier si read only = no

Pour finir allez tout en bas du fichier est ajouter ceci : 
```
[public]
  comment= Public Storage
  path = /home/shares/public
  valid users = @users
  force group = users
  create mask = 0660
  directory mask = 0771
  read only = no
```

Puis restart samba avec : 
```
sudo /etc/init.d/samba restart
```
### 6.2 Config des user :
Faire : 
```
sudo smbpasswd -a pi
```
pour choisir un password a l'utilisateur pi sur samba.


### 6.3 Ajout d'un disk externe :
Faire `dmseg` ou `lsblk` pour connaitre le nom de son périphérique (sda, sdb ...)
Ici on prendra sda1 comme exemple.

Ensuite on le unmount et on le formate en ext4 :
```
umount /dev/sda1
sudo mkfs.ext4 /dev/sda1
```

On créer ensuite un fichier ou on vas mount le disk :
```
sudo mkdir /home/shares/public/disk1
sudo chown -R root:users /home/shares/public/disk1
sudo chmod -R ug=rwx,o=rx /home/shares/public/disk
```

Puis on le mount dans se dossier :
```
sudo mount /dev/sda1 /home/shares/public/disk1
```

### 6.4 Monter le périphérique au démarage :
Si le rasp reboot il est préférable de monter automatiquement le disk pour eviter de le faire a chaque démarage, pour cela faite `sudo nano /etc/fstab`, puis ajouter a la fin du fichier cette ligne : 
```
/dev/sda1 /home/shares/public/disk1 auto noatime,nofail 0 0
```
Elle vas permetre de mount le disk automatiquement et d'evirter de faier des erreur si le disk n'est pas brancher au démarage.

## 7. Pi-Hole config :
Allez dans Setting > Block Lists et ajouter les liens suivant : 
```
https://raw.githubusercontent.com/0XE4/Pi-Holed/master/windows_spy_hosts
https://raw.githubusercontent.com/0XE4/Pi-Holed/master/ip_logging_domains
https://raw.githubusercontent.com/0XE4/Pi-Holed/master/easy_privacy_easy_list
https://raw.githubusercontent.com/0XE4/Pi-Holed/master/ublock_filters_plus
https://raw.githubusercontent.com/0XE4/Pi-Holed/master/fanboys_annoyance
https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
https://mirror1.malwaredomains.com/files/justdomains
http://sysctl.org/cameleon/hosts
https://zeustracker.abuse.ch/blocklist.php?download=domainblocklist
https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt
https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt
https://hosts-file.net/ad_servers.txt
```

Redémarer le RPi pour que tout soit pris en compte.

## 8. Ajout du server VNC
De base le server vnc de raspbian doit être activer, mais moi de on coter il ne veux pas trop fonctionner.
Donc pour régler le probléme je lance un autre server vnc mais cette fois-ci avec x11vnc.

Pour commencer on vas installer x11vnc :
```
sudo apt-get install x11vnc
```
Pour terminer on doit juste crée le dossier `autostart` dans le `.config` (si il n'est pas dèja crée) :
```
mkdir /home/pi/.config/autostart
```
Puis on crée un fichier vnc.desktop qui se lancera automatiquement :
```
nano /home/pi/.config/autostart/vnc.desktop
```

Puis coller ceci :
```
[Desktop Entry]
Type=Application
Exec=x11vnc --forever
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enable=true
```

Redémarer votre RPi pour que le server soit opérationnel.





 





