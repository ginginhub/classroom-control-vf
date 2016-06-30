if $::osfamily == 'Windows'{
 Package {
    provider => chocolately,
    }
}
include nginx
