#!/usr/bin/env bash
# Run:  ./setup_blacklakeca.sh
# will run in user's home dir

cd /home/$(whoami)

casubj='/C=US/ST=Texas/L=Arlington/O=BlackLakeSoftware/OU=CertMan/CN=blacklakeca/emailAddress=funnyname@mail.us'

SRC='/vagrant/client_files'
CAint='CA/intermediate'

# Install configuration file
cp $SRC'/openssl/CA/blacklakeca.cnf' $CAint'/blacklakeca.cnf'
chmod 644 $CAint'/blacklakeca.cnf'

# Build the intermediate CA certificate
printf "\n========= Build intermediate CA with blacklakeca.cnf ==========\n"
# Generate intermediate CA csr
# Also creates and saves private key. Unencrypted!
# Remove -nodes to password protect private key
printf "========= blacklakeca csr with blacklakeca.cnf ==========\n"
openssl req -new -subj $casubj \
            -nodes -sha512 \
            -keyout $CAint'/private/blacklakeca.key.pem' \
            -config $CAint'/blacklakeca.cnf' \
            -out $CAint'/csr/blacklakeca.csr.pem'


# Make intermediate CA private key read-only by current user
chmod 400 $CAint'/private/blacklakeca.key.pem'

# Generate the intermediate CA certificate - valid 3 yrs
printf "======= Sign blacklakeca csr with rootca cert => blacklakeca cert ======\n"
openssl ca -in $CAint'/csr/blacklakeca.csr.pem' \
           -keyfile 'CA/private/rootca.key.pem' \
           -cert 'CA/certs/rootca.cert.pem' \
           -config $CAint'/blacklakeca.cnf' \
           -extensions 'v3_intermediate_ca' \
           -notext \
           -out $CAint'/certs/blacklakeca.cert.pem'

# Make intermediate CA certificate read-only by all users
chmod 444 $CAint'/certs/blacklakeca.cert.pem'

# Show the intermediate CA certificate
openssl x509 -noout -text \
             -in $CAint'/certs/blacklakeca.cert.pem'

openssl verify -CAfile 'CA/certs/rootca.cert.pem' \
               $CAint'/certs/blacklakeca.cert.pem'

# Cert chain
cat $CAint'/certs/blacklakeca.cert.pem' \
    'CA/certs/rootca.cert.pem' > $CAint'/certs/blacklakeca-chain.cert.pem'
chmod 444 $CAint'/certs/blacklakeca-chain.cert.pem'
