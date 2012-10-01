# Class: cdh4::hadoop::config
#
# Installs some Hadoop/HDFS config files.
# This assumes that the mapred_directories
# should be inside of the data_directories.
class cdh4::hadoop::config(
	$dfs_name_dir,
	$dfs_data_dir,
	$mapred_local_dir,
	$namenode_hostname,
	$namenode_port                    = '8020',
	$config_directory                 = '/etc/hadoop/conf',
	$tasktracker_map_tasks_maximum    = 16,
	$tasktracker_reduce_tasks_maximum = 8,
	$tasktracker_node_count           = 9,
	$dfs_block_size                   = 67108864 # 64MB default
	) {
	
	require cdh4::hadoop
	
	# TODO: set default map/reduce tasks
	# automatically based on node stats.
	
	file { "$config_directory/core-site.xml":
		content => template("cdh4/hadoop/core-site.xml.erb")
	}
	
	file { "$config_directory/hdfs-site.xml":
		content => template("cdh4/hadoop/hdfs-site.xml.erb")
	}

	file { "$config_directory/mapred-site.xml":
		content => template("cdh4/hadoop/mapred-site.xml.erb")
	}
}
