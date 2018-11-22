# Define: dnsdist::addpoolrule
#
#  Manages the pools of dnsdist
#
# Author
#   Michiel Piscaer <michiel@piscaer.com>
#
# Version
#   0.1   Initial release
#
# Parameters:
#   $rules
#   $pool
# Requires:
#
# Sample Usage:
#
#   dnsdist::addpoolrule {
#     'pool_name':
#       rules => ['local.', 'intern.', '10.in-addr.arpa', '16.172.in-addr.arpa', '17.172.in-addr.arpa'],
#       pool  => 'local';
#   }
#
define dnsdist::addpoolrule ($rules, $pool) {
  concat::fragment { "addpoolrule-${title}-${pool}":
    target  => '/etc/dnsdist/dnsdist.conf',
    content => template('dnsdist/addPoolRule.erb'),
    order   => '30',
  }
}
