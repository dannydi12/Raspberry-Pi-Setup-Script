#!/bin/bash

printf "\n\nTool to configure headless raspberrypi.\n\nDeveloped by Daniel DiVenere\n\n============================="

printf "\n\nMake sure you use sudo with this script!"

printf "\n\nSet a new password for this user:\n\n"
passwd pi


read -p "Do you want to add another network to your wpa_supplicant configuration (y / n)? " answer

if [[ $answer = "y" ]]
then
	read -p "SSID: " ssid;
	read -p "Pass: " pass;
	wpa="
network={
 scan_ssid=1
 ssid= $ssid
 psk= $pass
}"
	sudo echo "$wpa">> "/etc/wpa_supplicant/wpa_supplicant.conf"
	#sudo cat <<< "$wpa" >>  "/etc/wpa_supplicant/wpa_supplicant.conf"
fi

read -p "Do you want a static IP? (y / n)? " answer

if [[ $answer = "y" ]]
then
        read -p "Interface: " interface
        read -p "IP: " ip
	read -p "Router: " router
	read -p "Domain Name Server (usually the same as router): " dns
        static="
interface $interface
static ip_address=$ip
static routers=$router
static domain_name_servers=$dns
"
        sudo echo "$static">> "/etc/dhcpcd.conf"
	printf "\n\nRefer to /etc/dhcpcd.conf to change static IP again.\n\n"
fi

read -p "Would you like to check for updates (y / n)? " answer
if [[ $answer = "y" ]]
then
        sudo apt-get update
        sudo apt-get upgrade
fi


read -p "Do you want to install Teamviewer (y / n)? Warning: This only works with a newer generation pi (Raspberry Pi 2/3 and not Raspberry Pi Zero/Zero W. " answer

if [[ $answer = "y" ]]
then
	wget https://download.teamviewer.com/download/linux/teamviewer-host_armhf.deb
	sudo dpkg -i teamviewer-host_armhf.deb
	sudo apt --fix-broken install
	read -p  "Set a Teamviewer password: " pass
	sudo teamviewer passwd "$pass"
	printf "\nRestarting Teamviewer"
	sudo service teamviewerd restart
	sudo teamviewer --daemon restart
	printf "\n Teamviewer information (save the ID):"
	teamviewer info
	printf "\n\n=============================="
fi

printf "\n\nEnable SSH to access remotely on next boot...\n\n"
sleep 5
sudo raspi-config

read -p "You should probably reboot to enact all these changes. Will you let me initiate a reboot (y / n)? " answer

if [[ $answer = "y" ]]
then
        sudo reboot
fi

printf "\nGoodbye!\n\n"
