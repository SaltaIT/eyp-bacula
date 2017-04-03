class bacula::bconsole(
                        $manage_package    = true,
                        $package_ensure    = 'installed',
                        $director_name     = $::fqdn,
                        $director_password = 'dmlzY2EgY2F0YWx1bnlhIGxsaXVyZQo',
                        $director_port     = '9101',
                        $director_address  = '127.0.0.1',
                      ) inherits bacula::params{

  validate_re($package_ensure, [ '^present$', '^installed$', '^absent$', '^purged$', '^held$', '^latest$' ], 'Not a supported package_ensure: present/absent/purged/held/latest')

  class { '::bacula::bconsole::install': }
  -> class { '::bacula::bconsole::config': }
  -> Class['::bacula::bconsole']
}
