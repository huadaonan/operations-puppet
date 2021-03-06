# role/cache.pp
# cache::squid and cache::varnish role classes

# Virtual resources for the monitoring server
@monitor_group { "cache_text_pmtpa": description => "text squids pmtpa" }
@monitor_group { "cache_text_eqiad": description => "text squids eqiad" }
@monitor_group { "cache_text_esams": description => "text squids esams" }

@monitor_group { "cache_upload_pmtpa": description => "upload squids pmtpa" }
@monitor_group { "cache_upload_eqiad": description => "upload squids eqiad" }
@monitor_group { "cache_upload_esams": description => "upload squids esams" }

class role::cache {
	class configuration {
		$active_nodes = {
			"text" => {
				"pmtpa" => [
					'sq33.wikimedia.org',   # API
					'sq34.wikimedia.org',   # API
					'sq36.wikimedia.org',   # API
					'sq37.wikimedia.org',
					'sq59.wikimedia.org',
					'sq60.wikimedia.org',
					'sq61.wikimedia.org',
					'sq62.wikimedia.org',
					'sq63.wikimedia.org',
					'sq64.wikimedia.org',
					'sq65.wikimedia.org',
					'sq66.wikimedia.org',
					'sq71.wikimedia.org',
					'sq72.wikimedia.org',
					'sq73.wikimedia.org',
					'sq74.wikimedia.org',
					'sq75.wikimedia.org',
					'sq76.wikimedia.org',
					'sq77.wikimedia.org',
					'sq78.wikimedia.org',
					],
				"eqiad" => [
					'cp1001.eqiad.wmnet',	# API
					'cp1002.eqiad.wmnet',	# API
					'cp1003.eqiad.wmnet',	# API
					'cp1004.eqiad.wmnet',	# API
					'cp1005.eqiad.wmnet',	# API
					'cp1006.eqiad.wmnet',
					'cp1007.eqiad.wmnet',
					'cp1008.eqiad.wmnet',
					'cp1009.eqiad.wmnet',
					'cp1010.eqiad.wmnet',
					'cp1011.eqiad.wmnet',
					'cp1012.eqiad.wmnet',
					'cp1013.eqiad.wmnet',
					'cp1014.eqiad.wmnet',
					'cp1015.eqiad.wmnet',
					'cp1016.eqiad.wmnet',
					'cp1017.eqiad.wmnet',
					'cp1018.eqiad.wmnet',
					'cp1019.eqiad.wmnet',
					'cp1020.eqiad.wmnet',
				],
				"esams" => [
					"knsq23.knams.wikimedia.org",
					"knsq24.knams.wikimedia.org",
					"knsq25.knams.wikimedia.org",
					"knsq26.knams.wikimedia.org",
					"knsq27.knams.wikimedia.org",
					"knsq28.knams.wikimedia.org",
					"knsq29.knams.wikimedia.org",

					"amssq31.esams.wikimedia.org",
					"amssq32.esams.wikimedia.org",
					"amssq33.esams.wikimedia.org",
					"amssq34.esams.wikimedia.org",
					"amssq35.esams.wikimedia.org",
					"amssq36.esams.wikimedia.org",
					"amssq37.esams.wikimedia.org",
					"amssq38.esams.wikimedia.org",
					"amssq39.esams.wikimedia.org",
					"amssq40.esams.wikimedia.org",
					"amssq41.esams.wikimedia.org",
					"amssq42.esams.wikimedia.org",
					"amssq43.esams.wikimedia.org",
					"amssq44.esams.wikimedia.org",
					"amssq45.esams.wikimedia.org",
					"amssq46.esams.wikimedia.org",
					]
			},
			"api" => {
				"pmtpa" => [
					'sq33.wikimedia.org',   # API
					'sq34.wikimedia.org',   # API
					'sq36.wikimedia.org',   # API
				],
				"eqiad" => [
					'cp1001.eqiad.wmnet',	# API
					'cp1002.eqiad.wmnet',	# API
					'cp1003.eqiad.wmnet',	# API
					'cp1004.eqiad.wmnet',	# API
					'cp1005.eqiad.wmnet',	# API
				],
				"esams" => [],
			},
			"bits" => {
				"pmtpa" => ["sq67.wikimedia.org", "sq68.wikimedia.org", "sq69.wikimedia.org", "sq70.wikimedia.org"],
				"eqiad" => ["arsenic.wikimedia.org", "niobium.wikimedia.org", "strontium.eqiad.wmnet", "palladium.eqiad.wmnet", ],
				"esams" => ["cp3019.esams.wikimedia.org", "cp3020.esams.wikimedia.org", "cp3021.esams.wikimedia.org", "cp3022.esams.wikimedia.org"],
			},
			"upload" => {
				"pmtpa" => [
					'sq41.wikimedia.org',
					'sq42.wikimedia.org',
					'sq43.wikimedia.org',
					'sq44.wikimedia.org',
					'sq45.wikimedia.org',
					'sq48.wikimedia.org',
					'sq49.wikimedia.org',
					'sq50.wikimedia.org',

					'sq51.wikimedia.org',
					'sq52.wikimedia.org',
					'sq53.wikimedia.org',
					'sq54.wikimedia.org',
					'sq55.wikimedia.org',
					'sq56.wikimedia.org',
					'sq57.wikimedia.org',
					'sq58.wikimedia.org',

					'sq79.wikimedia.org',
					'sq80.wikimedia.org',
					'sq81.wikimedia.org',
					'sq82.wikimedia.org',
					'sq83.wikimedia.org',
					'sq84.wikimedia.org',
					'sq85.wikimedia.org',
					'sq86.wikimedia.org',
				],
				"eqiad" => [
					'cp1021.eqiad.wmnet',
					'cp1022.eqiad.wmnet',
					'cp1023.eqiad.wmnet',
					'cp1024.eqiad.wmnet',
					'cp1025.eqiad.wmnet',
					'cp1026.eqiad.wmnet',
					'cp1027.eqiad.wmnet',
					'cp1028.eqiad.wmnet',
					'cp1029.eqiad.wmnet',
					'cp1030.eqiad.wmnet',
					'cp1031.eqiad.wmnet',
					'cp1032.eqiad.wmnet',
					'cp1033.eqiad.wmnet',
					'cp1034.eqiad.wmnet',
					'cp1035.eqiad.wmnet',
					'cp1036.eqiad.wmnet',
				],
				"esams-varnish" => [	# FIXME: rename after Squid decommissioning
					'cp3009.esams.wikimedia.org',
					'cp3010.esams.wikimedia.org',
				],
				"esams" => [
					'knsq16.knams.wikimedia.org',
					'knsq17.knams.wikimedia.org',
					'knsq18.knams.wikimedia.org',
					'knsq19.knams.wikimedia.org',
					'knsq20.knams.wikimedia.org',
					'knsq21.knams.wikimedia.org',
					'knsq22.knams.wikimedia.org',

					'amssq47.esams.wikimedia.org',
					'amssq48.esams.wikimedia.org',
					'amssq49.esams.wikimedia.org',
					'amssq50.esams.wikimedia.org',
					'amssq51.esams.wikimedia.org',
					'amssq52.esams.wikimedia.org',
					'amssq53.esams.wikimedia.org',
					'amssq54.esams.wikimedia.org',
					'amssq55.esams.wikimedia.org',
					'amssq56.esams.wikimedia.org',
					'amssq57.esams.wikimedia.org',
					'amssq58.esams.wikimedia.org',
					'amssq59.esams.wikimedia.org',
					'amssq60.esams.wikimedia.org',
					'amssq61.esams.wikimedia.org',
					'amssq62.esams.wikimedia.org',
				],
			},
			"mobile" => {
				"pmtpa" => [],
				"eqiad" => ["cp1041.eqiad.wmnet", "cp1042.eqiad.wmnet", "cp1043.wikimedia.org", "cp1044.wikimedia.org"],
				"esams" => []
			}
		}

