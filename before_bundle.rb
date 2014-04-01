if !Dir.exist?(config.shared_path + "/app/Config") then
  run "mkdir -p #{config.shared_path}/app/Config/"
  run "cp #{config.release_path}/app/Config/core.php #{config.shared_path}/app/Config/core.php"
  run "echo \"<?php
  class DATABASE_CONFIG {
  	var \\\$default = array(
  		'datasource' => 'Database/Mysql',
  		'persistent' => false,
  		'host' => '',
  		'login' => '',
  		'password' => '',
  		'database' => '',
  		'prefix' => '',
  		'port' => '',
  		'encoding' => 'utf8',
  	);
  	public function __construct()
  	{
  	  \\\$this->default = array(
    		'datasource' => 'Database/Mysql',
    		'persistent' => false,
    		'host' => \\\$_SERVER[\"DB_HOST\"],
    		'login' => \\\$_SERVER[\"DB_USER\"],
    		'password' => \\\$_SERVER[\"DB_PASS\"],
    		'database' => \\\$_SERVER[\"DB_NAME\"],
    		'prefix' => '',
    		'port' => '',
    		'encoding' => 'utf8',
    	);
  	}
  }\" > #{config.shared_path}/app/Config/database.php"
  run "mkdir -p #{config.shared_path}/app/files/"
  run "mkdir -p #{config.shared_path}/app/Plugin/"
  run "mysql #{app} < #{config.release_path}/app/Config/sql/mysql.sql"
end

# prepare shared files and directories
run "rm #{config.release_path}/app/Config/core.php && ln -s #{config.shared_path}/app/Config/core.php #{config.release_path}/app/Config/core.php"
run "ln -s #{config.shared_path}/app/Config/database.php #{config.release_path}/app/Config/database.php"
run "rm -r #{config.release_path}/app/Plugin && ln -s #{config.shared_path}/app/Plugin #{config.release_path}/app/Plugin"
run "ln -s #{config.shared_path}/app/files #{config.release_path}/app/files"

# set timezone in php.ini
sudo "echo 'date.timezone = Asia/Tokyo' > /etc/php/cgi-php5.4/ext-active/timezone.ini"
sudo "echo 'date.timezone = Asia/Tokyo' > /etc/php/cli-php5.4/ext-active/timezone.ini"
sudo "echo 'date.timezone = Asia/Tokyo' > /etc/php/fpm-php5.4/ext-active/timezone.ini"

# set allow_url_fopen = On
sudo "echo 'allow_url_fopen = On' > /etc/php/cgi-php5.4/ext-active/allow_url.ini"
sudo "echo 'allow_url_fopen = On' > /etc/php/cli-php5.4/ext-active/allow_url.ini"
sudo "echo 'allow_url_fopen = On' > /etc/php/fpm-php5.4/ext-active/allow_url.ini"

# set APC
#sudo "echo 'extension=apc.so' > /etc/php/cgi-php5.4/ext-active/apc.ini"
#sudo "echo 'extension=apc.so' > /etc/php/cli-php5.4/ext-active/apc.ini"
#sudo "echo 'extension=apc.so' > /etc/php/fpm-php5.4/ext-active/apc.ini"


# kick composer install
#run "curl -s https://getcomposer.org/installer | php -d allow_url_fopen=on"
#run "php -d allow_url_fopen=on composer.phar install"

# change nginx document root for CakePHP
#run 'sed  -e \'s/\/data\/' + app  + '\/current\/;/\/data\/' + app  + '\/current\/app\/webroot;/\' /etc/nginx/servers/' + app  + '.conf > /etc/nginx/servers/' + app  + '.conf.tmp'

# TODO: this piece has to be injected somehow.
# @proxy;\n
# @proxy ; if (!-e $request_filename) { rewrite ^(.+)$  /index.php?url=$1 last; break; }
# run "cp /etc/nginx/servers/" + app  + ".conf.tmp /etc/nginx/servers/" + app  + ".conf"
