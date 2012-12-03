define network::interface (
  $address      = 'dhcp',
  $netmask      = '255.255.255.0',
  $macaddress   = false,
  $network      = false,
  $broadcast    = false,
  $gateway      = false,
  $enable       = 'true',
  $ipv6         = false,
  $physdev      = false, #only for RHEL
  $bond_master  = false, #only for RHEL, internal use
  $bond_slaves  = false,
  $bond_mode    = false, #'active-backup',
  $bond_options = false #'    bond-miimon 100
#    bond-downdelay 200
#    bond-updelay 200'
  ) {

  case $::osfamily {
    'Debian': {
      concat::fragment { "network-interface-$name":
        target => '/etc/network/interfaces',
        content => template('network/debian/interface.erb'),
      }
    }
    'RedHat': {

      file { "/etc/sysconfig/network-scripts/ifcfg-$name":
        mode => 600,
        content => template('network/redhat/ifcfg.erb'),
      }
      concat { "/etc/sysconfig/network-scripts/route-$name": }

      if $gateway {
        concat::fragment { "network-gateway-$name":
          target => '/etc/sysconfig/network',
          content => "GATEWAY=$gateway",
        }
      }

      if $bond_slaves {
        module-init-tools::config::modprobe { 'bonding':
          content => "alias bond0 bonding\noptions bonding mode=${bond_mode} ${bond_options}",
        }

        # physical interface
        $slaves = split($bond_slaves, ' ')
        network::interface::redhat::bond_slave { $slaves:
          bond_master => "$name",
#          macaddress => $macaddress,
        }
      }
    }
  }
}

define network::interface::redhat::bond_slave (
  $bond_master,
  $macaddress = false
  ) {
  network::interface { "$name":
    address => false,
    bond_master => $bond_master,
#    macaddress => $macaddress,
  }
}