		$decommissioned_nodes = {
			"text" => {
				"pmtpa" => [
					'sq16.wikimedia.org',
					'sq17.wikimedia.org',
					'sq18.wikimedia.org',
					'sq19.wikimedia.org',
					'sq20.wikimedia.org',
					'sq21.wikimedia.org',
					'sq22.wikimedia.org',
					'sq23.wikimedia.org',
					'sq24.wikimedia.org',
					'sq25.wikimedia.org',
					'sq26.wikimedia.org',
					'sq27.wikimedia.org',
					'sq28.wikimedia.org',
					'sq29.wikimedia.org',
					'sq30.wikimedia.org',

					'sq31.wikimedia.org',
					"sq32.wikimedia.org",
					"sq35.wikimedia.org",
					'sq38.wikimedia.org',
					'sq40.wikimedia.org',
				],
				"eqiad" => [],
				"esams" => [
					'knsq1.knams.wikimedia.org',
					'knsq2.knams.wikimedia.org',
					'knsq3.knams.wikimedia.org',
					'knsq4.knams.wikimedia.org',
					'knsq5.knams.wikimedia.org',
					'knsq6.knams.wikimedia.org',
					'knsq7.knams.wikimedia.org',

					"knsq30.knams.wikimedia.org"
				]
			},
			"api" => {
				"pmtpa" => [],
				"eqiad" => [],
				"esams" => [],
			},
			"bits" => {
				"pmtpa" => [],
				"eqiad" => [],
				"esams" => [
					"knsq1.esams.wikimedia.org",
					"knsq2.esams.wikimedia.org",
					"knsq4.esams.wikimedia.org",
					"knsq5.esams.wikimedia.org",
					"knsq6.esams.wikimedia.org",
					"knsq7.esams.wikimedia.org"
				],
			},
			"upload" => {
				"pmtpa" => [
					'sq1.wikimedia.org',
					'sq2.wikimedia.org',
					'sq3.wikimedia.org',
					'sq4.wikimedia.org',
					'sq5.wikimedia.org',
					'sq6.wikimedia.org',
					'sq7.wikimedia.org',
					'sq8.wikimedia.org',
					'sq9.wikimedia.org',
					'sq10.wikimedia.org',
					'sq11.wikimedia.org',
					'sq12.wikimedia.org',
					'sq13.wikimedia.org',
					'sq14.wikimedia.org',
					'sq15.wikimedia.org',
					'sq47.wikimedia.org',
				],
				"eqiad" => [],
				"esams" => [
					'knsq8.knams.wikimedia.org',
					'knsq9.knams.wikimedia.org',
					'knsq10.knams.wikimedia.org',
					'knsq11.knams.wikimedia.org',
					'knsq12.knams.wikimedia.org',
					'knsq13.knams.wikimedia.org',
					'knsq14.knams.wikimedia.org',
					'knsq15.knams.wikimedia.org'
				],
			},
			"mobile" => {
				"pmtpa" => [],
				"eqiad" => [],
				"esams" => []
			},
		}
	}

