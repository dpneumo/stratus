#!/usr/bin/env bash
# Run:  ./setup_rootca.sh
# will run in user's home dir

cd /home/$(whoami)

casubj='/C=US/ST=Texas/L=Arlington/O=BlackLakeSoftware/OU=CertMan/CN=rootca/emailAddress=funnyname@mail.us'

SRC='/vagrant/client_files'


# Install configuration file
cp $SRC'/openssl/CA/rootca.cnf' 'CA/rootca.cnf'
chmod 644 'CA/rootca.cnf'

# Build the root CA certificate
printf "========= Building root CA with rootca.cnf ==========\n"
# Generate root CA csr and the self signed cert in one go.
# Also creates and saves private key. Unencrypted!
# Remove -nodes to password protect private key
openssl req -new  -subj $casubj \
            -nodes -newkey rsa:4096 \
            -keyout 'CA/private/rootca.key.pem' \
            -x509 \
            -config 'CA/rootca.cnf' \
            -extensions 'v3_ca' \
            -out 'CA/certs/rootca.cert.pem'

# Make root CA certificate read only by all users
chmod 444 'CA/certs/rootca.cert.pem'

# Show the rootca cert
openssl x509 -noout -text \
             -in 'CA/certs/rootca.cert.pem'
