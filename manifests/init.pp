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
  case $::osfamily {
    'Debian': {
      class {
        'network::package::debian':
          bonding => $bonding,
          vlan => $vlan;
        'network::config::debian':
          notify => Service['network'],
          require => Class['network::package::debian'];
      }
    }
    'Redhat': {
      class {
        'network::package::redhat':
          vlan => $vlan;
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
    name => $::osfamily ? {
      'Debian' => 'networking',
      default => 'network',
    },
    hasstatus => false,
    status => '/bin/true',
    ensure => running,
  }
  Network::Interface <| |> -> Service['network']
}

