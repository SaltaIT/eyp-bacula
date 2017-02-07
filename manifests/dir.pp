class bacula::dir (
                    $manage_package        = true,
                    $package_ensure        = 'installed',
                    $manage_service        = true,
                    $manage_docker_service = true,
                    $service_ensure        = 'running',
                    $service_enable        = true,
                    $director_name         = $::fqdn,
                    $max_concurrent_jobs   = '20',
                    $director_password     = 'dmlzY2EgY2F0YWx1bnlhIGxsaXVyZQo',
                    $port                  = '9101',
                    $diraddr               = undef,
                  ) inherits bacula::params {

  validate_re($package_ensure, [ '^present$', '^installed$', '^absent$', '^purged$', '^held$', '^latest$' ], 'Not a supported package_ensure: present/absent/purged/held/latest')

  class { '::bacula::dir::install': } ->
  class { '::bacula::dir::config': } ~>
  class { '::bacula::dir::service': } ->
  Class['::bacula::dir']
}
