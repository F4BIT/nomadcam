#!/bin/bash
clear
whiptail --title "INFORMATION:" --msgbox "Ce script considere que vous partez d une image vierge de Gnu/Linux Debian.                                   Il permet d'installer un système vidéo IrisCam Complet.                                                        Plus d informations sur http://stephane.mangeolle.fr " --yesno "Lancer l'installation ?" 11 60


# Installation de prérequis perso
rm -R /root/nomadcam
{ for i in $(seq 1 100)
do
echo $i
apt-get install -y --show-progress mc git wget gnupg* apt-transport-https gdebi
done } | whiptail --title 'Installation des pré-requis' --gauge 'Running...' 6 60 0

# Clonage du GitHub
{ for i in $(seq 1 100)
do
echo $i
git clone  https://github.com/F4BIT/nomadcam.git  /root/nomadcam
done } | whiptail --title 'Clonage du répértoire GitHub' --gauge 'Running...' 6 60 0


# Modification du source list
#echo "Modification du source.list et ajout de clefs"
rm /etc/apt/sources.list
mv /root/nomadcam/sources.list /etc/apt/sources.list
apt-key add /root/nomadcam/jcameron-key.asc
#wait 10
#clear

# Mise à jour du système
{ 
	sleep 0.5
	echo -e "XXX\n0\apt-get -y update \nXXX"
	sleep 2
	echo -e "XXX\n33\apt-get -y update...Done\nXXX"
	sleep 0.5
	echo -e "XXX\n33\apt-get -y dist-upgrade \nXXX"
	sleep 2
	echo -e "XXX\n66\apt-get -y dist-upgrade...Done\nXXX"
	sleep 0.5
	echo -e "XXX\n66\apt-get -y upgrade \nXXX"
	sleep 2
	echo -e "XXX\n100\apt-get -y upgrade...Done\nXXX"
	sleep 1
} | whiptail --title 'Upgrade complet du système !' --gauge 'Running...' 6 60 0


# Installation de webmin
{ for i in $(seq 1 100)
do
echo $i
apt-get install -y webmin
done } | whiptail --title 'Installation de l administration via webmin' --gauge 'Running...' 6 60 0
rm /etc/webmin/config
mv /root/nomadcam/webmin/config /etc/webmin/config

# Installation du serveur web génétal
{ for i in $(seq 1 100)
do
echo $i
apt-get install -y lighttpd 
apt-get install -y php7.3-fpm php-cgi 
lighttpd-enable-mod fastcgi-php
done } | whiptail --title 'Installation du serveur web général' --gauge 'Running...' 6 60 0

service lighttpd force-reload
rm -R /var/www/html
mv /root/nomadcam/html /var/www/html

# Téléchargement du logiciel de vidéo surveillance
URL="https://www.seek-one.fr/downloads/seekone-server-3.2.10-debian~buster_amd64.deb"
wget --progress=dot "$URL" 2>&1 | grep "%" | sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g"  | dialog --title 'Téléchargement SeekOne-Server' --gauge "Running..." 6 60
mv seekone-server*.deb /root/nomadcam/seekone-server.deb

# Installation du logiciel de vidéo surveillance
{ for i in $(req 1 100)
do
echo $i
gdebi --n seekone-server.deb
done } | whiptail --titel 'InstallationSeekOne Server' --gauge 'Running...' 6 60 0


whiptail --title "Fin de l'installation" --msgbox "Merci de l'installation, bon ammusement" 11 60
