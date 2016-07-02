class { '::consul':
  manage_group => false,
  version => '0.6.4',
 config_hash => {
    'data_dir'         => '/opt/consul',
    'datacenter'       => 'vagrant',
    'log_level'        => 'INFO',
    'node_name'        => 'agent',
    'addresses'         => { 'http' => '172.16.0.3'},
    'advertise_addr'   => '172.16.0.3',
    'retry_join'       => ['172.16.0.2'],
  }
}
Archive {
  require => Package['unzip'],
}
package { 'unzip': 
  ensure => latest,
}

package { 'iptables-services': 
  ensure => latest,
  before => Resources['firewall'],
}
package { 'bind-utils':
  ensure => latest,
  }
  resources { 'firewall':
     purge => true,
   }

class { 'apache': }->
file { '/var/www/html/index.html': 
ensure => file,
content => 'Agent.'
}
::consul::service { 'web':
  checks  => [
    {
      script   => 'curl localhost:80',
      interval => '10s'
    }
  ],
  port    => 80,
  tags    => ['web']
}
