# #
# # When to do the backups, full backup on first sunday of the month,
# #  differential (i.e. incremental since full) every other sunday,
# #  and incremental backups other days
# Schedule {
#   Name = "WeeklyCycle"
#   Run = Full 1st sun at 23:05
#   Run = Differential 2nd-5th sun at 23:05
#   Run = Incremental mon-sat at 23:05
# }
#
# # This schedule does the catalog. It starts after the WeeklyCycle
# Schedule {
#   Name = "WeeklyCycleAfterBackup"
#   Run = Full sun-sat at 23:10
# }
#
define bacula::dir::schedule(
                              $run,
                              $schedule_name = $name,
                              $description   = undef,
                            ) {
  if(!defined(Concat::Fragment['bacula-dir.conf schedules includes']))
  {
    concat::fragment{ 'bacula-dir.conf schedules includes':
      target  => '/etc/bacula/bacula-dir.conf',
      order   => '90',
      content => "@|\"sh -c 'for f in /etc/bacula/bacula-dir/schedules/*.conf ; do echo @\${f} ; done'\"\n",
    }
  }

  $schedule_name_filename=downcase($schedule_name)

  file { "/etc/bacula/bacula-dir/schedules/${schedule_name_filename}.conf":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template("${module_name}/dir/schedule.erb"),
  }
}
