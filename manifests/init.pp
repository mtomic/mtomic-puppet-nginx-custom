# Class: mtomic_puppet_nginx_custom
#
#   This module adds a custom version of Nginx with Purge module, as well as SPDY module.
#
#
class mtomic_puppet_nginx_custom {
	case $::osfamily {
            'Debian': {
              $add_repo_cmd     = '/usr/bin/add-apt-repository -y ppa:brianmercer/nginx'
              $update_repos_cmd = '/usr/bin/apt-get update -y -qq'
        
              exec { 'add_nginx_repo':
                command => $add_repo_cmd,
                notify  => Exec['update_nginx_repos'],
                unless  => '/usr/bin/test -f /etc/apt/sources.list.d/brianmercer-nginx-precise.list'
              }
              exec { 'update_nginx_repos':
                command     => $update_repos_cmd,
                require     => Exec['add_nginx_repo'],
                before      => Package['nginx-custom'],
                refreshonly => true,
              }
            }
        
            default: {
              fail("The nginx-custom module does not support ${::osfamily}.")
            }
        }

        package { 'nginx-custom':
                ensure => present,
        }
}
