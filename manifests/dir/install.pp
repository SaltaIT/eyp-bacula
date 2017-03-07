class bacula::dir::install inherits bacula::dir {

  if($bacula::dir::manage_package)
  {
    package { $bacula::params::package_dir_name:
      ensure => $bacula::dir::package_ensure,
      before => File['/var/lib/bacula'],
    }
  }

  file { '/var/lib/bacula':
    ensure => 'directory',
    owner  => 'bacula',
    group  => 'bacula',
    mode   => '0700',
  }

}
