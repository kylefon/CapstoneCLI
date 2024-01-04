#!/bin/bash

#Setup the installation directory
install_dir="/usr/local/bin"

#Define name of project
script="clouduploader.sh"

#Check if script already exists

if [ ! -f "$install_dir/$script" ]; then
    echo "The script has already been uploaded"
    exit 1
fi

#Copy script to the directory
cp $script $install_dir

#Provide executable permissions
chmod +x "$install_dir/$script"

echo "Installation complete, the script is now available in $install_dir"