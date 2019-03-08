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

cd CA
export ca=blacklakeca
export DNdflts="/C=US/ST=Texas/L=Arlington/O=BlackLakeSoftware/OU=Applications"
export casubj="/CN=$ca$DNdflts/emailAddress=dpneumo@gmail.com"
export caconf=$ca.cnf
export subject=$SUBJ

cp /vagrant/openssl/CA/$caconf $caconf
cp /vagrant/openssl/CA/server.csr.cnf server.csr.cnf
cp /vagrant/openssl/CA/server_v3.ext server_v3.ext
chmod 644 *.cnf
chmod 644 *.ext

# Private CA
printf "========= Building Private CA with $caconf ==========\n"
# Generate self signed CA cert if it does not yet exist.
# Also creates and saves private key. Unencrypted!
if [[ ! -e private/cakey.pem ]]; then
  openssl req -new -x509 -newkey rsa:4096 -nodes -days 3650 \
              -subj $casubj \
              -keyout 'private/cakey.pem' \
              -out 'cacert.pem' \
              -config $caconf -extensions 'v3_ca'
fi

# Generate cert for $subject signed by our private CA
printf "========= New $subject cert using $caconf ===========\n"
# Generate csr
openssl req -new -nodes \
            -keyout 'private/'$subject'_key.pem' \
            -out 'certreqs/'$subject'.csr' \
            -config server.csr.cnf

# Generate the certificate
openssl x509 -req \
             -in 'certreqs/'$subject'.csr' \
             -out 'certs/'$subject'_cert.pem' \
             -CA 'cacert.pem' \
             -CAkey 'private/cakey.pem' \
             -days 1095 -extfile 'server_v3.ext' \
             -CAcreateserial

