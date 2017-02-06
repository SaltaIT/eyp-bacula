class bacula::fd (
                    $manage_package        = true,
                    $package_ensure        = 'installed',
                    $manage_service        = true,
                    $manage_docker_service = true,
                    $service_ensure        = 'running',
                    $service_enable        = true,
                    $port                  = '9102',
                    $fdname                = "fd-${::fqdn}",
                    $director_name         = 'bacula-dir',
                    $director_password     = 'dmlzY2EgY2F0YWx1bnlhIGxsaXVyZQo',
                    $max_concurrent_jobs   = '20',
                    $plugin_dir            = undef,
                    $fdaddr                = undef,
                  ) inherits bacula::params{

  validate_re($package_ensure, [ '^present$', '^installed$', '^absent$', '^purged$', '^held$', '^latest$' ], 'Not a supported package_ensure: present/absent/purged/held/latest')

  class { '::bacula::fd::install': } ->
  class { '::bacula::fd::config': } ~>
  class { '::bacula::fd::service': } ->
  Class['::bacula::fd']
}
