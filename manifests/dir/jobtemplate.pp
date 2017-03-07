# JobDefs {
#   Name = "DefaultJob"
#   Type = Backup
#   Level = Incremental
#   Client = lolcathost-fd
#   FileSet = "Full Set"
#   Schedule = "WeeklyCycle"
#   Storage = File1
#   Messages = Standard
#   Pool = File
#   SpoolAttributes = yes
#   Priority = 10
#   Write Bootstrap = "/var/lib/bacula/%c.bsr"
# }

# RunBeforeJob = "/etc/bacula/scripts/make_catalog_backup.pl MyCatalog"
# # This deletes the copy of the catalog
# RunAfterJob  = "/etc/bacula/scripts/delete_catalog_backup"

define bacula::dir::jobtemplate (
                                  $job_name       = $name,
                                  $type           = 'Backup',
                                  $level          = undef,
                                  $client         = undef,
                                  $fileset        = undef,
                                  $schedule       = undef,
                                  $storage        = undef,
                                  $pool           = undef,
                                  $spool_data     = false,
                                  $priority       = undef,
                                  $run_before_job = undef,
                                  $run_after_job  = undef,
                                  $write_bootstrap = '/var/lib/bacula/%c.bsr',
                                ) {
  $job_type = 'JobDefs'

  $job_name_filename=downcase($job_name)

  file { "/etc/bacula/bacula-dir/jobtemplates/${job_name_filename}.conf":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template("${module_name}/dir/job.erb"),
  }
}
