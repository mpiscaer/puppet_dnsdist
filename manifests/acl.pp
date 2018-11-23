# Define: dnsdist::acl
#
#  Manages the ACL of dnsdist
#
# Author
#   Michiel Piscaer <michiel@piscaer.com>
#
# Version
#   0.1   Initial release
#
# Parameters:
#   $networkadres = $title
#
# Requires:
#
# Sample Usage:
#
#   dnsdist::acl { [
#     '192.168.1.0/24']:
#   }
#
define dnsdist::acl ($networkadres = $title) {
  concat::fragment { "acl-${title}":
    target  => '/etc/dnsdist/dnsdist.conf',
    content => template('dnsdist/ACL.erb'),
    order   => '45',
  }
}
