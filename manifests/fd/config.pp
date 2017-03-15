#
# concat bacula-fd
# 00 - base config
# 10 - dirctors
class bacula::fd::config inherits bacula::fd {

  if($bacula::params::systemd)
  {
    systemd::service { 'bacula-fd':
      execstart       => inline_template('/usr/sbin/bacula-fd -c /etc/bacula/bacula-fd.conf<% if defined?(@debug_level) %> -d <%= @debug_level %><% end %>'),
      pid_file        => "/var/run/bacula/bacula-fd.${bacula::fd::port}.pid",
      type            => 'forking',
      timeoutstartsec => '1m',
    }
  }

  concat { '/etc/bacula/bacula-fd.conf':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0640',
  }

  concat::fragment{ '/etc/bacula/bacula-fd.conf base conf':
    target  => '/etc/bacula/bacula-fd.conf',
    order   => '00',
    content => template("${module_name}/fd/baculafd.erb"),
  }

  if($bacula::fd::director_name!=undef)
  {
    bacula::fd::director { $bacula::fd::director_name:
      password    => $bacula::fd::director_password,
      description => 'default director',
    }
  }
}
