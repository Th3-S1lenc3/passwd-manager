#! /bin/bash
# Written by Th3_S1lenc3

# Generate password
PASSWD_LENGTH=48
read -rp "Password Length: " -e -i "$PASSWD_LENGTH" PASSWD_LENGTH
PASSWD=$(openssl rand -base64 $PASSWD_LENGTH)

# Get data directory for output
DATA_DIR=output
read -rp "Output Directory: " -e -i "$DATA_DIR" DATA_DIR

# Get identifier and hash
IDENTIFIER=$(echo $PASSWD | head -c 10)
HASH=$(echo $IDENTIFIER | sha256sum | rev | cut -c3- | rev)

# Check if directories exists
if [ ! -d $HASH  || ! -d $DATA_DIR ]; then
  mkdir ${DATA_DIR}/${HASH}
fi

# Generate keys
PRIVATE_KEY_FILE=${DATA_DIR}/${HASH}/privatekey.pem
PUBLIC_KEY_FILE=${DATA_DIR}/${HASH}/publickey.pub

openssl genrsa -out $PRIVATE_KEY_FILE 4096
openssl rsa -in $PRIVATE_KEY_FILE -pubout > $PUBLIC_KEY_FILE

# Store and encrypt password
PASSWD_FILE=${DATA_DIR}/${HASH}/password.txt
PASSWD_ENC_FILE=${DATA_DIR}/${HASH}/password.enc

echo $PASSWD > ${PASSWD_FILE}

openssl rsautl -encrypt -inkey ${PUBLIC_KEY_FILE} -pubin -in ${PASSWD_FILE} -out ${PASSWD_ENC_FILE}

# Cleanup
echo "Cleaning Up..."
echo "Securly erasing unencrypted files"
srm -zr ${PASSWD_FILE}

# Output
echo "Password: " $PASSWD
echo "Password Hash: " $HASH
echo "Encrypted Password File in: " ${PASSWD_ENC_FILE}
