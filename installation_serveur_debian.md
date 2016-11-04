Installation serveur Debian

## Dans le fichier .bashrc de l’utilisateur retirer le commentaire devant la ligne : force_color_prompt=yes

## Pour les caractères accentués dans le terminal
Editer le fichier sudo vi /etc/environment
echo "LANG=fr_FR.UTF-8" | sudo tee -a /etc/environment > /dev/nul
echo 'LANGUAGE="fr_FR.UTF-8"' | sudo tee -a /etc/environment > /dev/nul
echo "LC_ALL=fr_FR.UTF-8" | sudo tee -a /etc/environment > /dev/nul

dans dpkg-reconfigure locales s’assurer qu’il y a seulement FR_fr_UTF8 de sélectionné.

Après reboot la commande locale doit retourner :
LANG=fr_FR.UTF-8
LANGUAGE=fr_FR.UTF-8
LC_CTYPE="fr_FR.UTF-8"
LC_NUMERIC="fr_FR.UTF-8"
LC_TIME="fr_FR.UTF-8"
LC_COLLATE="fr_FR.UTF-8"
LC_MONETARY="fr_FR.UTF-8"
LC_MESSAGES="fr_FR.UTF-8"
LC_PAPER="fr_FR.UTF-8"
LC_NAME="fr_FR.UTF-8"
LC_ADDRESS="fr_FR.UTF-8"
LC_TELEPHONE="fr_FR.UTF-8"
LC_MEASUREMENT="fr_FR.UTF-8"
LC_IDENTIFICATION="fr_FR.UTF-8"
LC_ALL=fr_FR.UTF-8

## Installation de nouvelles commandes.
apt-get install -y sudo apt-show-versions build-essential ufw vim git libpcre3-dev libpcre3 libpcrecpp0 libssl-dev zlib1g-dev unattended-upgrades

## configuration de unattended
echo 'APT::Periodic::Update-Package-Lists "1";' | sudo  tee -a  /etc/apt/apt.conf.d/20auto-upgrades > /dev/null
echo 'APT::Periodic::Unattended-Upgrade "1";' | sudo  tee -a  /etc/apt/apt.conf.d/20auto-upgrades > /dev/null

## Sécurisation avec le firewall UFW
## https://www.digitalocean.com/community/tutorials/how-to-setup-a-firewall-with-ufw-on-an-ubuntu-and-debian-cloud-server
sudo service ufw start
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
## ou sudo ufw allow 22/tcp


# Téléchargement de la version MainLine
# https://www.nginx.com/resources/wiki/start/topics/tutorials/install/#source-releases
wget http://nginx.org/download/nginx-1.11.3.tar.gz
# Décompression
tar -zxvf nginx-1.11.3.tar.gz

# Pour la compilation :
sudo ./configure --sbin-path=/usr/bin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --with-debug --with-pcre --with-http_ssl_module --with-http_v2_module --without-http_geo_module
sudo make
sudo make install

# Création des dossiers manquants
sudo mkdir /etc/nginx/sites-available
sudo mkdir /etc/nginx/sites-enabled
sudo mkdir /etc/nginx/conf.d

# Script de démarrage automatique :
sudo cd /etc/init.d
sudo vi nginx
coller le script http://kbeezie.com/debian-ubuntu-nginx-init-script/  (changer le chemin dans la variable DAEMON au début du script (mettre /usr/bin/nginx))

sudo chmod +x ./nginx
sudo update-rc.d -f nginx defaults

# Créer un fichier /etc/default/nginx (A voir si cela est obligatoire)
NGINX_CONF_FILE=/etc/nginx/nginx.conf
DAEMON=/usr/bin/nginx


## Installation de PERCONA MYSQL 5.7
wget https://repo.percona.com/apt/percona-release_0.1-4.$(lsb_release -sc)_all.deb
sudo dpkg -i percona-release_0.1-4.$(lsb_release -sc)_all.deb
sudo apt-get update
sudo apt-get install percona-server-server-5.7

## Dans /etc/mysql/my.cnf, retirer les commentaires pour activer les logs des requêtes lentes.
## Renommer le compte root
UPDATE mysql.user set user = 'frdbecc' where user = 'root';
flush privileges;
mysql -u root -p -e "UPDATE mysql.user set user = 'frdbecc' where user = 'root'"
mysql -u root -p -e "flush privileges"

## Installation de PHP7
## Rajouter le repository
echo "deb http://packages.dotdeb.org jessie all" | sudo tee -a /etc/apt/sources.list.d/dotdeb.list > /dev/null
echo "deb-src http://packages.dotdeb.org jessie all" | sudo tee -a /etc/apt/sources.list.d/dotdeb.list > /dev/null
wget https://www.dotdeb.org/dotdeb.gpg
sudo apt-key add dotdeb.gpg
## Lancer l'installation
sudo apt-get update
sudo apt-get install -y php7.0-gd php7.0-mysql php7.0-bz2 php7.0-json php7.0-curl php7.0-cli php7.0-mbstring php7.0-mcrypt php7.0-odbc php7.0-opcache php7.0-fpm
## Activer PHP7 et cacher le n° de version
sudo sed -i -e 's/[;]cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' '/etc/php/7.0/fpm/php.ini'
sudo sed -i -e 's/\(.*expose_php =\).*$/\1 Off/' '/etc/php/7.0/fpm/php.ini'


