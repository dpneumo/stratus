#!/usr/bin/env bash
SRC='/vagrant/client_files'

# Run unprivileged
printf "\n========= Prepare CA dirs ==========\n"
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

printf "\n========= Place CA scripts ========================\n"
cd ~
cp $SRC/openssl/prep_ca.sh              prep_ca.sh              -fb --suffix=.$(date +%s)
cp $SRC/openssl/setup_rootca.sh         setup_rootca.sh         -fb --suffix=.$(date +%s)
cp $SRC/openssl/setup_organizationca.sh setup_organizationca.sh -fb --suffix=.$(date +%s)
cp $SRC/openssl/stratus_server_cert.sh  stratus_server_cert.sh  -fb --suffix=.$(date +%s)

# Cleanup home dir
if [[ ! -e ~/bkup ]]; then
  mkdir ~/bkup
fi
mv  *.sh.* ~/bkup/
