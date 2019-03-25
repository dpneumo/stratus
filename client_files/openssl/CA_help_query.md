A project needed an ssl server cert. As an educational exercise (and clear overkill for the project) I created a certificate chain using openssl: rootca > blacklakeca > stratus server cert.

openssl verification of the certs fails. Adding the rootca.cert.pem and blacklake.cert.pem to the CentOS 7 certificate store does not allow stratus.cert.pem to be trusted. However, adding rootca.cert.pem to the Windows 7 Trusted Root Certification Authorities and blacklakeca.cert.pem to Intermediate Certification Authorities does allow the server certificate, stratus.cert.pem, to be trusted. The openssl verify results suggest that the rootca is the problem. but I can't see it.

I can provide the cnf files and the scripts used to generate the certs. However, I think the problem should be visible in the cert itself.

Why can't this cert intended as a Root CA be verified by openssl verify?
```
$ openssl verify -CAfile CA/certs/rootca.cert.pem CA/certs/rootca.cert.pem
CA/certs/rootca.cert.pem: C = US, ST = Texas, O = BlackLakeSoftware, OU = CertMan, CN = rootca
error 20 at 0 depth lookup:unable to get local issuer certificate
```
The rootca cert: (cert is an alias for 'openssl x509 -noout -text -in')
```
$ cert CA/certs/rootca.cert.pem
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            bd:f9:b0:47:3d:63:84:8e
    Signature Algorithm: sha512WithRSAEncryption
        Issuer: C=US, ST=Texas, L=Arlington, O=BlackLakeSoftware, OU=CertMan, CN=rootca/emailAddress=funnyname@mail.us
        Validity
            Not Before: Mar 25 05:11:04 2019 GMT
            Not After : Apr 24 05:11:04 2019 GMT
        Subject: C=US, ST=Texas, L=Arlington, O=BlackLakeSoftware, OU=CertMan, CN=rootca
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (4096 bit)
                Modulus:
                    00:c8:cc:1c:77:7b:10:8b:16:2f:1e:ff:9f:d7:37:
                    ...
                    cf:cf:19:90:e1:91:43:b9:09:55:c3:d9:cf:ea:b0:
                    ba:70:ab
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Basic Constraints: critical
                CA:TRUE
            X509v3 Subject Key Identifier:
                A0:BE:F1:D5:B0:E5:7A:26:79:FD:1F:C3:83:3A:EF:BA:7A:73:2C:04
            X509v3 Authority Key Identifier:
                keyid:A0:BE:F1:D5:B0:E5:7A:26:79:FD:1F:C3:83:3A:EF:BA:7A:73:2C:04

            X509v3 Key Usage: critical
                Digital Signature, Certificate Sign, CRL Sign
            X509v3 Subject Alternative Name:
                email:funnyname@mail.us
    Signature Algorithm: sha512WithRSAEncryption
         b5:74:dc:3b:88:fc:34:03:94:55:3c:7a:8a:78:1e:8a:a5:7f:
         ...
         bd:0d:e3:bd:54:bd:93:a0:b6:17:b5:14:26:cd:d2:57:e8:b0:
         41:08:33:96:99:01:7d:8e
```

That failure means verifying an intermediate CA and a server certificate signed by the intermediate CA fails too:
```
$ openssl verify -CAfile 'CA/certs/rootca.cert.pem' 'CA/intermediate/certs/blacklakeca.cert.pem'
CA/intermediate/certs/blacklakeca.cert.pem: C = US, ST = Texas, O = BlackLakeSoftware, OU = CertMan, CN = rootca
error 2 at 1 depth lookup:unable to get issuer certificate
```

