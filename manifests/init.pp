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
      class { 'network::package::debian':
        bonding => $bonding,
        vlan => $vlan;
      }
      -> class { 'network::config::debian':
        notify => Service['network'],
        require => Class['network::package::debian'];
      }
    }
    'RedHat': {
      class { 'network::package::redhat':
        vlan => $vlan;
      }
      -> class { 'network::config::redhat':
        notify => Service['network'],
        require => Class['network::package::redhat'],
        vlan => $vlan;
      }
    }
    default: {
      err ('unknown operating system.')
    }
  }

  Network::Interface <| |> -> service { 'network':
    name => $::osfamily ? {
      'Debian' => 'networking',
      default => 'network',
    },
    hasstatus => false,
    status => '/bin/true',
    ensure => running,
  }
}
