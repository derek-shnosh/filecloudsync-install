#!/bin/bash
# Author: DS, Synergy Information Solutions, Inc.

# Variables
libpng12="libpng12-0_1.2.54-1ubuntu1.1_amd64.deb"
clientzip="filecloudsync_linux_amd64.zip"

# Download the latest sync client from FileCloud servers
mkdir -p $HOME/Downloads
echo -e "Downloading latest Filecloud sync client to '$HOME/Downloads/'"
wget -q http://patch.codelathe.com/tonido/live/installer/x86-linux/$clientzip -O $HOME/Downloads/$clientzip

# Download libpng12
echo -e "Downloading prequisite (security.ubuntu.com>libpng12) to '$HOME/Downloads/$libpng12'"
wget -q http://security.ubuntu.com/ubuntu/pool/main/libp/libpng/$libpng12 -O $HOME/Downloads/$libpng12

# Install libpng12, libdbusmenu-gtk-dev
echo -e "Installing prerequisites: libdbusmenu-gtk-dev, libpng12"
sudo apt install libdbusmenu-gtk-dev $HOME/Downloads/$libpng12 -y
echo -e "Prerequisite installation complete...\n\n"

# Create $HOME/Apps/filecloudsync & unzip client to new directory
mkdir -p $HOME/Apps/filecloudsync
echo -e "Unzipping Filecloud sync client to '$HOME/Apps/filecloudsync/'"
unzip -qq $HOME/Downloads/$clientzip -d ~/Apps/filecloudsync

# Copy the .png file (icon) to the new directory
echo -e "Copying icon to '$HOME/Apps/filecloudsync/'"
cp ./filecloudsyncicon.png $HOME/Apps/filecloudsync/

# Make filecloudsync and filecloudsyncstart.sh executable
echo -e "Making files executable: ($HOME/Apps/filecloudsync/) filecloudsync, filecloudsyncstart.sh"
chmod +x $HOME/Apps/filecloudsync/filecloudsyncstart.sh && chmod +x $HOME/Apps/filecloudsync/filecloudsync

# Create $HOME/.local/share/applications/filecloudsync.desktop file (app menu launcher)
echo -e "Creating desktop entry file (app menu) '$HOME/.local/share/applications/filecloudsync.desktop'"
mkdir -p $HOME/.local/share/applications
cat > $HOME/.local/share/applications/filecloudsync.desktop <<EOF
[Desktop Entry]
Type=Application
Version=1.0
Name=FileCloud Sync
GenericName=File Synchronization
Comment=FileCloud sync client
Categories=Network;System;
Keywords=sync;
Terminal=false
NoDisplay=false
StartupNotify=false
Path=$HOME/Apps/filecloudsync/
Exec=$HOME/Apps/filecloudsync/filecloudsyncstart.sh
Icon=$HOME/Apps/filecloudsync/filecloudsyncicon.png

EOF

echo -e "Installation complete, launch 'FileCloud Sync' from app menu."