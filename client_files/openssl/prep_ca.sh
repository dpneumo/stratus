#!/usr/bin/env bash
# Run:  ./prep_ca_dirs.sh
# will run in user's home dir

cd ~/
printf "========= Prep CA dirs ==========\n"
# Prepare root CA directories in dir CA
mkdir -p CA && cd CA
mkdir -p certs newcerts csr crl private
chmod 700 private
touch index.txt
if [[ ! -e 'serial' ]]; then
  echo '1000' > serial
fi
if [[ ! -e 'crlnumber' ]]; then
  echo '1000' > crlnumber
fi
# Prepare intermediate CA directories in dir CA/intermediate
mkdir -p intermediate && cd intermediate
mkdir -p certs newcerts crl csr private
chmod 700 private
touch index.txt
if [[ ! -e 'serial' ]]; then
  echo '1000' > serial
fi
if [[ ! -e 'crlnumber' ]]; then
  echo '1000' > crlnumber
fi


cd ~/
printf "========= Place CA scripts ==========\n"
SRC='/vagrant/client_files'
cp $SRC/openssl/setup_rootca.sh               setup_rootca.sh
cp $SRC/openssl/setup_blacklakeca.sh          setup_blacklakeca.sh
cp $SRC/openssl/stratus_server_cert.sh        stratus_server_cert.sh
chmod +x *.sh
