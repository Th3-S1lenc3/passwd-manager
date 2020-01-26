#!/bin/bash
# Written by Th3_S1lenc3

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ "$DIR" != "/$HOME/passwd-manager" ]]; then
  if [[ -d $HOME/passwd-manager ]]; then
    rm -r $HOME/passwd-manager
  fi

  mkdir $HOME/passwd-manager
  cp -r  "$DIR"/* /$HOME/passwd-manager
  chmod +x /$HOME/passwd-manager/setup.sh
  gnome-terminal -- "bash /$HOME/passwd-manager/install.sh"
fi

# Check OS version
if [[ -e /etc/debian_version ]]; then
    source /etc/os-release
    OS=$ID # debian or ubuntu
elif [[ -e /etc/fedora-release ]]; then
    OS=fedora
elif [[ -e /etc/centos-release ]]; then
    OS=centos
elif [[ -e /etc/arch-release ]]; then
    OS=arch
else
    echo "Looks like you aren't running this installer on a Debian, Ubuntu, Fedora, CentOS or Arch Linux system"
    exit 1
fi

# Install Dependencies
echo -e "Installing Dependencies..."
if [[ "$OS" = 'ubuntu' ]]; then
  apt-get update
  apt-get install secure-delete openssl
elif [[ "$OS" = 'debian' ]]; then
  apt update
  apt install secure-delete openssl
elif [[ "$OS" = 'fedora' ]]; then
  dnf upgrade
  dnf install secure-delete openssl
elif [[ "$OS" = 'centos' ]]; then
  yum update
  yum install secure-delete openssl
elif [[ "$OS" = 'arch' ]]; then
  pacman -Syy && pacman -Su
  pacman -S openssl
  yay -S secure-delete
fi

# Add execute permissions to all necessary files
echo -e "Installing passwd-manager..."
sleep 1
echo -e "Fixing permissions"
sleep 2
chmod +x passwords.sh
chmod +x getpasswd.sh
chmod +x decryptpasswd.sh

# Copy to /bin
echo -e "Copying script to /bin/passwd-manager"
sleep 1
mkdir /bin/passwd-manager
cd /$HOME/passwd-manager
cp * /bin/passwd-manager

# Add to path
BASHCHECK=$(cat ~/.bashrc | grep "bin/passwd-manager")
if [[ "$BASHCHECK" = "" ]]; then
  echo -e "Adding passwd-manager to PATH so you can access it from anywhere"
  sleep 1
  export PATH=/bin/passwd-manager:$PATH
  sleep 1
  echo "export PATH=/bin/passwd-manager:$PATH" >> ~/.bashrc
  sleep 1
  if [ ! -f ~/.bash_aliases]; then
    echo "alias passwd-manager='passwd-manager.sh'" > ~/.bash_aliases
  else
    echo "alias passwd-manager='passwd-manager.sh'" >> ~/.bash_aliases
fi

echo -e "DONE"
sleep 1
clear
# Flag that setup is complete
echo 1 > .setup_done

echo "Setup Successfully Completed."
echo "Open a new terminal and enter 'passwd-manager' to begin"
