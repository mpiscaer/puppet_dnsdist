# Define: dnsdist::newserver
#
#  Manages the backend servers of dnsdist
#
# Author
#   Michiel Piscaer <michiel@piscaer.com>
#
# Version
#   0.1   Initial release
#
# Parameters:
#   $forward_adres
#   $pool
#   $resolver_name
# Requires:
#
# Sample Usage:
#
#   dnsdist::newserver {
#     '192.168.2.1':
#       pool => 'local',
#       resolver_name = 'ns1';
#   }
#
define dnsdist::newserver ($forward_adres = $title, $pool = undef, $resolver_name = undef) {
  concat::fragment { "newserver-${pool}-${forward_adres}":
    target  => '/etc/dnsdist/dnsdist.conf',
    content => template('dnsdist/newServer.erb'),
    order   => '20',
  }
}
