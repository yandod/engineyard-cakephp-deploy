# prepare shared files and directories
run "ln -s #{shared_path}/app/Config/database.php #{release_path}/app/Config/database.php"
run "ln -s #{shared_path}/app/Plugin #{release_path}/app/Plugin"
run "ln -s #{shared_path}/app/files #{release_path}/app/files"

# set timezone in php.ini
sudo "echo 'date.timezone = Asia/Tokyo' > /etc/php/cgi-php5.3/ext-active/timezone.ini"
sudo "echo 'date.timezone = Asia/Tokyo' > /etc/php/cli-php5.3/ext-active/timezone.ini"
sudo "echo 'date.timezone = Asia/Tokyo' > /etc/php/fpm-php5.3/ext-active/timezone.ini"

# set allow_url_fopen = On
sudo "echo 'allow_url_fopen = On' > /etc/php/cgi-php5.3/ext-active/timezone.ini"
sudo "echo 'allow_url_fopen = On' > /etc/php/cli-php5.3/ext-active/timezone.ini"
sudo "echo 'allow_url_fopen = On' > /etc/php/fpm-php5.3/ext-active/timezone.ini"

# kick composer install
#run "curl -s https://getcomposer.org/installer | php -d allow_url_fopen=on"
#run "php -d allow_url_fopen=on composer.phar install"

# change nginx document root for CakePHP
run 'sed  -e \'s/root \/data\/' + app  + '\/current;/root \/data\/' + app  + '\/current\/app\/webroot;/\' /etc/nginx/servers/' + app  + '.conf > /etc/nginx/servers/' + app  + '.conf.tmp'
run "cp /etc/nginx/servers/" + app  + ".conf.tmp /etc/nginx/servers/" + app  + ".conf"