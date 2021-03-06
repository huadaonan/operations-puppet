define apt::repository(
	$uri,
	$dist,
	$components,
	$source=true,
	$comment_old=false,
	$keyfile='',
	$ensure=present
) {
	$binline = "deb ${uri} ${dist} ${components}\n"
	$srcline = $source ? {
		true    => "deb-src ${uri} ${dist} ${components}\n",
		default => '',
	}

	file { "/etc/apt/sources.list.d/${name}.list":
		ensure  => $ensure,
		owner   => root,
		group   => root,
		mode    => '0444',
		content => "${binline}${srcline}",
	}

	if $comment_old {
		$escuri = regsubst(regsubst($uri, '/', '\/', 'G'), '\.', '\.', 'G')
		$binre = "deb(-src)?\s+${escuri}\s+${dist}\s+${components}"

		# comment out the old entries in /etc/apt/sources.list
		exec { "apt-${name}-sources":
			command => "/bin/sed -ri '/${binre}/s/^deb/#deb/' /etc/apt/sources.list",
			creates => "/etc/apt/sources.list.d/${name}.list",
			before  => File["/etc/apt/sources.list.d/${name}.list"],
		}
	}

	if $keyfile {
		file { "/var/lib/apt/keys/${name}.gpg":
			ensure  => present,
			owner   => root,
			group   => root,
			mode    => '0400',
			source  => $keyfile,
			require => File['/var/lib/apt/keys']
		}

		exec { "/usr/bin/apt-key add /var/lib/apt/keys/${name}.gpg":
			subscribe   => File["/var/lib/apt/keys/${name}.gpg"],
			refreshonly => true,
		}
	}
}
