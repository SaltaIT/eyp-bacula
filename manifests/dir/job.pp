define bacula::dir::job (
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
  $job_type = 'Job'

  if(!defined(Concat::Fragment['bacula-dir.conf jobs includes']))
  {
    concat::fragment{ 'bacula-dir.conf jobs includes':
      target  => '/etc/bacula/bacula-dir.conf',
      order   => '90',
      content => "@|\"sh -c 'for f in /etc/bacula/bacula-dir/jobs/*.conf ; do echo @\${f} ; done'\"\n",
    }
  }

  $job_name_filename=downcase($job_name)

  file { "/etc/bacula/bacula-dir/jobs/${job_name_filename}.conf":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template("${module_name}/dir/job.erb"),
  }
}
