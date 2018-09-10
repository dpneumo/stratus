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
echo '01' > CA/serial
echo '01' > CA/crlnumber

cat <<EOT >> ~/.bash_profile
# useful openssl aliases
alias cert='openssl x509 -noout -text -in'
alias req='openssl req -noout -text -in'
alias crl='openssl crl -noout -text -in'
EOT
source ~/.bash_profile

export casubj="/CN=blacklakeca"
export prefix=stratus
export subj="/CN=$prefix"
export conf=CA/$prefix.cnf

cp /vagrant/openssl/$conf $conf
chmod 644 $conf
ls -lst CA

# Private CA
printf "========= Building Private CA with $conf =============\n"
# Generate self signed CA cert.
# Also creates and saves private key. Unencrypted!
openssl req -new -x509 -newkey rsa:4096 -nodes -subj $casubj \
            -keyout 'CA/private/cakey.pem' \
            -out 'CA/cacert.pem' -days 3650 \
            -config $conf -extensions 'v3_ca'

# Generate cert for $conf signed by our private CA
printf "========= New stratus cert with $conf =================\n"
# Generate cert and csr
echo "Generating csr"
openssl req -new -newkey rsa:4096 -nodes -subj $subj \
            -keyout 'CA/private/'$prefix'_key.pem' \
            -out 'CA/certreqs/'$prefix'.csr' \
            -config $conf
# Sign cert in csr
echo "Signing cert"
openssl ca  -in 'CA/certreqs/'$prefix'.csr' \
            -out 'CA/certs/'$prefix'.pem' \
            -config $conf -days 1095