```
$cert CA/intermediate/certs/blacklakeca.cert.pem
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 4096 (0x1000)
    Signature Algorithm: sha512WithRSAEncryption
        Issuer: C=US, ST=Texas, L=Arlington, O=BlackLakeSoftware, OU=CertMan, CN=rootca
        Validity
            Not Before: Mar 25 05:12:05 2019 GMT
            Not After : Mar 24 05:12:05 2022 GMT
        Subject: C=US, ST=Texas, L=Arlington, O=BlackLakeSoftware, OU=CertMan, CN=blacklakeca
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (4096 bit)
                Modulus:
                    00:bf:69:b4:92:c9:f5:c7:b6:40:11:de:bd:78:e0:
                    ...
                    f1:90:49:78:f1:eb:81:f3:de:e4:a1:cc:d2:c9:24:
                    69:75:b1
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Basic Constraints: critical
                CA:TRUE, pathlen:0
            X509v3 Subject Key Identifier:
                8D:26:BF:6F:96:C4:04:E6:DC:6C:74:34:F1:70:79:7D:ED:3A:2D:EC
            X509v3 Authority Key Identifier:
                keyid:A0:BE:F1:D5:B0:E5:7A:26:79:FD:1F:C3:83:3A:EF:BA:7A:73:2C:04

            X509v3 Key Usage: critical
                Digital Signature, Certificate Sign, CRL Sign
            X509v3 Subject Alternative Name:
                email:funnyname@mail.us
    Signature Algorithm: sha512WithRSAEncryption
         1b:1b:f5:40:bd:54:8c:fc:62:b3:85:ce:0d:ee:e7:9b:c1:66:
         ...
         db:d7:56:42:64:ea:b3:fa:2c:6a:e2:b9:4c:df:a6:da:24:92:
         24:1d:21:3b:12:1e:36:77
```

Verifying stratus.cert.pem where blacklakeca-chain contains the certs for blacklakeca and rootca
```
$ openssl verify -CAfile 'CA/intermediate/certs/blacklakeca-chain.cert.pem' 'CA/intermediate/certs/stratus.cert.pem'
CA/intermediate/certs/stratus.cert.pem: C = US, ST = Texas, O = BlackLakeSoftware, OU = CertMan, CN = rootca
error 2 at 2 depth lookup:unable to get issuer certificate
```

```
$cert CA/intermediate/certs/stratus.cert.pem
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 4097 (0x1001)
    Signature Algorithm: sha512WithRSAEncryption
        Issuer: C=US, ST=Texas, L=Arlington, O=BlackLakeSoftware, OU=CertMan, CN=blacklakeca
        Validity
            Not Before: Mar 25 05:12:54 2019 GMT
            Not After : Mar 24 05:12:54 2020 GMT
        Subject: C=US, ST=Texas, L=Arlington, O=BlackLakeSoftware, OU=Apps, CN=stratus
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (4096 bit)
                Modulus:
                    00:b1:a3:b1:21:fb:19:e3:ce:6b:35:59:f0:06:4e:
                    ...
                    31:45:db:1c:13:62:56:d4:1f:47:86:78:36:92:5c:
                    bd:0d:f7
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Basic Constraints:
                CA:FALSE
            Netscape Cert Type:
                SSL Server
            Netscape Comment:
                OpenSSL Generated Server Certificate
            X509v3 Subject Key Identifier:
                D7:4D:24:6C:9E:2A:CD:7D:6A:1F:41:45:39:A4:B8:19:46:9C:08:AC
            X509v3 Authority Key Identifier:
                keyid:8D:26:BF:6F:96:C4:04:E6:DC:6C:74:34:F1:70:79:7D:ED:3A:2D:EC

            X509v3 Key Usage: critical
                Digital Signature, Key Encipherment
            X509v3 Extended Key Usage:
                TLS Web Server Authentication
            X509v3 Subject Alternative Name:
                DNS:stratus.attlocal.net, DNS:stratus, IP Address:192.168.1.114
    Signature Algorithm: sha512WithRSAEncryption
         9f:bb:eb:41:bc:34:3a:a3:2b:ca:63:57:03:eb:ca:7f:63:21:
         ...
         14:7a:00:cf:20:36:ed:08:36:94:cb:ce:40:f3:02:07:97:9a:
         3d:80:e2:b1:e5:d9:cf:35
```
