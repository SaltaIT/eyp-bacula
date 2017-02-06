#
# Restricted Director, used by tray-monitor to get the
#   status of the file daemon
#
# Director {
#   Name = ubuntu16-mon
#   Password = "PxLNs0J_OI_0VPrXpk24LDVDdlYmnW5xR"
#   Monitor = yes
# }
define bacula::fd::director (
                              $director_password,
                              $director_name = $name,
                              $monitor       = false,
                              $description   = undef,
                            ) {
  concat::fragment{ "/etc/bacula/bacula-fd.conf director ${director_name}":
    target  => '/etc/bacula/bacula-fd.conf',
    order   => '10',
    content => template("${module_name}/fd/director.erb"),
  }
}