	class squid {
		class common($role) {
			system_role { "role::cache::${role}": description => "${role} Squid cache server"}

			$cluster = "squids_${role}"
			$nagios_group = "cache_${role}_${::site}"

			include lvs::configuration

			include	standard,
				::squid

			class { "lvs::realserver": realserver_ips => $lvs::configuration::lvs_service_ips[$::realm][$role][$::site] }

			# Monitoring
			monitor_service {
				"frontend http":
					description => "Frontend Squid HTTP",
					check_command => $role ? {
						text => 'check_http',
						upload => 'check_http_upload',
					};
				"backend http":
					description => "Backend Squid HTTP",
					check_command => $role ? {
						text => 'check_http_on_port!3128',
						upload => 'check_http_upload_on_port!3128',
					};
			}

			# HTCP packet loss monitoring on the ganglia aggregators
			if $ganglia_aggregator == "true" and $::site != "esams" {
				include misc::monitoring::htcp-loss
			}
		}
	}

	class text {
		class { "role::cache::squid::common": role => "text" }
	}

	class upload {
		# FIXME: remove this hack
		if $::site == "eqiad" or ($::site == "esams" and $::hostname =~ /^cp30/) {
			# Varnish

			$cluster = "cache_upload"
			$nagios_group = "cache_upload_${::site}"

			system_role { "role::cache::upload": description => "upload Varnish cache server" }

			include lvs::configuration, role::cache::configuration, network::constants

			class { "lvs::realserver": realserver_ips => $lvs::configuration::lvs_service_ips[$::realm]['upload'][$::site] }

			$varnish_fe_directors = {
				"pmtpa" => {},
				"eqiad" => { "backend" => $role::cache::configuration::active_nodes['upload'][$::site] },
				# TODO: replace after removing Squid
				"esams" => { "backend" => $role::cache::configuration::active_nodes['upload']["${::site}-varnish"] },
			}

			$varnish_be_directors = {
				"eqiad" => {
					"backend" => [ "10.2.1.24" ],
					"swift" => [ "10.2.1.27" ],
					"image_scalers" => $lvs::configuration::lvs_service_ips[$::realm]['rendering'][$::mw_primary],
				},
				"esams" => {
					"backend" => "208.80.154.235",
				}
			}

			if $::site == "eqiad" {
				$storage_size_main = 100
				$storage_size_bigobj = 10
				$cluster_tier = 1
				$upstream_directors = {}
			} else {
				$storage_size_main = 500
				$storage_size_bigobj = 50
				$cluster_tier = 2
				$upstream_directors = { "eqiad" => $role::cache::configuration::active_nodes['upload']['eqiad'] }
			}

			if regsubst($::memorytotal, "^([0-9]+)\.[0-9]* GB$", "\1") > 32 {
				$memory_storage_size = 4
			} else {
				$memory_storage_size = 1
			}

			include standard,
				nrpe

			#class { "varnish::packages": version => "3.0.3plus~rc1-wm5" }

			varnish::setup_filesystem{ ["sda3", "sdb3"]:
				before => Varnish::Instance["upload-backend"]
			}

			class { "varnish::htcppurger": varnish_instances => [ "localhost:80", "localhost:3128" ] }

			# Ganglia monitoring
			class { "varnish::monitoring::ganglia": varnish_instances => [ "", "frontend" ] }

			varnish::instance { "upload-backend":
				name => "",
				vcl => "upload-backend",
				port => 3128,
				admin_port => 6083,
				runtime_parameters => $::site ? {
					'esams' => ["prefer_ipv6=on"],
					default => [],
				},
				storage => "-s main-sda3=persistent,/srv/sda3/varnish.persist,${storage_size_main}G -s main-sdb3=persistent,/srv/sdb3/varnish.persist,${storage_size_main}G -s bigobj-sda3=file,/srv/sda3/large-objects.persist,${storage_size_bigobj}G -s bigobj-sdb3=file,/srv/sdb3/large-objects.persist,${storage_size_bigobj}G",
				backends => $::site ? {
					'eqiad' => [ "10.2.1.24", "10.2.1.27", $lvs::configuration::lvs_service_ips[$::realm]['rendering'][$::mw_primary] ],
					'esams' => ["208.80.154.235"],
				},
				directors => $varnish_be_directors[$::site],
				director_type => "random",
				vcl_config => {
					'retry5xx' => 0,
					'cache4xx' => "1m",
					'cluster_tier' => $cluster_tier,
					'upstream_directors' => $upstream_directors
				},
				backend_options => {
					'port' => 80,
					'connect_timeout' => "5s",
					'first_byte_timeout' => "35s",
					'between_bytes_timeout' => "4s",
					'max_connections' => 1000,
				},
				wikimedia_networks => $network::constants::all_networks,
				xff_sources => $network::constants::all_networks
			}

			varnish::instance { "upload-frontend":
				name => "frontend",
				vcl => "upload-frontend",
				port => 80,
				admin_port => 6082,
				storage => "-s malloc,${memory_storage_size}G",
				backends => flatten(values($varnish_fe_directors[$::site])),
				directors => $varnish_fe_directors[$::site],
				director_type => "chash",
				vcl_config => {
					'retry5xx' => 0,
					'cache4xx' => "1m",
					'cluster_tier' => $cluster_tier,
				},
				backend_options => {
					'port' => 3128,
					'connect_timeout' => "5s",
					'first_byte_timeout' => "35s",
					'between_bytes_timeout' => "2s",
					'max_connections' => 100000,
					'probe' => "varnish",
					'weight' => 20,
				},
				xff_sources => $network::constants::all_networks,
			}

			varnish::logging { "locke" : listener_address => "208.80.152.138" , cli_args => "-m RxRequest:^(?!PURGE\$) -D" }
			varnish::logging { "emery" : listener_address => "208.80.152.184" , cli_args => "-m RxRequest:^(?!PURGE\$) -D" }
			varnish::logging { "multicast_relay" : listener_address => "208.80.154.15" , port => "8419", cli_args => "-m RxRequest:^(?!PURGE\$) -D" }

			# HTCP packet loss monitoring on the ganglia aggregators
			if $ganglia_aggregator == "true" and $::site != "esams" {
				include misc::monitoring::htcp-loss
			}
		}
		else {
			# Squid
			class { "role::cache::squid::common": role => "upload" }
		}
	}

