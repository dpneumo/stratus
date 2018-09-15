#!/usr/bin/env bash

# OpenSSL -----------------------------
mkdir -p \
  CA \
  CA/certreqs \
  CA/certs \
  CA/newcerts \
  CA/crl \
  CA/private
chmod 700 CA/private
touch CA/index.txt
if [[ ! -e 'CA/serial' ]]; then
  echo '01' > CA/serial
fi
if [[ ! -e 'CA/crlnumber' ]]; then
  echo '01' > CA/crlnumber
fi

cat <<EOT >> ~/.bash_profile
# useful openssl aliases
alias cert='openssl x509 -noout -text -in'
alias req='openssl req -noout -text -in'
alias crl='openssl crl -noout -text -in'
EOT
source ~/.bash_profile

export subject=$SUBJ
export servsubj=/CN=$subject
export ca=blacklakeca
export casubj=/CN=$ca
export caconf=CA/$ca.cnf

cp /vagrant/openssl/$caconf $caconf
chmod 644 $caconf
ls -lst CA

# Private CA
printf "========= Building Private CA with $caconf ==========\n"
# Generate self signed CA cert if it does not yet exist.
# Also creates and saves private key. Unencrypted!
if [[ ! -e CA/private/cakey.pem ]]; then
  openssl req -new -x509 -newkey rsa:4096 -nodes -subj $casubj \
              -keyout 'CA/private/cakey.pem' \
              -out 'CA/cacert.pem' -days 3650 \
              -config $caconf -extensions 'v3_ca'
fi
# Generate cert for $subject signed by our private CA
printf "========= New $subject cert using $caconf ===========\n"
# Generate cert and csr
echo "Generating csr"
openssl req -new -newkey rsa:4096 -nodes -subj $servsubj \
            -keyout 'CA/private/'$subject'_key.pem' \
            -out 'CA/certreqs/'$subject'.csr' \
            -config $caconf
# Sign cert in csr
echo "Signing cert"
openssl ca  -in 'CA/certreqs/'$subject'.csr' \
            -out 'CA/certs/'$subject'_cert.pem' \
            -config $caconf -days 1095 -notext


