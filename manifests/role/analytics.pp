# role/analytics.pp
@monitor_group { "analytics-eqiad": description => "analytics servers in eqiad" }

# Role classes for Analytics and Kraken services.
#
# This file contains base classes and final includable classes.
# The includable role classes are:
#
#   role::analytics::frontend         - Front end Kraken interfaces (hue, oozie, etc.)
#   role::analytics::hadoop::master   - Hadoop master services (namenode, resourcemanager, jobhistory, etc.)
#   role::analytics::hadoop::worker   - Hadoop worker services (datanode, nodemanager)
#   role::analytics::kafka            - Kafka Broker
#   role::analytics::public           - Machines with public facing IP addresses act as proxies to backend services.
#   role::analytics::storm::master    - Storm Nimubs Server
#   role::analytics::storm::worker    - Storm Supervisor Server
#   role::analytics::zookeeper        - Zookeeper Server
#

# == Class role::analytics::public
# Sets up a proxy from the public web interface in the Analytics Cluster
class role::analytics::public inherits role::analytics {
	include kraken::proxy
	include kraken::misc::web
}

# == Class role::analytics::frontend
# Frontend web services for Analytics Cluster.
# E.g. Hue, Oozie, etc.
class role::analytics::frontend inherits role::analytics {
	# include the kraken index.php file.
	# TODO:  Puppetize webserver classes.
	include kraken::misc::web

	# Oozie server
	include kraken::oozie::server
	# Hive metastore and hive server
	include kraken::hive::server

	# Hue server
	class { "kraken::hue": }
	# TODO: require this when we back in the real production branch
		# require => Class["role::ldap::client::labs"],
	# }
}


# == Class role::analytics::zookeeper
# Zookeeper Server Role
class role::analytics::zookeeper inherits role::analytics {
	# zookeeper server
	include kraken::zookeeper::server
}


# == Class role::analytics::kafka
# Kafka Broker Server role
class role::analytics::kafka inherits role::analytics {
	include kraken::kafka::server
}



# == Class role::analytics::udp2log::event
# Reads from the /event log stream coming from
# Varnish servers and produces the messages to Kafka.
class role::analytics::udp2log::event inherits role::analytics::udp2log {
	# /event log stream udp2log instance.
	# This udp2log instance has filters
	# to produce into Kafka.
	misc::udp2log::instance { "event":
		port                => "8422",
		log_directory       => "/var/log/udp2log/event",
		logrotate           => false,
		monitor_packet_loss => false,
		# event.filters.erb uses a Kafka producer
		# wrapper script in the Kraken repository.
		require => Class["kraken::repository"],
	}

	# use jmxtrans to push Kafka Producer stats to Ganglia
	include kraken::monitoring::kafka::producer::event
}

# == Class role::analytics::udp2log::event
# Reads from the blog udp2log log stream coming from
# marmontel.wikimedia.org and produces the messages to Kafka.
class role::analytics::udp2log::blog inherits role::analytics::udp2log {
	# blog log stream udp2log instance.
	misc::udp2log::instance { "blog":
		port                => "8411",
		log_directory       => "/var/log/udp2log/blog",
		logrotate           => false,
		monitor_packet_loss => false,
		# event.filters.erb uses a Kafka producer
		# wrapper script in the Kraken repository.
		require => Class["kraken::repository"],
	}

	# use jmxtrans to push Kafka Producer stats to Ganglia
	include kraken::monitoring::kafka::producer::blog
}

# == Class role::analytics::udp2log::event
# Reads from the /event log stream coming from
# Varnish servers and produces the messages to Kafka.
class role::analytics::udp2log::webrequest($producer_id, $producer_count) inherits role::analytics::udp2log {
	# Starts a multicast listening udp2log instance
	# to read from the request log firehose.
	# Many filters produce into Kafkas
	misc::udp2log::instance { "webrequest":
		port                => "8420",
		multicast           => true,
		log_directory       => "/var/log/udp2log/webrequest",
		logrotate           => false,
		template_variables  => {
			'producer_count' => $producer_count,
			'producer_id'    => $producer_id,
		},
		# webrequest.filters.erb uses a Kafka producer
		# wrapper script in the Kraken repository.
		require => Class["kraken::repository"],
	}

	# use jmxtrans to push Kafka Producer stats to Ganglia
	include kraken::monitoring::kafka::producer::webrequest
}


# == role::analytics::kafka::consumer
# Installs cron jobs to consume from Kafka into hadoop
class role::analytics::kafka::consumer {
	$raw_log_hdfs_path        = "/wmf/raw"
	$event_log_hdfs_path      = "$raw_log_hdfs_path/event"
	$webrequest_log_hdfs_path = "$raw_log_hdfs_path/webrequest"