	class bits {
		include network::constants

		$cluster = "cache_bits"
		$nagios_group = "cache_bits_${::site}"

		include lvs::configuration

		class { "lvs::realserver": realserver_ips => $lvs::configuration::lvs_service_ips[$::realm]['bits'][$::site] }

		$bits_appservers = {
			'pmtpa' => [ "srv248.pmtpa.wmnet", "srv249.pmtpa.wmnet", "mw60.pmtpa.wmnet", "mw61.pmtpa.wmnet" ],
			'eqiad' => [ "mw1149.eqiad.wmnet", "mw1150.eqiad.wmnet", "mw1151.eqiad.wmnet", "mw1152.eqiad.wmnet" ],
		}
		$test_wikipedia = $::realm ? {
			"production" => [ "srv193.pmtpa.wmnet" ],
			"labs" => [ '10.4.0.166' ],
		}
		# FIXME: need 'flatten' here
		$all_backends = [ "srv248.pmtpa.wmnet", "srv249.pmtpa.wmnet", "mw60.pmtpa.wmnet", "mw61.pmtpa.wmnet", "srv193.pmtpa.wmnet",
		 	"mw1149.eqiad.wmnet", "mw1150.eqiad.wmnet", "mw1151.eqiad.wmnet", "mw1152.eqiad.wmnet" ]

