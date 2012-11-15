class analytics::jmxtrans {
	# set up jmx monitoring for kafka.
	# include jmxtrans
	include jmxtrans

	# set the default output writer to ganglia.
	Jmxtrans::Metrics {
		ganglia => "239.192.1.32:8649",	
	}
}

class kafka::jmxtrans inherits analytics::jmxtrans {
	# query kafka for jmx metrics
	jmxtrans::metrics { "kafka-$hostname":
		jmx     => "$fqdn:9999",
		queries => [ 
			{
				"obj"    => "kafka:type=kafka.BrokerAllTopicStat",
				"attr"   => [ "BytesIn", "BytesOut", "FailedFetchRequest", "FailedProduceRequest", "MessagesIn" ]
			},
			{
				"obj"    => "kafka:type=kafka.LogFlushStats",
				"attr"   => [ "AvgFlushMs", "FlushesPerSecond", "MaxFlushMs", "NumFlushes", "TotalFlushMs" ]
			},
			{
				"obj"    => "kafka:type=kafka.SocketServerStats",
				"attr"   => [ 
				"AvgFetchRequestMs",
				"AvgProduceRequestMs",
				"BytesReadPerSecond",
				"BytesWrittenPerSecond",
				"FetchRequestsPerSecond",
				"MaxFetchRequestMs",
				"MaxProduceRequestMs",
				"NumFetchRequests",
				"NumProduceRequests",
				"ProduceRequestsPerSecond",
				"TotalBytesRead",
				"TotalBytesWritten",
				"TotalFetchRequestMs",
				"TotalProduceRequestMs"
				]
			}
		]
	}
}