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
define bacula::dir::pool(
                          $pool_name           = $name,
                          $pool_type           = 'Backup',
                          $recycle             = undef,
                          $autoprune           = undef,
                          $volume_retention    = undef,
                          $maximum_volume_size = undef,
                          $maximum_volumes     = undef,
                          $label_format        = undef,
                          $description         = undef,
                        ) {

  $pool_name_filename=downcase($pool_name)
  file { "/etc/bacula/bacula-dir/pools/${pool_name_filename}.conf":
    ensure  => 'ensure',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
  }

}
