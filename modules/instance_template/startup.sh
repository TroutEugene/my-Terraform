#! /bin/bash
sudo apt-get update
sudo apt install -y apache2 libapache2-mod-php php php-mysql
sudo apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip

export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo rm /var/www/html/index.html
sudo apt-get update
sudo apt-get install -y gcsfuse

sudo gcsfuse --implicit-dirs -o allow_other wp-front /var/www/

sudo systemctl restart apache2