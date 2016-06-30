class nginx {

case $::osfamily {
'redhat','debian' : {
$package = 'nginx'
$owner = 'root'
$group = 'root'
$docroot = '/var/www'
$confdir = '/etc/nginx'
$logdir = '/var/log/nginx'
}
'windows' : {
$package = 'nginx-service'
$owner = 'Administrator'
$group = 'Administrators'
$docroot = 'C:/ProgramData/nginx/html'
$confdir = 'C:/ProgramData/nginx'
$logdir = 'C:/ProgramData/nginx/logs'
}
default : {
fail("Module ${module_name} is not supported on ${::osfamily}")
}
}

# user the service will run as. Used in the nginx.conf.erb template
$user = $::osfamily ? {
'redhat' => 'nginx',
'debian' => 'www-data',
'windows' => 'nobody',
}

File {
owner => 'root',
group => 'root',
mode => '0664',
}

#package { 'nginx':
package { $package:
ensure => present,
}

#file { [ '/var/www', '/etc/nginx/conf.d' ]:
file { [ $docroot, "${confdir}/conf.d" ]:
ensure => directory,
}

#file { '/var/www/index.html':
file { "${docroot}/index.html":
ensure => file,
source => 'puppet:///modules/nginx/index.html',
}


#file { '/etc/nginx/nginx.conf':
#ensure => file,
#source => 'puppet:///modules/nginx/nginx.conf',
#require => Package['nginx'],
#notify => Service['nginx'],
#}
file { "${confdir}/nginx.conf":
ensure => file,
content => template('nginx/nginx.conf.erb'),
notify => Service['nginx'],
}



#file { '/etc/nginx/conf.d/default.conf':
#ensure => file,
#source => 'puppet:///modules/nginx/default.conf',
##require => Package['nginx'],
#}
file { "${confdir}/conf.d/default.conf":
ensure => file,
content => template('nginx/default.conf.erb'),
notify => Service['nginx'],
}

service { 'nginx':
ensure => running,
enable => true,
}
}



