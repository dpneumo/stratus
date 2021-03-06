#!/usr/bin/env bash
# Run:  ./stratus_server_cert.sh
# will run in user's home dir

cd /home/$(whoami)

servsubj="/C=US/ST=$StratusState/L=$StratusCity/O=$StratusOrg/OU=$StratusUnit/CN=$StratusCN"

SRC='/vagrant/client_files'
CAint='CA/intermediate'

# Install configuration file
cp $SRC'/openssl/CA/server.cnf' $CAint/server.cnf
chmod 644 $CAint'/server.cnf'
sed -i "s|interca|$OrgCACN|g;\
        s|dns1|$DNS1|g;\
        s|ip1|$IP1|g;\
        s|dns2|$DNS2|g;\
        s|dns3|$DNS3|g;" \
        $CAint/server.cnf

# Build Server Certificate
printf "========= Server certificate with server.cnf ==========\n"
# Generate Server csr
# Also creates and saves private key. Unencrypted!
# Remove -nodes to password protect private key
printf "========= Server csr with server.cnf ==========\n"
openssl req -new -subj $servsubj \
            -nodes -sha512 \
            -keyout $CAint'/private/stratus.key.pem' \
            -config $CAint'/server.cnf' \
            -out $CAint'/csr/stratus.csr.pem'

# Make Server private key read-only by current user
chmod 400 $CAint'/private/stratus.key.pem'

# Generate the Server certificate - valid 1 year
printf "========= Use $OrgCACN to generate Server cert ==========\n"
openssl ca -in $CAint/csr/stratus.csr.pem \
           -keyfile $CAint/private/$OrgCACN.key.pem \
           -cert $CAint/certs/$OrgCACN.cert.pem \
           -config $CAint/server.cnf \
           -extensions server_cert \
           -notext \
           -out $CAint/certs/stratus.cert.pem

# Make Server certificate read-only by all users
chmod 444 $CAint/certs/stratus.cert.pem

# Show the Server certificate
openssl x509 -noout -text \
             -in $CAint/certs/stratus.cert.pem

openssl verify -CAfile $CAint/certs/$OrgCACN-chain.cert.pem \
               $CAint/certs/stratus.cert.pem