		if( $::realm == 'production' ) {
			$varnish_backends = $::site ? {
				/^(pmtpa|eqiad)$/ => $all_backends,
				# [ bits-lb.pmtpa, bits-lb.eqiad ]
				'esams' => [ "208.80.152.210", "208.80.154.234" ],
				default => []
			}
		} else {
			# beta on labs
			$varnish_backends = [
				'10.4.0.166', # deployment-apache32
				'10.4.0.187', # deployment-apache33
			]
		}

		# FIXME: stupid hack to unbreak hashes-in-selectors in puppet 2.7
		$multiple_backends = {
			'pmtpa-eqiad' => {
				"backend" => $bits_appservers['eqiad'],
				"eqiad_bits" => $bits_appservers['eqiad'],
				"test_wikipedia" => $test_wikipedia,
				},
			'esams' => {
				"backend" => $varnish_backends,
			}
		}
		$test_hostname = $::site ? {
			'pmtpa' => 'test.wikipedia.org',
			'eqiad' => 'test.wikipedia.org',
			'esams' => false,
			default => false,
		}

		if( $::realm == 'production' ) {
			# Whenever altering this options, please reflect the modification
			#	to the labs options too.
			$cluster_options = {
				'test_hostname' => $test_hostname,
				'enable_geoiplookup' => true,
			}
		} else {
			$cluster_options = {
				'test_hostname' => $test_hostname,
				'test_server' => $test_wikipedia,
				'enable_geoiplookup' => true,

				# Labs specific options:
				'top_domain' => 'beta.wmflabs.org',
				'bits_domain' => 'bits.beta.wmflabs.org',
			}
		}

		if( $::realm == 'production' ) {
			$varnish_directors = $::site ? {
				/^(pmtpa|eqiad)$/ => $multiple_backends["pmtpa-eqiad"],
				'esams' => $multiple_backends["esams"],
			}
		} else {
			# beta on labs
			$varnish_directors = {
				"test_wikipedia" => $test_wikipedia,
				"backend" => $varnish_backends
			}
		}

		if( $::realm == 'production' ) {
			$event_listener = $::site ? {
				/^(pmtpa|eqiad)$/ => '10.64.21.123', # vanadium
				'esams' => '208.80.154.15', # oxygen
			}
			varnish::logging { "vanadium" : listener_address => $event_listener,
				port => "8422",
				instance_name => "",
				cli_args => '-m RxURL:^/event\.gif\?. -D',
				log_fmt => "%q %l %n %t %h",
				monitor => false,
			}
			varnish::logging { "kraken" :
				listener_address => '208.80.154.154', # analytics1001
				port => "8422",
				instance_name => "",
				cli_args => '-m RxURL:^/event\.gif\?. -D',
				log_fmt => "%U	%q	%{Host}i	%t	%h	%{X-Forwarded-For}i	%{Referer}i	%{Accept-Language}i	%{Cookie}i	%{X-WAP-Profile}i	%{User-agent}i	%l	%n",
				monitor => false,
			}
		}

		system_role { "role::cache::bits": description => "bits Varnish cache server" }

		require geoip

		include standard,
			varnish::monitoring::ganglia

		varnish::instance { "bits":
			name => "",
			vcl => "bits",
			port => 80,
			admin_port => 6082,
			storage => "-s malloc,2G",
			backends => $varnish_backends,
			directors => $varnish_directors,
			director_type => "random",
			vcl_config => {
				'retry5xx' => 1,
				'cache4xx' => "1m",
			},
			backend_options => {
				'port' => 80,
				'connect_timeout' => "5s",
				'first_byte_timeout' => "35s",
				'between_bytes_timeout' => "4s",
				'max_connections' => 10000,
				'probe' => "bits",
			},
			cluster_options => $cluster_options,
			xff_sources => $network::constants::all_networks
		}

