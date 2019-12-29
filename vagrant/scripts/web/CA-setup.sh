#!/usr/bin/env bash
SRC='/vagrant/client_files'

# Run unprivileged
printf "\n========= Prepare CA dirs =========================\n"
# Prepare root CA directories in dir CA
mkdir -p CA && cd CA
mkdir -p certs newcerts crl private
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

printf "\n========= Place CA scripts in home dir ============\n"
cd ~
cp $SRC/openssl/prep_ca.sh              prep_ca.sh
cp $SRC/openssl/setup_rootca.sh         setup_rootca.sh
cp $SRC/openssl/setup_interca.sh        setup_interca.sh
cp $SRC/openssl/stratus_server_cert.sh  stratus_server_cert.sh

printf "\n========= Insure home dir CA scripts are runable ==\n"
sudo chmod 755 *ca.sh stratus_server_cert.sh

