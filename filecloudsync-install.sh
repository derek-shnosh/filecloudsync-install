#!/bin/bash
# Author: DS, shnosh.io

# Variables
libpng12="libpng12-0_1.2.54-1ubuntu1.1_amd64.deb"
clientzip="filecloudsync_linux_amd64.zip"
thearg="$1"
valid="install|uninstall"
installdir=$HOME/apps/filecloudsync

if [ $# -eq 0 ]; then
    echo -e "Please provide an argument, use 'install' or 'uninstall'."
    exit 1
elif [[ ! ${thearg} =~ ${valid} ]]; then
    echo -e "$thearg: Invalid argument, use 'install' or 'uninstall'."
    exit 1
elif [ $thearg = "install" ]; then
    # Create $HOME/apps/filecloudsync for file storage.
    echo -e "Creating installation directory: $installdir"
    mkdir -p $HOME/apps/filecloudsync

    # Create .tmp folder
    echo -e "Creating './tmp' folder for file storage."
    mkdir tmp && cd tmp

    # Download the latest sync client from FileCloud servers
    echo -e "Downloading latest Filecloud sync client zip to './tmp'."
    wget -q http://patch.codelathe.com/tonido/live/installer/x86-linux/$clientzip

    # Download libpng12
    echo -e "Downloading prequisite (security.ubuntu.com>libpng12) to './tmp'."
    wget -q http://security.ubuntu.com/ubuntu/pool/main/libp/libpng/$libpng12

    # Install prerequisites: libpng12, libdbusmenu-gtk-dev
    echo -e "Extracting required libpng12 libraries to '$installdir'."
    ar x libpng12-0_1.2.54-1ubuntu1.1_amd64.deb
    tar -xf data.tar.xz --wildcards ./lib/x86_64-linux-gnu/libpng12.so.0* -C . --strip-components 3
    mv libpng12.so.0* $installdir

    echo -e "Installing libdbusmenu-gtk-dev, requires sudo..."
    sudo apt install libdbusmenu-gtk-dev
    echo -e "Prerequisite installation complete..."

    # Unzip client to created directory.
    echo -e "Unzipping Filecloud sync client to '$installdir/'."
    unzip -qq $clientzip -d $installdir

    # Copy the .png file (icon) to the new directory
    echo -e "Copying icon to '$installdir/'."
    cp ../filecloudsyncicon.png $installdir/

    # Make filecloudsync and filecloudsyncstart.sh executable
    echo -e "Making files executable ($installdir/): filecloudsync, filecloudsyncstart.sh"
    chmod +x $installdir/filecloudsyncstart.sh && chmod +x $installdir/filecloudsync

    # Create $HOME/.local/share/applications/filecloudsync.desktop file (app menu launcher)
    echo -e "Creating desktop entry file (app menu) '$HOME/.local/share/applications/filecloudsync.desktop'."
    mkdir -p $HOME/.local/share/applications
    echo -e "[Desktop Entry]\nType=Application\nVersion=1.0\nName=FileCloud Sync\nGenericName=File Synchronization\nComment=FileCloud sync client\nCategories=Network;System;\nKeywords=sync;\nTerminal=false\nNoDisplay=false\nStartupNotify=false\nPath=$installdir/\nExec=$installdir/filecloudsyncstart.sh\nIcon=$installdir/filecloudsyncicon.png" | tee $HOME/.local/share/applications/filecloudsync.desktop &> /dev/null

    # Create link for shared libraries (included in .zip),
    echo -e "Adding '$installdir' to shared libraries directory, requires sudo..."
    echo -e "# Filecloud shared libraries\n$installdir" | sudo tee /etc/ld.so.conf.d/filecloud.conf &> /dev/null && sudo ldconfig

    # Remove .tmp folder
    cd .. && rm -rf tmp

    echo -e "\nInstallation complete, launch 'FileCloud Sync' from app menu.\n"
elif [ $thearg = "uninstall" ]; then
    echo -e "Removing [d]irectories and [f]iles:\n[d] $installdir\n[d] $HOME/FileCloudSyncData\n[f] $HOME/syncclientconfig.xml\n[f] $HOME/.local/share/applications/filecloudsync.desktop\n[f] /etc/ld.so.conf.d/filecloud.conf"
    rm -rf $installdir $HOME/FileCloudSyncData $HOME/syncclientconfig.xml $HOME/.local/share/applications/filecloudsync.desktop

    echo -e "Removing '$installdir' from shared libraries directory, requires sudo..."
    sudo rm -f /etc/ld.so.conf.d/filecloud.conf && sudo ldconfig

    echo -e "\nFileCloud Sync Client has been uninstalled, synced files have *not* been deleted.\n"
fi