class bacula::params {

  $package_fd_name='bacula-fd'
  $service_fd_name='bacula-fd'

  $package_sd_name='bacula-sd'
  $service_sd_name='bacula-sd'

  $package_dir_name=[ 'bacula-director-common', 'bacula-director-mysql', 'bacula-common-mysql' ]
  $service_dir_name='bacula-director'

  $fd_workdir = '/var/lib/bacula'
  $fd_pid = '/var/run/bacula'
  $sd_workdir = '/var/lib/bacula'
  $sd_pid = '/var/run/bacula'
  $dir_workdir = '/var/lib/bacula'
  $dir_pid = '/var/run/bacula'

  $package_bconsole = 'bacula-console'

  case $::osfamily
  {
    'redhat':
    {
      case $::operatingsystemrelease
      {
        /^[5-7].*$/:
        {
        }
        default: { fail("Unsupported RHEL/CentOS version! - ${::operatingsystemrelease}")  }
      }
    }
    'Debian':
    {
      case $::operatingsystem
      {
        'Ubuntu':
        {
          case $::operatingsystemrelease
          {
            /^14.*$/:
            {
            }
            /^16.*$/:
            {
            }
            default: { fail("Unsupported Ubuntu version! - ${::operatingsystemrelease}")  }
          }
        }
        'Debian': { fail('Unsupported')  }
        default: { fail('Unsupported Debian flavour!')  }
      }
    }
    default: { fail('Unsupported OS!')  }
  }
}
