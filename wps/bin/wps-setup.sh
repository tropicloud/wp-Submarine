
wps_setup() {
	
	# SYSTEM
	# ---------------------------------------------------------------------------------

	find $conf -type f | xargs sed -i "s|example.com|$WP_DOMAIN|g"

	if [[  ! -f $home/.env  ]]; then wps_env; fi
	if [[  $WP_SSL == 'true'  ]]; then wps_ssl; fi
	if [[  $WP_SQL == 'local'  ]]; then wps_mysql; fi

	sed -i "s/WPS_PASSWORD/$WPS_PASSWORD/g" $conf/supervisor/supervisord.conf
	
	# WORDPRESS
	# ---------------------------------------------------------------------------------
	
	wps_header "Installing WordPress"
	
	su -l $user -c "git clone $WP_REPO $www" && wps_version
	su -l $user -c "cd $www && composer install"
	ln -s $home/.env $www/.env

	wps_wp_install > $conf/submarine/wordpress.log 2>&1 &
	wps_wp_wait			
}