		#varnish::udplogger {
		#	"linne":
		#		host => "linne.wikimedia.org";
		#	"emery":
		#		host => "emery.wikimedia.org";
		#}

		cron { "session leak":
			command => "test $(varnishstat -1 -f n_sess_mem | awk '{ print \$2 }') -gt 150000 && service varnish restart > /var/log/varnish-restarts",
			user => root,
			ensure => absent;
		}
	}

	class mobile {
		include network::constants

		$cluster = "cache_mobile"
		$nagios_group = "cache_mobile_${::site}"

		include lvs::configuration
		class { "lvs::realserver": realserver_ips => $lvs::configuration::lvs_service_ips[$::realm]['mobile'][$::site] }

		$varnish_fe_backends = $::site ? {
			"eqiad" => [ "cp1041.eqiad.wmnet", "cp1042.eqiad.wmnet",
				"cp1043.wikimedia.org", "cp1044.wikimedia.org" ],
			default => []
		}
		$varnish_fe_directors = {
			"pmtpa" => {},
			"eqiad" => { "backend" => $varnish_fe_backends },
			"esams" => {},
		}

		system_role { "role::cache::mobile": description => "mobile Varnish cache server" }

		include standard,
			nrpe

		# FIXME: remove after precise migration
		if $::lsbdistid == "Ubuntu" and versioncmp($::lsbdistrelease, "12.04") >= 0 {
			varnish::setup_filesystem{ ["sda3", "sdb3"]:
				before => Varnish::Instance["mobile-backend"]
			}
		}

		class { "varnish::htcppurger": varnish_instances => [ "localhost:80", "localhost:81" ] }

		# Ganglia monitoring
		class { "varnish::monitoring::ganglia": varnish_instances => [ "", "frontend" ] }

		varnish::instance { "mobile-backend":
			name => "",
			vcl => "mobile-backend",
			port => 81,
			admin_port => 6083,
			storage => $::hostname ? {
				/^cp104[12]$/ => "-s sda3=persistent,/srv/sda3/varnish.persist,100G -s sdb3=persistent,/srv/sdb3/varnish.persist,100G",
				default => "-s file,/a/sda/varnish.persist,50% -s file,/a/sdb/varnish.persist,50%",
			},
			backends => [ $lvs::configuration::lvs_service_ips[$::realm]['apaches'][$::mw_primary] ],
			directors => { "backend" => [ $lvs::configuration::lvs_service_ips[$::realm]['apaches'][$::mw_primary] ] },
			director_options => {
				'retries' => 2,
			},
			vcl_config => {
				'retry5xx' => 1,
			},
			backend_options => {
				'port' => 80,
				'connect_timeout' => "5s",
				'first_byte_timeout' => "35s",
				'between_bytes_timeout' => "4s",
				'max_connections' => 600,
				},
			cluster_options => {
				'api_backend' => $lvs::configuration::lvs_service_ips[$::realm]['api'][$::mw_primary],
			},
			xff_sources => $network::constants::all_networks
		}

		varnish::instance { "mobile-frontend":
			name => "frontend",
			vcl => "mobile-frontend",
			port => 80,
			admin_port => 6082,
			backends => $varnish_fe_backends,
			directors => $varnish_fe_directors[$::site],
			director_options => {
				'retries' => 40,
			},
			director_type => "chash",
			vcl_config => {
				'retry5xx' => 0,
			},
			backend_options => {
				'port' => 81,
				'connect_timeout' => "5s",
				'first_byte_timeout' => "35s",
				'between_bytes_timeout' => "2s",
				'max_connections' => 100000,
				'probe' => "varnish",
			},
			xff_sources => $network::constants::all_networks,
		}

		varnish::logging { "locke" : listener_address => "208.80.152.138", cli_args => "-m RxRequest:^(?!PURGE\$) -D" }
		varnish::logging { "emery" : listener_address => "208.80.152.184", cli_args => "-m RxRequest:^(?!PURGE\$) -D" }
		varnish::logging { "multicast_relay" : listener_address => "208.80.154.15", port => "8419", cli_args => "-m RxRequest:^(?!PURGE\$) -D" }
	}
}
