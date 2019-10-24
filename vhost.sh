echo "\n"
echo "==================================================================\n"
echo "            VIRTUAL HOST"
echo "\n"

echo "Adding vhost... hostname ? (default: 'project.com')"
read hostname
Username=${hostname:-"project.com"}


sudo mkdir -p /var/www/$hostname/html
sudo chown -R web:web /var/www/$hostname/html
sudo chmod -R 775 /var/www/$hostname

sudo cp /home/web/vhost/index.html /var/www/$hostname/html/


echo "<VirtualHost *:80>
	ServerAdmin contact@$hostname
	ServerName $hostname
	ServerAlias $hostname
	DocumentRoot /var/www/$hostname/html
	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

<VirtualHost *:443>
	DocumentRoot /var/www/$hostname/html
	ServerName $hostname
	SSLEngine on
	SSLCertificateFile /etc/ssl/certs/$hostname.crt
	SSLCertificateKeyFile /etc/ssl/certs/$hostname.key
</VirtualHost>" > /home/web/vhost/conf/$hostname.conf

sudo cp /home/web/vhost/conf/$hostname.conf /etc/apache2/sites-available/

sudo ln -s /etc/apache2/sites-available/$hostname /etc/apache2/sites-enabled/

echo "\n"
echo "==================================================================\n"
echo "            SSL CERTIFICAT"
echo "\n"

cd /etc/ssl/certs/
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $hostname.key -out $hostname.crt

sudo a2enmod ssl
sudo service apache2 restart

echo "done"
