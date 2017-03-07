#
# concat bacula-fd
# 00 - base config
# 10 - dirctors
class bacula::bconsole::config inherits bacula::fd {

  concat { '/etc/bacula/bconsole.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
  }
}
