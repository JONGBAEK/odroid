echo "=========================================================================================="
echo "References : "
echo "https://wiki.odroid.com/odroid-xu4/software/ubuntu_nas/03_nas_services?s[]=plexmediaserver"
echo "https://www.htpcguides.com/install-plex-media-server-on-odroid-lubuntu-and-debian/"
echo "=========================================================================================="

if [ $# -eq 0 ] ; then
    echo "Error : Download version required"
    echo "----------------------------------------------"
    echo "1. https://www.plex.tv/media-server-downloads/"
    echo "2. Select Synology"
    echo "3. Copy version (ex. 1.18.1.1973-0f4abfbcc)"
    echo "----------------------------------------------"
    echo "Usage : ./plexmaker.sh 1.18.1.1973-0f4abfbcc"
    echo ""
    exit 0
fi

echo "Making work directory ..."
mkdir work
echo "Copy skeleton files to work directory ..."
cp -r packages/skeleton work/
cd work
echo "Download plex binary ..."
wget "https://downloads.plex.tv/plex-media-server-new/$1/synology/PlexMediaServer-$1-aarch64.spk"
echo "Unzip download binary ..."
for f in *.spk; do mv -- "$f" "${f%.spk}.tgz"; done
tar xvf *.tgz
tar -xvf package.tgz -C skeleton/usr/lib/plexmediaserver
echo "Remove old config ..."
rm -r skeleton/usr/lib/plexmediaserver/dsm_config
echo "Change permission ..."
cd skeleton/usr/lib/plexmediaserver
find . -iname "*.so" -exec chmod 644 {} \;
find . -iname "*.so.*" -exec chmod 644 {} \;
cd -
echo "Need to change version ...."
#vi skeleton/DEBIAN/control
sed -e s/1.15.4.993-bb4a2cb6c/$1/g skeleton/DEBIAN/control > skeleton/DEBIAN/control.tmp
mv skeleton/DEBIAN/control.tmp skeleton/DEBIAN/control
echo "Making deb pakage ..."
fakeroot dpkg-deb --build skeleton ./
echo "Installing PlexMediaServer ..."
sudo dpkg -i plexmediaserver*
echo "Move deb file to deb folder"
if [ ! -d "../deb" ]; then
	mkdir ../deb
fi
mv plexmediaserver_* ../deb/
cd ..
echo "Removing work directory ..."
rm work -rf
echo "Done"
