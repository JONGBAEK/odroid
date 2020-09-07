#ARM
#wget --content-disposition "https://plex.tv/downloads/latest/5?channel=1&build=linux-aarch64&distro=debian"
#sudo dpkg -i plexmediaserver_*_arm64.deb
#rm plexmediaserver_*_arm64.deb
#LINUX64BIT
wget --content-disposition "https://plex.tv/downloads/latest/5?channel=1&build=linux-x86_64&distro=debian"
sudo dpkg -i plexmediaserver_*_amd64.deb
rm plexmediaserver_*_amd64.deb

