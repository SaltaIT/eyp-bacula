#
# Device {
#   Name = FileChgr2-Dev1
#   Media Type = File2
#   Archive Device = /nonexistant/path/to/file/archive/dir
#   LabelMedia = yes;                   # lets Bacula label unlabeled media
#   Random Access = Yes;
#   AutomaticMount = yes;               # when device opened, read it
#   RemovableMedia = no;
#   AlwaysOpen = no;
#   Maximum Concurrent Jobs = 5
# }
#
define bacula::sd::device (
                            $archive_device,
                            $mkdir_archive_device = true,
                            $device_name          = $name,
                            $description          = undef,
                            $max_concurrent_jobs  = '20',
                            $media_type           = "File-${::fqdn}",
                            $device_type          = 'File',
                            $label_media          = true,
                            $random_access        = true,
                            $automatic_mount      = true,
                            $removable_media      = false,
                            $always_open          = false,
                            $max_concurrent_jobs  = '5',
                          ) {
  concat::fragment{ "/etc/bacula/bacula-sd.conf device ${device_name}":
    target  => '/etc/bacula/bacula-sd.conf',
    order   => '10',
    content => template("${module_name}/sd/device.erb"),
  }

  if($mkdir_archive_device)
  {
    exec { "mkdir -p archive_device ${archive_device}":
      command => "mkdir -p ${archive_device}",
      creates => $archive_device,
    }

    file { $archive_device:
      ensure => 'directory',
      owner => 'bacula',
      group => 'bacula',
      mode => '0750',
      require => Exec["mkdir -p archive_device ${archive_device}"],
    }
  }
}
