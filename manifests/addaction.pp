# Define: dnsdist::addaction
#
#  Manages the actions of dnsdist
#
# Author
#   Michiel Piscaer <michiel@piscaer.com>
#
# Version
#   0.1   Initial release
#
# Parameters:
#   $action
#   $order
# Requires:
#
# Sample Usage:
#
#   dnsdist::addaction {
#     'adddelay_0ms_at_300_qps':
#       action => 'addDelay(MaxQPSIPRule(300, 32, 48), 0)',
#       order  => 1;
#   }
#
define dnsdist::addaction ($action, $order) {
  concat::fragment { "addAction-${order}-${title}":
    target  => '/etc/dnsdist/dnsdist.conf',
    content => "${action}\n",
    order   => '50',
  }
}
