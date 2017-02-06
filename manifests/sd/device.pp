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
                            $device_name         = $name,
                            $description         = undef,
                            $max_concurrent_jobs = '20',
                            $media_type          = "File-${::fqdn}",
                            $device_type         = 'File',
                            $label_media         = true,
                            $random_access       = true,
                            $automatic_mount     = true,
                            $removable_media     = false,
                            $always_open         = false,
                            $max_concurrent_jobs = '5',
                          ) {
  concat::fragment{ "/etc/bacula/bacula-sd.conf device ${device_name}":
    target  => '/etc/bacula/bacula-sd.conf',
    order   => '10',
    content => template("${module_name}/sd/device.erb"),
  }
}
