#
# Restricted Director, used by tray-monitor to get the
#   status of the file daemon
#
# Director {
#   Name = ubuntu16-mon
#   Password = "PxLNs0J_OI_0VPrXpk24LDVDdlYmnW5xR"
#   Monitor = yes
# }
define bacula::sd::director (
                              $password,
                              $director_name = $name,
                              $monitor       = false,
                              $description   = undef,
                            ) {
  concat::fragment{ "/etc/bacula/bacula-sd.conf director ${director_name}":
    target  => '/etc/bacula/bacula-sd.conf',
    order   => '90',
    content => template("${module_name}/fd/director.erb"),
  }
}
