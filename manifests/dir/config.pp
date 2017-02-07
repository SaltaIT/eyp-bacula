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
}
