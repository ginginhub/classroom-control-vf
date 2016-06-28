class skeleton {

file {'/etc/skel':
ensure=>directory,
owner =>'root',
group => 'root',
mode => '0755',
}

#files will be in modules:  skeleton/files/bashrc 
file { '/etc/skel/.bashrc':
ensure => file,
owner => 'root',
group => 'root',
mode => '0644',
source => 'puppet:///modules/skeleton/bashrc',
}

}
