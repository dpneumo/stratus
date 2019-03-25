#!/usr/bin/env bash
# Run:  ./stratus_server_cert.sh
# will run in user's home dir

cd /home/$(whoami)

servsubj='/C=US/ST=Texas/L=Arlington/O=BlackLakeSoftware/OU=Apps/CN=stratus'

SRC='/vagrant/client_files'
CAint='CA/intermediate'

# Install configuration file
cp $SRC'/openssl/CA/server.cnf' $CAint'/server.cnf'
chmod 644 $CAint'/server.cnf'

# Build Server Certificate
printf "========= Server certificate with server.cnf ==========\n"
# Generate Server csr
# Also creates and saves private key. Unencrypted!
printf "========= Server csr with server.cnf ==========\n"
openssl req -new -subj $servsubj \
            -nodes -sha512 \
            -keyout $CAint'/private/stratus.key.pem' \
            -config $CAint'/server.cnf' \
            -out $CAint'/csr/stratus.csr.pem'

# Make Server private key read-only by current user
chmod 400 $CAint'/private/stratus.key.pem'

# Generate the Server certificate - valid 1 year
printf "========= Use blacklake CA to generate Server cert ==========\n"
openssl ca -in $CAint'/csr/stratus.csr.pem' \
           -keyfile $CAint'/private/blacklakeca.key.pem' \
           -cert $CAint'/certs/blacklakeca.cert.pem' \
           -config $CAint'/server.cnf' \
           -extensions 'server_cert' \
           -notext \
           -out $CAint'/certs/stratus.cert.pem'

# Make Server certificate read-only by all users
chmod 444 $CAint'/certs/stratus.cert.pem'

# Show the Server certificate
openssl x509 -noout -text \
             -in $CAint'/certs/stratus.cert.pem'

openssl verify -CAfile $CAint'/certs/blacklakeca-chain.cert.pem' \
               $CAint'/certs/stratus.cert.pem'
