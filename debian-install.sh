#!/bin/bash
# Jexactyl Auto-Installer for Debian 11/12 - by Code X (APS)

set -e

echo "🔄 Updating system..."
apt update && apt upgrade -y

echo "📦 Installing dependencies..."
apt install -y curl gnupg2 ca-certificates lsb-release apt-transport-https software-properties-common

# Add PHP repo
echo "➕ Adding PHP 8.1 repo..."
curl -sSL https://packages.sury.org/php/README.txt | bash - || true
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list
wget -qO - https://packages.sury.org/php/apt.gpg | gpg --dearmor > /etc/apt/trusted.gpg.d/php.gpg
apt update

apt install -y nginx mariadb-server php8.1 php8.1-{cli,fpm,mysql,mbstring,xml,curl,zip,bcmath,gd} unzip git composer nodejs npm

echo "🔐 Configuring MySQL..."
DB_PASS="StrongPassword"
mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE jexactyl;
CREATE USER 'jexactyluser'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON jexactyl.* TO 'jexactyluser'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo "⬇️ Cloning Jexactyl..."
cd /var/www
git clone https://github.com/Jexactyl/Jexactyl.git panel
cd panel

echo "📦 Installing PHP dependencies..."
composer install --no-dev --optimize-autoloader

echo "🔧 Setting permissions..."
chown -R www-data:www-data /var/www/panel
chmod -R 755 storage bootstrap/cache

echo "📝 Configuring .env..."
cp .env.example .env
sed -i "s|APP_URL=.*|APP_URL=http://yourdomain.com|g" .env
sed -i "s|DB_DATABASE=.*|DB_DATABASE=jexactyl|g" .env
sed -i "s|DB_USERNAME=.*|DB_USERNAME=jexactyluser|g" .env
sed -i "s|DB_PASSWORD=.*|DB_PASSWORD=${DB_PASS}|g" .env

echo "🔐 Generating key and migrating DB..."
php artisan key:generate --force
php artisan migrate --seed --force

echo "🌐 Configuring NGINX..."
cat <<EOF > /etc/nginx/sites-available/jexactyl
server {
    listen 80;
    server_name yourdomain.com;

    root /var/www/panel/public;
    index index.php;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

ln -s /etc/nginx/sites-available/jexactyl /etc/nginx/sites-enabled/
nginx -t && systemctl reload nginx

echo ""
echo "✅ Jexactyl Panel Installed on Debian!"
echo "👉 Access it at: http://yourdomain.com"
echo "🔐 Login: admin@example.com | password"
echo "⚠️  Change domain + secure with HTTPS using Certbot if needed."
