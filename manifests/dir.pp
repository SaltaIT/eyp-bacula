class bacula::dir (
                    $manage_package              = true,
                    $package_ensure              = 'installed',
                    $manage_service              = true,
                    $manage_docker_service       = true,
                    $service_ensure              = 'running',
                    $service_enable              = true,
                    $director_name               = $::fqdn,
                    $max_concurrent_jobs         = '20',
                    $director_password           = 'dmlzY2EgY2F0YWx1bnlhIGxsaXVyZQo',
                    $port                        = '9101',
                    $diraddr                     = undef,
                    $bacula_log                  = '/var/log/bacula/bacula.log',
                    $baculalog_frequency         = 'daily',
                    $baculalog_rotate            = '15',
                    $baculalog_size              = '100M',
                    $baculalog_logrotate_ensure  = 'present',
                    $mail_from                   = "bacula@${::fqdn}",
                    $mailto_notification         = "bacula@${::fqdn}",
                    $mailto_operator             = "bacula@${::fqdn}",
                    $mailto_daemon_notifications = "bacula@${::fqdn}",
                    $notification_subject        = 'Bacula: %t %e of %c %l',
                    $operator_subject            = 'Bacula: Intervention needed for %j',
                    $daemon_subject              = 'Bacula daemon message',
                    $debug_level                 = undef,
                    $setup_mysql                 = true,
                    $root_db_password            = 'dmlzY2EgY2F0YWx1bnlhIGxsaXVyZQo',
                  ) inherits bacula::params {

  validate_re($package_ensure, [ '^present$', '^installed$', '^absent$', '^purged$', '^held$', '^latest$' ], 'Not a supported package_ensure: present/absent/purged/held/latest')

  class { '::bacula::dir::install': }
  -> class { '::bacula::dir::config': }
  ~> class { '::bacula::dir::service': }
  -> Class['::bacula::dir']
}
