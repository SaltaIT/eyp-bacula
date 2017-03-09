#
# concat bacula-sd
# 00 base config storage daemin
# 10 autocharger
# 11 devices
class bacula::sd::config inherits bacula::sd {

  concat { '/etc/bacula/bacula-sd.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
  }

  concat::fragment{ '/etc/bacula/bacula-sd.conf base conf':
    target  => '/etc/bacula/bacula-sd.conf',
    order   => '00',
    content => template("${module_name}/sd/baculasd.erb"),
  }

  if($bacula::sd::director_name!=undef)
  {
    bacula::sd::director { $bacula::sd::director_name:
      password => $bacula::sd::director_password,
      description => "default director",
    }
  }
}
