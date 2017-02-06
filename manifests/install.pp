class bacula::install inherits bacula {

  if($bacula::manage_package)
  {
    package { $bacula::params::package_name:
      ensure => $bacula::package_ensure,
    }
  }

}
