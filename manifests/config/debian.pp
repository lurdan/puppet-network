class network::config::debian {
  file { '/etc/network/if-down.d':
    ensure => directory,
    before => Concat['/etc/network/if-down.d/static-routes'],
  }
  concat {
    '/etc/network/interfaces':
      notify => Service['networking'];
    '/etc/network/if-up.d/static-routes':
      notify => Service['networking'],
      warn => 'false',
      mode => 755;
    '/etc/network/if-down.d/static-routes':
      notify => Service['networking'],
      warn => 'false',
      mode => 755;
  }

  concat::fragment {
    'network-interfaces-lo':
      target => '/etc/network/interfaces',
      content => "# The loopback network interface
auto lo
iface lo inet loopback\n\n",
      order => '00';
    'network-route-up-header':
      target => '/etc/network/if-up.d/static-routes',
      content => "#!/bin/sh\n",
      order => '00';
    'network-route-down-header':
      target => '/etc/network/if-down.d/static-routes',
      content => "#!/bin/sh\n",
      order => '00';
  }
}
