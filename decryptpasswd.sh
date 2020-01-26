#!/bin/bash
# Written by Th3_S1lenc3

# Get data directory for output
DATA_DIR=output
read -rp "Directory to keys (Excluding File Hash): " -e -i "$DATA_DIR" DATA_DIR

# Get File Hash
HASH=''
read -rp "File Hash: " HASH

# Get keys
PRIVATE_KEY_FILE=${DATA_DIR}/${HASH}/privatekey.pem
PUBLIC_KEY_FILE=${DATA_DIR}/${HASH}/publickey.pub

# Extract and decrypt password
PASSWD_FILE=${DATA_DIR}/${HASH}/password.txt
PASSWD_ENC_FILE=${DATA_DIR}/${HASH}/password.enc

openssl rsautl -decrypt -inkey ${PRIVATE_KEY_FILE} -in ${PASSWD_ENC_FILE} -out ${PASSWD_FILE}

# Cleanup
echo "Cleaning Up..."
echo "Securly erasing encrypted files"
srm -zr ${PASSWD_ENC_FILE}

# Output
echo "Password: " $PASSWD
echo "Uncrypted Password File in: " ${PASSWD_FILE}
