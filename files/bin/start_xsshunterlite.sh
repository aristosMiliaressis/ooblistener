#!/bin/bash

if [ "$EUID" -ne 0 ]
then
    echo "Please run as root"
    exit 1
fi

domain_name=$(cat /opt/domain.txt)
root_cert_filepath="/root/.local/share/certmagic/certificates/acme-v02.api.letsencrypt.org-directory/$domain_name/$domain_name.crt"
root_key_filepath="/root/.local/share/certmagic/certificates/acme-v02.api.letsencrypt.org-directory/$domain_name/$domain_name.key"
wildcard_cert_filepath="/root/.local/share/certmagic/certificates/acme-v02.api.letsencrypt.org-directory/wildcard_.$domain_name/wildcard_.$domain_name.crt"
wildcard_key_filepath="/root/.local/share/certmagic/certificates/acme-v02.api.letsencrypt.org-directory/wildcard_.$domain_name/wildcard_.$domain_name.key"

cat >/etc/httpd/conf.d/${domain_name}.conf <<EOF
<VirtualHost *:80>
    ServerName ${domain_name}
    ServerAlias *.${domain_name}

    RewriteEngine On
    RewriteRule ^(.*)$ https://${domain_name}\$1 [L,R=307]
</VirtualHost>

<VirtualHost *:443>
        ServerName ${domain_name}

        SSLEngine on
        SSLCertificateFile "${root_cert_filepath}"
        SSLCertificateKeyFile "${root_key_filepath}"

        WSGIDaemonProcess xsshunterlite user=apache group=apache threads=5
        WSGIProcessGroup xsshunterlite
        WSGIScriptAlias / /var/www/xsshunterlite/api.wsgi
        
        <Directory /var/www/xsshunterlite>
            WSGIProcessGroup xsshunterlite
            Require all granted
        </Directory> 
</VirtualHost>

<VirtualHost *:443>
        ServerAlias *.${domain_name}

        SSLEngine on
        SSLCertificateFile "${wildcard_cert_filepath}"
        SSLCertificateKeyFile "${wildcard_key_filepath}"

        WSGIDaemonProcess xsshunterlite2 user=apache group=apache threads=5
        WSGIProcessGroup xsshunterlite2
        WSGIScriptAlias / /var/www/xsshunterlite/api.wsgi
        
        <Directory /var/www/xsshunterlite>
            WSGIProcessGroup xsshunterlite2
            Require all granted
        </Directory> 
</VirtualHost>
EOF

systemctl enable httpd.service
systemctl start httpd.service