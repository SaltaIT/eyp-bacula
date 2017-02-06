class bacula::sd::install inherits bacula::sd {

  if($bacula::sd::manage_package)
  {
    package { $bacula::params::package_sd_name:
      ensure => $bacula::sd::package_ensure,
    }
  }

}
