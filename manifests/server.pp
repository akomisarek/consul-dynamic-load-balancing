class { '::consul':
  manage_group => false,
  version => '0.6.4',
 config_hash => {
    'bootstrap_expect' => 1,
    'client_addr'      => '0.0.0.0',
    'data_dir'         => '/opt/consul',
    'datacenter'       => 'vagrant',
    'log_level'        => 'INFO',
    'node_name'        => 'server',
    'addresses'        => {'http' => '172.16.0.2'},
    'advertise_addr'   => '172.16.0.2',
    'server'           => true,
    'ui_dir'           => '/opt/consul/ui',
  }
}
Archive {
  require => Package['unzip'],
}
package { 'unzip': 
  ensure => latest,
}
package { 'bind-utils':
  ensure => latest,
  }
package { 'iptables-services': 
  ensure => latest,
  before => Resources['firewall'],
}

  resources { 'firewall':
     purge => true,
   }

  include dnsmasq
dnsmasq::conf { 'consul':
  ensure  => present,
  content => 'server=/consul/127.0.0.1#8600',
} 
file { '/etc/resolv.conf':
 ensure => present,
 content => "nameserver 127.0.0.1\nnameserver 8.8.8.8"
 }

class { 'consul_template': 
  consul_host => '172.16.0.2'
}

class { '::haproxy':}->
consul_template::watch { 'common':
    template      => '/vagrant/haproxy.ctmpl',
    destination   => '/etc/haproxy/haproxy.cfg',
    command       => 'service haproxy restart',
}
