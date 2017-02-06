class bacula::fd::service inherits bacula::fd {

  #
  validate_bool($bacula::fd::manage_docker_service)
  validate_bool($bacula::fd::manage_service)
  validate_bool($bacula::fd::service_enable)

  validate_re($bacula::fd::service_ensure, [ '^running$', '^stopped$' ], "Not a valid daemon status: ${bacula::fd::service_ensure}")

  $is_docker_container_var=getvar('::eyp_docker_iscontainer')
  $is_docker_container=str2bool($is_docker_container_var)

  if( $is_docker_container==false or
      $bacula::fd::manage_docker_service)
  {
    if($bacula::fd::manage_service)
    {
      service { $bacula::params::service_fd_name:
        ensure => $bacula::fd::service_ensure,
        enable => $bacula::fd::service_enable,
      }
    }
  }
}
