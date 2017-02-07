class bacula::dir::service inherits bacula::dir {

  #
  validate_bool($bacula::dir::manage_docker_service)
  validate_bool($bacula::dir::manage_service)
  validate_bool($bacula::dir::service_enable)

  validate_re($bacula::dir::service_ensure, [ '^running$', '^stopped$' ], "Not a valid daemon status: ${bacula::dir::service_ensure}")

  $is_docker_container_var=getvar('::eyp_docker_iscontainer')
  $is_docker_container=str2bool($is_docker_container_var)

  if( $is_docker_container==false or
      $bacula::dir::manage_docker_service)
  {
    if($bacula::dir::manage_service)
    {
      service { $bacula::params::service_dir_name:
        ensure => $bacula::dir::service_ensure,
        enable => $bacula::dir::service_enable,
      }
    }
  }
}
