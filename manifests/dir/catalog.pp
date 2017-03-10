define bacula::dir::catalog (
                              $dbpassword,
                              $catalog_name         = $name,
                              $dbname               = 'bacula',
                              $dbuser               = 'bacula',
                              $dbsocket             = '/var/mysql/bacula/mysqld.sock',
                              $dbaddress            = undef,
                              $dbport               = undef,
                              $create_db_and_tables = true,
                            ) {

  concat::fragment{ "/etc/bacula/bacula-dir.conf catalog ${catalog_name}":
    target  => '/etc/bacula/bacula-dir.conf',
    order   => '10',
    content => template("${module_name}/dir/catalog.erb"),
  }

  if($create_db_and_tables)
  {
    mysql_database { $dbname:
      ensure  => 'present',
      require => Class['::bacula::dir'],
      before  => Exec['import bacula tables'],
    }

    exec { 'import bacula tables':
      command => template("${module_name}/dir/exec/run_mktables.erb"),
      unless  => template("${module_name}/dir/exec/unless_mktables.erb"),
      path    => '/usr/sbin:/usr/bin:/sbin:/bin',
      require => Class['::bacula::dir'],
    }
  }
}
