class bacula::sd (
                    $manage_package        = true,
                    $package_ensure        = 'installed',
                    $manage_service        = true,
                    $manage_docker_service = true,
                    $service_ensure        = 'running',
                    $service_enable        = true,
                    $sdname                = $::fqdn,
                    $port                  = '9103',
                    $max_concurrent_jobs   = '20',
                    $sdaddr                = undef,
                    $director_name         = $::fqdn,
                    $director_password     = 'dmlzY2EgY2F0YWx1bnlhIGxsaXVyZQo',
                  ) inherits bacula::params{

  validate_re($package_ensure, [ '^present$', '^installed$', '^absent$', '^purged$', '^held$', '^latest$' ], 'Not a supported package_ensure: present/absent/purged/held/latest')

  class { '::bacula::sd::install': } ->
  class { '::bacula::sd::config': } ~>
  class { '::bacula::sd::service': } ->
  Class['::bacula::fd']
}
