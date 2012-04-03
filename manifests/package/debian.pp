class network::package::debian (
  $bonding = false,
  $vlan = false
) {
  anchor { 'network::package::debian::start': }
  anchor { 'network::package::debian::end': }

  package { 'ifupdown':
    require => Anchor['network::package::debian::start'],
    before => Anchor['network::package::debian::end'],
  }

  if $bonding {
    package { 'ifenslave-2.6':
      require => Anchor['network::package::debian::start'],
      before => Anchor['network::package::debian::end'],
    }
  }

  if $vlan {
    package { 'vlan':
      require => Anchor['network::package::debian::start'],
      before => Anchor['network::package::debian::end'],
    }
    module-init-tools::module { '8021q':
      require => Package['vlan', 'module-init-tools'],
      notify => Service['networking'],
    }
#    realize (Module-init-tools::Module['8021q'])
  }
}
