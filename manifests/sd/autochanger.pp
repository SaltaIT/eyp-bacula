# Autochanger {
#   Name = FileChgr2
#   Device = FileChgr2-Dev1, FileChgr2-Dev2
#   Changer Command = ""
#   Changer Device = /dev/null
# }
define bacula::sd::autocharger(
                                $autochanger_name = $name,
                                $devices          = [],
                                $command          = '',
                                $device           = '/dev/null',
                                $description      = undef,
                              ) {
  validate_array($devices)

  concat::fragment{ "/etc/bacula/bacula-sd.conf autochanger ${autochanger_name}":
    target  => '/etc/bacula/bacula-sd.conf',
    order   => '10',
    content => template("${module_name}/sd/autochanger.erb"),
  }
}
