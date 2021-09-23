# Class: dnsdist::params
# defaults.

class dnsdist::params {
  $version          = '13'
  $webserver        = '0.0.0.0:80'
  $webserver_pass   = 'geheim'
  $api_key          = undef
  $control_socket   = '127.0.0.1'
  $control_socket_key  = undef
  $listen_addresess = ['0.0.0.0']
  $cache_enabled    = false
  $cache_size       = 10000
  $metrics_enabled  = false
  $metrics_host     = '127.0.0.1'
  $os               = downcase($facts['os']['name'])
  $use_upstream_package_source = true
}
