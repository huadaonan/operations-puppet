# http://planet.wikimedia.org/

# old planet
class misc::planet {
	#The host of this role must have the star certificate installed on it
	system_role { "misc::planet": description => "Planet weblog aggregator" }

	systemuser { planet: name => "planet", home => "/var/lib/planet", groups => [ "planet" ] }

	class {'webserver::php5': ssl => 'true'; }

	include generic::locales::international

	file {
		"/etc/apache2/sites-available/planet.wikimedia.org":
			path => "/etc/apache2/sites-available/planet.wikimedia.org",
			mode => 0444,
			owner => root,
			group => root,
			source => "puppet:///files/apache/sites/planet.wikimedia.org";
	}

	apache_site { planet: name => "planet.wikimedia.org" }

	package { "python2.6":
		ensure => latest;
	}
}

# new planet
class misc::planet-venus( $planet_domain_name, $planet_languages ) {

	# http://intertwingly.net/code/venus/
	package { "planet-venus":
		ensure => latest;
	}

	systemuser { planet: name => "planet", home => "/var/lib/planet", groups => [ "planet" ] }

	file {
		"/etc/apache2/sites-available/planet.${planet_domain_name}":
			path => "/etc/apache2/sites-available/planet.${planet_domain_name}",
			mode => 0444,
			owner => root,
			group => root,
			content => template('apache/sites/planet.erb');
		"/var/www/planet/":
			path => "/var/www/planet",
			mode => 0755,
			owner => planet,
			group => www-data,
			ensure => directory;
		"/var/www/index.html":
			path => "/var/www/index.html",
			mode => 0444,
			owner => www-data,
			group => www-data,
			source => "puppet:///files/planet/index.html";
		"/var/log/planet":
			path => "/var/log/planet",
			mode => 0755,
			owner => planet,
			group => planet,
			ensure => directory;
		"/usr/share/planet-venus/wikimedia":
			path => "/usr/share/planet-venus/wikimedia",
			mode => 0755,
			owner => planet,
			group => planet,
			ensure => directory;
		"/usr/local/bin/update-planets":
			path => "/usr/local/bin/update-planets",
			mode => 0550,
			owner => planet,
			group => planet,
			source => "puppet:///files/planet/update-planets";
	}

	define planetconfig {

		file {
			"/usr/share/planet-venus/wikimedia/${title}":
				path => "/usr/share/planet-venus/wikimedia/${title}",
				mode => 0755,
				owner => planet,
				group => planet,
				ensure => directory;
			"/usr/share/planet-venus/wikimedia/${title}/config.ini":
				path => "/usr/share/planet-venus/wikimedia/${title}/config.ini",
				ensure => present,
				owner => planet,
				group => planet,
				mode => 0444,
				content => template("planet/${title}_config.erb"),
		}
	}

	planetconfig { $planet_languages: }

	define planetwwwdir {

		file {
			"/var/www/planet/${title}":
				path => "/var/www/planet/${title}",
				ensure => directory,
				owner => planet,
				group => www-data,
				mode => 0755,
		}
	}

	planetwwwdir { $planet_languages: }

	apache_site { planet: name => "planet.${planet_domain_name}" }

	cron {
		"update-all-planets":
		ensure => present,
		command => "/usr/local/bin/update-planets",
		user => 'planet',
		hour => '0',
		minute => '0',
		require => [User['planet'], File['/usr/local/bin/update-planets']];
	}

}
