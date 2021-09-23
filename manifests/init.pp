# Class: dnsdist
#
# This class installs and manages dnsdist
#
# Author
#   Michiel Piscaer <michiel@piscaer.com>
#
# Version
#   0.1   Initial release
#
# Parameters:
#   $webserver = '0.0.0.0:80',
#   $webserver_pass = 'geheim'
#   $control_socket = '127.0.0.1'
#   $listen_addresess = '0.0.0.0'
#
# Requires:
#   concat
#   apt
#
# Sample Usage:
#
#   class { 'dnsdist':
#    webserver        => '192.168.1.1:80',
#    listen_addresess => [ '192.168.1.1' ];
#  }
#
class dnsdist (
  $version          = $dnsdist::params::version,
  $webserver        = $dnsdist::params::webserver,
  $webserver_pass   = $dnsdist::params::webserver_pass,
  $webserver_acl    = "127.0.0.1",
  $api_key          = $dnsdist::params::api_key,
  $control_socket   = $dnsdist::params::control_socket,
  $control_socket_key = $dnsdist::params::control_socket_key,
  $listen_addresess = $dnsdist::params::listen_addresess,
  $cache_enabled    = $dnsdist::params::cache_enabled,
  $cache_size       = $dnsdist::params::cache_size,
  $metrics_enabled  = $dnsdist::params::metrics_enabled,
  $metrics_host     = $dnsdist::params::metrics_host,
  $os               = $dnsdist::params::os,
  $use_upstream_package_source = $dnsdist::params::use_upstream_package_source,
  ) inherits dnsdist::params
{

  if ($use_upstream_package_source) {

    apt::pin { 'dnsdist':
      origin   => 'repo.powerdns.com',
      priority => '600',
    }

    apt::key { 'powerdns':
      ensure => present,
      id     => '9FAAA5577E8FCF62093D036C1B0C6205FD380FBB',
      source => 'https://repo.powerdns.com/FD380FBB-pub.asc',
      server => 'keyserver.ubuntu.com'
    }

    apt::source { 'repo.powerdns.com':
      ensure       => present,
      location     => "http://repo.powerdns.com/${os}",
      repos        => 'main',
      release      => "${::lsbdistcodename}-dnsdist-${version}",
      architecture => 'amd64',
      require      => [Apt::Key['powerdns'], Apt::Pin['dnsdist']],
    }

    Apt::Source['repo.powerdns.com'] ~> Class['apt::update'] -> Package['dnsdist']
  }

  package { 'dnsdist':
    ensure  => present,
    provider => 'apt',
  }

  concat { '/etc/dnsdist/dnsdist.conf' :
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['dnsdist'],
    require => [Package['dnsdist']],
  }

  concat::fragment { 'global-header':
    target  => '/etc/dnsdist/dnsdist.conf',
    content => template('dnsdist/dnsdist.conf-header.erb'),
    order   => '10';
  }

  concat::fragment { 'acl-header':
    target  => '/etc/dnsdist/dnsdist.conf',
    content => 'setACL({',
    order   => '40';
  }

  concat::fragment { 'acl-footer':
    target  => '/etc/dnsdist/dnsdist.conf',
    content => "})\n",
    order   => '49';
  }

  service { 'dnsdist':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => [Concat['/etc/dnsdist/dnsdist.conf']],
  }
}
