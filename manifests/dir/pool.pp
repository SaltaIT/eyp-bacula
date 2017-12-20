# Pool {
#   Name = Scratch
#   Pool Type = Backup
# }
# Recycle = yes                       # Bacula can automatically recycle Volumes
# AutoPrune = yes                     # Prune expired volumes
# Volume Retention = 365 days         # one year
# Maximum Volume Bytes = 50G          # Limit Volume size to something reasonable
# Maximum Volumes = 100               # Limit number of Volumes in Pool
# Label Format = "Vol-"               # Auto label
# Action On Purge = Truncate          # Allow to truncate volume
# Volume Use Duration = 14h           # Force volume switch
define bacula::dir::pool(
                          $pool_name           = $name,
                          $pool_type           = 'Backup',
                          $recycle             = undef,
                          $autoprune           = undef,
                          $volume_retention    = undef,
                          $job_retention       = undef,
                          $file_retention      = undef,
                          $maximum_volume_size = undef,
                          $maximum_volumes     = undef,
                          $label_format        = undef,
                          $description         = undef,
                          $action_on_purge     = undef,
                          $volume_use_duration = undef,
                        ) {

  if(!defined(Concat::Fragment['bacula-dir.conf pools includes']))
  {
    concat::fragment{ 'bacula-dir.conf pools includes':
      target  => '/etc/bacula/bacula-dir.conf',
      order   => '90',
      content => "@|\"sh -c 'for f in /etc/bacula/bacula-dir/pools/*.conf ; do echo @\${f} ; done'\"\n",
    }
  }

  $pool_name_filename=downcase($pool_name)

  file { "/etc/bacula/bacula-dir/pools/${pool_name_filename}.conf":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template("${module_name}/dir/pool.erb"),
    notify  => Class['::bacula::dir::service'],
  }
}
