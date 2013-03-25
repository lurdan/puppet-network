class network::config::redhat (
  $ipv6 = false,
  $zeroconf = false,
  $vlan = false,
  ) {

  concat { '/etc/sysconfig/network':
    mode => 600,
  }
  concat::fragment { 'network-default':
    target => '/etc/sysconfig/network',
    content => template('network/redhat/network.erb'),
  }

  if $vlan {
    @module-init-tools::module { '8021q':
      before => Concat::Fragment['network-vlan'],
    }
    concat::fragment { 'network-vlan':
      target => '/etc/sysconfig/network',
      content => "VLAN=yes\nVLAN_NAME_TYPE=$vlan",
    }
  }
}
