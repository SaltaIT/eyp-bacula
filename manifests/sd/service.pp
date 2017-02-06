class bacula::sd::service inherits bacula::sd {

  #
  validate_bool($bacula::sd::manage_docker_service)
  validate_bool($bacula::sd::manage_service)
  validate_bool($bacula::sd::service_enable)

  validate_re($bacula::sd::service_ensure, [ '^running$', '^stopped$' ], "Not a valid daemon status: ${bacula::sd::service_ensure}")

  $is_docker_container_var=getvar('::eyp_docker_iscontainer')
  $is_docker_container=str2bool($is_docker_container_var)

  if( $is_docker_container==false or
      $bacula::sd::manage_docker_service)
  {
    if($bacula::sd::manage_service)
    {
      service { $bacula::params::service_sd_name:
        ensure => $bacula::sd::service_ensure,
        enable => $bacula::sd::service_enable,
      }
    }
  }
}
