#!/bin/bash

######################################################################
# Gainsight PX Data Loader install script for Mac OSX
# Installs python dependencies (not python itself) and 
# makes the script executable
######################################################################

echo "Installing Gainsight PX Data Loader"
echo ""
echo "Checking for python3"
which python3 > /dev/null
if [[ $? != 0 ]]
then
  echo "ERROR: Install python3 prior to running this install"
  exit 1
fi

# Install pip3 if missing
echo "Checking for pip3"
which pip3 > /dev/null 2>&1
if [[ $? != 0 ]]
then
  echo "Installing pip3..."
  curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
  sudo python3 /tmp/get-pip.py
  rm /tmp/get-pip.py
fi

# Install requests library if missing
echo "Checking for requests module"
python3 -c 'import requests' > /dev/null 2>&1
if [[ $? != 0 ]]
then
  echo "Installing requests library..."
  sudo pip3 --quiet --quiet install requests
fi

# Install pytz library if missing
echo "Checking for pytz module"
python3 -c 'import pytz' > /dev/null 2>&1
if [[ $? != 0 ]]
then
  echo "Installing pytz library..."
  sudo pip3 --quiet --quiet install pytz
fi

# Install dateutil library if missing
echo "Checking for dateutil module"
python3 -c 'import dateutil' > /dev/null 2>&1
if [[ $? != 0 ]]
then
  echo "Installing dateutil library..."
  sudo pip3 --quiet --quiet install python-dateutil
fi

# Make executable
echo "Making script executable"
chmod u+x ./gainsight-px-data-loader

echo "Install Done"
