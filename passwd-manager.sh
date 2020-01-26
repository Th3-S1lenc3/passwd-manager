#!/bin/bash
# Written by Th3_S1lenc3

# Checks if .install_dir exists
if [ ! -f .install_dir ]; then
  echo "Please run setup.sh first"
  exit
else
  INSTALL_DIR=$(cat .install_dir)
fi
SETUP_DONE=$INSTALL_DIR/passwords/.setup_done

# Checks if .setup_done exits and if not create it then echo 0 into it
if [ ! -f $SETUP_DONE || $(cat $SETUP_DONE) = "0" ]; then
	echo "0" > $SETUP_DONE
  echo "Please run setup.sh first"
  exit
fi

function menubanner() {
  echo "passwd-manager. Version 0.1"
  echo "Generate Secure Passwords"
}

function menu() {
  menubanner
  echo "
  1. Generate New Password
  2. Decrypt Password
  3. Exit"
}

TIME=$(date +"%H")
if [ TIME > 12]; then
  NOW="night"
fi
NOW="day"

$CHOICE = "3"

while true; do
  menu
  read -rp "Enter choice: " -e -i "$CHOICE" CHOICE

  case $CHOICE in
    "1") ./getpasswd.sh;;
    "2") ./decryptpasswd;;
    "3") echo "Have a good $NOW." && exit;;
  esac
done
