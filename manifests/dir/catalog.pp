define bacula::dir::catalog (
                              $dbpassword,
                              $catalog_name = $name,
                              $dbname       = 'bacula',
                              $dbuser       = 'bacula',
                              $dbsocket     = '/var/mysql/bacula/datadir/mysqld.sock',
                              $dbaddress    = undef,
                              $dbport       = undef,
                              $setup_mysql  = true,
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
}
