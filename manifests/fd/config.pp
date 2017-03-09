#
# concat bacula-fd
# 00 - base config
# 10 - dirctors
class bacula::fd::config inherits bacula::fd {

  concat { '/etc/bacula/bacula-fd.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
  }

  concat::fragment{ '/etc/bacula/bacula-fd.conf base conf':
    target  => '/etc/bacula/bacula-fd.conf',
    order   => '00',
    content => template("${module_name}/fd/baculafd.erb"),
  }

  if($bacula::fd::director_name!=undef)
  {
    bacula::fd::director { $bacula::fd::director_name:
      password => $bacula::fd::director_password,
      description => "default director",
    }
  }
}
