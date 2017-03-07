class bacula::bconsole::install inherits bacula::fd {

  if($bacula::bconsole::manage_package)
  {
    package { $bacula::params::package_bconsole:
      ensure => $bacula::bconsole::package_ensure,
    }
  }

}
