class bacula::fd::install inherits bacula::fd {

  if($bacula::fd::manage_package)
  {
    package { $bacula::params::package_fd_name:
      ensure => $bacula::fd::package_ensure,
    }
  }

}
