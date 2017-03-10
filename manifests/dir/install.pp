class bacula::dir::install inherits bacula::dir {

  if($bacula::dir::manage_package)
  {
    package { $bacula::params::package_dir_name:
      ensure => $bacula::dir::package_ensure,
      before => File[ [ '/var/lib/bacula', '/etc/bacula/scripts' ] ],
    }
  }

  if($bacula::dir::setup_mysql)
  {
    mysql::community::instance { 'bacula':
      port              => '3306',
      password          => $bacula::dir::root_db_password,
      add_default_mycnf => true,
      default_instance  => true,
    }
  }

  # root@ubuntu16:/etc/bacula/scripts# ls -ld /etc/bacula
  # drwxr-xr-x 4 root root 4096 Mar  8 17:10 /etc/bacula

  file { '/etc/bacula':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  # root@ubuntu16:/etc/bacula/scripts# ls -ld /etc/bacula/scripts/
  # drwxr-xr-x 2 root root 4096 Mar  7 17:29 /etc/bacula/scripts/
  # root@ubuntu16:/etc/bacula/scripts#

  file { '/etc/bacula/scripts':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => File['/etc/bacula'],
  }

  file { '/etc/bacula/scripts/mktables_70.sql':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    source  => "puppet:///modules/${module_name}/mktables_70.sql",
    require => File['/etc/bacula/scripts'],
  }

  file { '/etc/bacula/scripts/wait-for-bacula-pid.sh':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => "puppet:///modules/${module_name}/wait-for-bacula-pid.sh",
    require => File['/etc/bacula/scripts'],
  }

  file { '/var/lib/bacula':
    ensure => 'directory',
    owner  => 'bacula',
    group  => 'bacula',
    mode   => '0700',
  }

}
