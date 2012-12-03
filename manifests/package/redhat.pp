class network::package::redhat ( $vlan = false ) {
  package { 'net-tools': }

  if $vlan {
    package { 'vconfig': }
  }
}
