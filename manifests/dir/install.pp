class bacula::dir::install inherits bacula::dir {

  if($bacula::dir::manage_package)
  {
    package { $bacula::params::package_dir_name:
      ensure => $bacula::dir::package_ensure,
      before => File['/var/lib/bacula'],
    }

    if($bacula::dir::install_bacula_console)
    {
      package { $bacula::params::bacula_console_package:
        ensure => $bacula::dir::package_ensure,
      }
    }
  }

  file { '/var/lib/bacula':
    ensure => 'directory',
    owner  => 'bacula',
    group  => 'bacula',
    mode   => '0700',
  }

}
