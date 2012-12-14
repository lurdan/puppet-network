define network::route (
  $dest,
  $gateway,
  $device,
  $netmask = false,
  $order = '00'
  ) {

  case $::osfamily {
    'Debian': {
      concat::fragment {
        "network-route-${name}-up":
          target => '/etc/network/if-up.d/static-routes',
          content => inline_template('route add -net <%= dest %><% if netmask %> netmask <%= netmask %><% end %> gw <%= gateway %> dev <%= device %>
');
        "network-route-${name}-down":
          target => '/etc/network/if-down.d/static-routes',
          content => inline_template('route del -net <%= dest %><% if netmask %> netmask <%= netmask %><% end %> gw <%= gateway %> dev <%= device %>
');
      }
    }
    'RedHat': {
      concat::fragment { "network-route-$name":
        target => "/etc/sysconfig/network-scripts/route-${device}",
        content => inline_template('<%= dest %><% if netmask %>/<%= netmask %><% end %> via <%= gateway %>'),
        order => $order,
      }
    }
  }
}