	# consume event logs daily.
	kraken::kafka::consumer::hadoop { "event":
		topics          => "^event",
		regex           => true,
		consumer_group  => "kconsumer0",
		hdfs_output_dir => $event_log_hdfs_path,
		minute          => "0",
		hour            => "6",
		frequency       => "0",  # daily
	}

	# Consume each webrequest log hourly
	# except for wikipedia-mobile.  That is currently
	# being consumed hourly
	kraken::kafka::consumer::hadoop { "webrequest":
		topics          => "'^(webrequest(?!-wikipedia-mobile))'",
		regex           => true,
		consumer_group  => "kconsumer0",
		hdfs_output_dir => $webrequest_log_hdfs_path,
		minute          => "30",
		hour            => "*/1",
		frequency       => "60",   # hourly
	}

	# Consume wikipedia-mobile logs every 15 minutes
	kraken::kafka::consumer::hadoop { "webrequest-wikipedia-mobile":
		topics          => "webrequest-wikipedia-mobile",
		regex           => false,
		consumer_group  => "kconsumer0",
		hdfs_output_dir => $webrequest_log_hdfs_path,
		minute          => "*/15",
		frequency       => "15",   # every 15 minutes
	}
}

# Storm roles

# == Class role::analytics::storm::master
# Storm Nimbus Server role
class role::analytics::storm::master inherits role::analytics {
	include kraken::storm::master
	# Storm UI server
	include kraken::storm::frontend
}

# == Class role::analytics::storm::worker
# Storm Supervisor Server role
class role::analytics::storm::worker inherits role::analytics {
	include kraken::storm::worker
}


# Hadoop roles

# == Class role::analytics::hadoop::master
# Hadoop NameNode and ResourceManager
class role::analytics::hadoop::master inherits role::analytics::hadoop {
	include kraken::hadoop::master
}

# == Class role::analytics::hadoop::worker
# Hadoop DataNode and NodeManager
class role::analytics::hadoop::worker inherits role::analytics::hadoop {
	include kraken::hadoop::worker
}

# Base role classes

# == Class role::analyics
# Base analytics role class.
# All analytics nodes use this role or a 
# role that inherits from it.
class role::analytics {
	system_role { "role::analytics": description => "analytics server" }
	$nagios_group = "analytics-eqiad"
	# ganglia cluster name.
	$cluster = "analytics"

	# include standard,
	include admins::roots,
		accounts::diederik,
		accounts::dsc,
		accounts::otto,
		accounts::dartar,
		accounts::erosen,
		accounts::olivneh,
		accounts::erik,
		accounts::dandreescu,
		accounts::spetrea # per RT4402

	sudo_user { [ "diederik", "dsc", "otto" ]: privileges => ['ALL = (ALL) NOPASSWD: ALL'] }

	# Install Sun/Oracle Java JDK on analytics cluster
	java { "java-6-oracle": 
		distribution => 'oracle',
		version      => 6,
	}

	# We want to be able to geolocate IP addresses
	include geoip

	# udp-filter is a useful thing!
	include misc::udp2log::udp_filter

	# git-core jajajaj
	include generic::packages::git-core

	# include default kraken classes, woohoo!
	include kraken
}

# == Class role::analytics::hadoop
# Base hadoop role class.  All hadoop
# nodes use a role class that inhertit from this.
class role::analytics::hadoop inherits role::analytics {
	# hadoop metrics is common to all hadoop nodes
	class { "kraken::hadoop::metrics":
		require => Class["kraken::hadoop::config"],
	}
}

# == Class role::analytics::udp2log inherits role::analytics
# Base class for analytics udp2log classes
class role::analytics::udp2log inherits role::analytics {
	include kraken::kafka::client
	include misc::udp2log

	# add the udp2log user to the kafka group
	exec { "udp2log_add_to_group_kafka":
		command => "/usr/sbin/usermod -a -G kafka udp2log",
		unless  => "/usr/bin/groups udp2log | grep -q kafka",
		require => [Class["misc::udp2log"], Class["kraken::kafka::client"]],
	}

	# Set defaults for udp2log instances
	Misc::Udp2log::Instance { 
		monitor_packet_loss => true,
		monitor_processes   => true,
		monitor_log_age     => false,
		require             => [Class["kraken::kafka::client"], Class["misc::udp2log"], Exec["udp2log_add_to_group_kafka"]],
	}
}
