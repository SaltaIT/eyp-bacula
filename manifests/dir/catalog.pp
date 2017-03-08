define bacula::dir::catalog (
                              $dbpassword,
                              $catalog_name  = $name,
                              $dbname        = 'bacula',
                              $dbuser        = 'bacula',
                              $dbsocket      = '/var/mysql/bacula/mysqld.sock',
                              $dbaddress     = undef,
                              $dbport        = undef,
                              $setup_mysql   = true,
                              $create_tables = true,
                            ) {
  concat::fragment{ "/etc/bacula/bacula-dir.conf catalog ${catalog_name}":
    target  => '/etc/bacula/bacula-dir.conf',
    order   => '10',
    content => template("${module_name}/dir/catalog.erb"),
  }

  if($setup_mysql)
  {
    mysql::community::instance { 'bacula':
      port              => '3306',
      password          => $dbpassword,
      add_default_mycnf => true,
      default_instance  => true,
    }

    mysql_database { $dbname:
      ensure => 'present',
    }
  }

  if($create_tables)
  {
    exec { 'import bacula tables':
      command => template("${module_name}/dir/run_mktables.erb"),
      unless  => template("${module_name}/dir/unless_mktables.erb"),
      path    => '/usr/sbin:/usr/bin:/sbin:/bin',
    }
    # file { '/tmp/runme':
    #   ensure => 'present',
    #   content => template("${module_name}/dir/run_mktables.erb"),
    # }
  }
}
