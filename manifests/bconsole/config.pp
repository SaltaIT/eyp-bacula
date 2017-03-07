#
# concat bacula-fd
# 00 - base config
# 10 - dirctors
class bacula::bconsole::config inherits bacula::bconsole {

  file { '/etc/bacula/bconsole.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template("${module_name}/bconsole/bconsole.erb"),
  }
}
