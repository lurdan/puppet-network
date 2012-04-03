# Class: network
#
# This module manages netbase
#
# Parameters:
#
# Actions:
#
# Requires:
#   concat
#
# Sample Usage:
#
class network (
  $bonding = false,
  $vlan = false
  ) {
  case $::operatingsystem {
    /(?i-mx:debian|ubuntu)/: {
      class {
        'network::package::debian':
          bonding => $bonding,
          vlan => $vlan;
        'network::config::debian':;
      }
    }
    /(?i-mx:redhat|centos)/: {
      class {
        'network::package::redhat':;
        'network::config::redhat':
          vlan => $vlan;
      }
    }
    default: {
      err ('unknown operating system.')
    }
  }

  service { 'networking': }
}

