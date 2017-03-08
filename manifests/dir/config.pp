#
# concat bacula-dir
# 00 - base config
# 10 - catalogs
# 90 - includes
#
class bacula::dir::config inherits bacula::dir {

  #/usr/sbin/bacula-dir -c /etc/bacula/bacula-dir.conf -u bacula -g bacula
  systemd::service { 'bacula-director':
    execstart => '/usr/sbin/bacula-dir -c /etc/bacula/bacula-dir.conf -u bacula -g bacula'
  }

  concat { '/etc/bacula/bacula-dir.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
  }

  file { '/etc/bacula/bacula-dir':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    recurse => true,
    purge   => true,
  }

  file { '/etc/bacula/bacula-dir/jobtemplates':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    recurse => true,
    purge   => true,
    require => File['/etc/bacula/bacula-dir'],
  }

  file { '/etc/bacula/bacula-dir/jobs':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    recurse => true,
    purge   => true,
    require => File['/etc/bacula/bacula-dir'],
  }

  file { '/etc/bacula/bacula-dir/filesets':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    recurse => true,
    purge   => true,
    require => File['/etc/bacula/bacula-dir'],
  }

  file { '/etc/bacula/bacula-dir/schedules':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    recurse => true,
    purge   => true,
    require => File['/etc/bacula/bacula-dir'],
  }

  file { '/etc/bacula/bacula-dir/storages':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    recurse => true,
    purge   => true,
    require => File['/etc/bacula/bacula-dir'],
  }

  file { '/etc/bacula/bacula-dir/clients':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    recurse => true,
    purge   => true,
    require => File['/etc/bacula/bacula-dir'],
  }

  file { '/etc/bacula/bacula-dir/pools':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    recurse => true,
    purge   => true,
    require => File['/etc/bacula/bacula-dir'],
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
        ensure       => $bacula::dir::baculalog_rotate,
        log          => $bacula::dir::bacula_log,
        compress     => true,
        copytruncate => true,
        frequency    => $bacula::dir::baculalog_frequency,
        rotate       => $bacula::dir::baculalog_rotate,
        missingok    => true,
        size         => $bacula::dir::baculalog_size,
      }
    }
  }

  bacula::dir::pool { 'Scratch':
    description => 'scratch pool',
    require     => File['/etc/bacula/bacula-dir/pools'],
  }
}
