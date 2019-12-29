#!/usr/bin/env bash
# Run:  ./setup_$OrgCACN.sh
# will run in user's home dir

cd /home/$(whoami)

casubj='/C=US/ST=$OrgCAState/L=$OrgCACity/O=$OrgCAOName/OU=CertMan/CN=$OrgCACN/emailAddress=funnyname@mail.us'

SRC='/vagrant/client_files'
CAint='CA/intermediate'

# Install configuration file
cp $SRC'/openssl/CA/interca.cnf' $CAint'/$OrgCACN.cnf'
chmod 644 $CAint'/$OrgCACN.cnf'
sed -i "s|interca|$OrgCACN|g" $CAint'/$OrgCACN.cnf'

# Build the intermediate CA certificate
printf "\n========= Build intermediate CA with $OrgCACN.cnf ==========\n"
# Generate intermediate CA csr
# Also creates and saves private key. Unencrypted!
# Remove -nodes to password protect private key
printf "========= $OrgCACN csr with $OrgCACN.cnf ==========\n"
openssl req -new -subj $casubj \
            -nodes -sha512 \
            -keyout $CAint'/private/$OrgCACN.key.pem' \
            -config $CAint'/$OrgCACN.cnf' \
            -out $CAint'/csr/$OrgCACN.csr.pem'


# Make intermediate CA private key read-only by current user
chmod 400 $CAint'/private/$OrgCACN.key.pem'

# Generate the intermediate CA certificate - valid 3 yrs
printf "======= Sign $OrgCACN csr with rootca cert => $OrgCACN cert ======\n"
openssl ca -in $CAint'/csr/$OrgCACN.csr.pem' \
           -keyfile 'CA/private/rootca.key.pem' \
           -cert 'CA/certs/rootca.cert.pem' \
           -config $CAint'/$OrgCACN.cnf' \
           -extensions 'v3_intermediate_ca' \
           -notext \
           -out $CAint'/certs/$OrgCACN.cert.pem'

# Make intermediate CA certificate read-only by all users
chmod 444 $CAint'/certs/$OrgCACN.cert.pem'

# Show the intermediate CA certificate
openssl x509 -noout -text \
             -in $CAint'/certs/$OrgCACN.cert.pem'

openssl verify -CAfile 'CA/certs/rootca.cert.pem' \
               $CAint'/certs/$OrgCACN.cert.pem'

# Cert chain
cat $CAint'/certs/$OrgCACN.cert.pem' \
    'CA/certs/rootca.cert.pem' > $CAint'/certs/$OrgCACN-chain.cert.pem'
chmod 444 $CAint'/certs/$OrgCACN-chain.cert.pem'
