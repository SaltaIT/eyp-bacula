#
# concat bacula-dir
# 00 - base config
# 10 - catalogs
#
class bacula::dir::config inherits bacula::dir {

  concat { '/etc/bacula/bacula-dir.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
  }

  concat::fragment{ '/etc/bacula/bacula-dir.conf base conf':
    target  => '/etc/bacula/bacula-dir.conf',
    order   => '00',
    content => template("${module_name}/dir/baculadir.erb"),
  }

  if($bacula::dir::baculalog_rotate!=undef)
  {
    if(defined(Class['::logrotate']))
    {
      logrotate::logs { 'baculalog':
        ensure       => $baculalog_logrotate_ensure,
        log          => "$bacula::dir::bacula_log",
        compress     => true,
        copytruncate => true,
        frequency    => $bacula::dir::baculalog_frequency,
        rotate       => $bacula::dir::baculalog_rotate,
        missingok    => true,
        size         => $bacula::dir::baculalog_size,
      }
    }
  }
}
