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
        'network::config::debian':
          notify => Service['network'],
          require => Class['network::package::debian'];
      }
    }
    /(?i-mx:redhat|centos)/: {
      class {
        'network::package::redhat':;
        'network::config::redhat':
          notify => Service['network'],
          require => Class['network::package::redhat'],
          vlan => $vlan;
      }
    }
    default: {
      err ('unknown operating system.')
    }
  }

  service { 'network':
    name => $::operatingsystem ? {
      /(?i-mx:debian|ubuntu)/ => 'networking',
      default => 'network',
    },
    ensure => running,
  }
  Network::Interface <| |> -> Service['network']
}

