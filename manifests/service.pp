class bacula::service inherits bacula {

  #
  validate_bool($bacula::manage_docker_service)
  validate_bool($bacula::manage_service)
  validate_bool($bacula::service_enable)

  validate_re($bacula::service_ensure, [ '^running$', '^stopped$' ], "Not a valid daemon status: ${bacula::service_ensure}")

  $is_docker_container_var=getvar('::eyp_docker_iscontainer')
  $is_docker_container=str2bool($is_docker_container_var)

  if( $is_docker_container==false or
      $bacula::manage_docker_service)
  {
    if($bacula::manage_service)
    {
      service { $bacula::params::service_name:
        ensure => $bacula::service_ensure,
        enable => $bacula::service_enable,
      }
    }
  }
}
