echo "=========================================================================================="
echo "Guide : https://www.htpcguides.com/install-plex-media-server-on-odroid-lubuntu-and-debian/"
echo "=========================================================================================="

if [ $# -eq 0 ] ; then
    echo "error : Download version required"
    echo "----------------------------------------------"
    echo "1. https://www.plex.tv/media-server-downloads/"
    echo "2. Select Synology"
    echo "3. Copy version (ex. 1.16.6.1592-b9d49bdb7)"
    echo "----------------------------------------------"
    echo "usage : plexmaker.sh 1.16.6.1592-b9d49bdb7"
    echo ""
    exit 0
fi

echo "making work directory ..."
mkdir work
echo "copy skeleton files to work directory ..."
cp -r packages/skeleton work/
cd work
echo "download plex binary ..."
wget "https://downloads.plex.tv/plex-media-server-new/$1/synology/PlexMediaServer-$1-aarch64.spk"
echo "unzip download binary ..."
for f in *.spk; do mv -- "$f" "${f%.spk}.tgz"; done
tar xvf *.tgz
tar -xvf package.tgz -C skeleton/usr/lib/plexmediaserver
echo "remove old config ..."
rm -r skeleton/usr/lib/plexmediaserver/dsm_config
echo "change permission ..."
cd skeleton/usr/lib/plexmediaserver
find . -iname "*.so" -exec chmod 644 {} \;
find . -iname "*.so.*" -exec chmod 644 {} \;
cd -
echo "need to change version ...."
#vi skeleton/DEBIAN/control
sed -e s/1.15.4.993-bb4a2cb6c/$1/g skeleton/DEBIAN/control > skeleton/DEBIAN/control.tmp
mv skeleton/DEBIAN/control.tmp skeleton/DEBIAN/control
echo "making install pakage ..."
fakeroot dpkg-deb --build skeleton ./
sudo dpkg -i plexmediaserver*
mv plexmediaserver_* ../deb/
cd ..
echo "removing work directory ..."
rm work -rf
echo "Done"
