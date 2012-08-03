define network::route (
  $dest,
  $gateway,
  $device,
  $netmask = false,
  $order = '00'
  ) {

  case $::operatingsystem {
    /(?i-mx:debian|ubuntu)/: {
      concat::fragment {
        "network-route-${name}-up":
          target => '/etc/network/if-up.d/static-routes',
          content => inline_template('route add -net <%= dest %><% if netmask %> netmask <%= netmask %><% end %> gw <%= gateway %> dev <%= device %>\n');
        "network-route-${name}-down":
          target => '/etc/network/if-down.d/static-routes',
          content => inline_template('route del -net <%= dest %><% if netmask %> netmask <%= netmask %><% end %> gw <%= gateway %> dev <%= device %>\n');
      }
    }
    /(?i-mx:redhat|centos)/: {
      concat::fragment { "network-route-$name":
        target => "/etc/sysconfig/network-scripts/route-${device}",
        content => "$dest via $gateway",
        order => $order,
      }
    }
  }
}
