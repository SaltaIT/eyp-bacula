define bacula::dir::catalog (
                              $dbpassword,
                              $catalog_name = $name,
                              $dbname       = 'bacula',
                              $dbuser       = 'bacula',
                            ) {
  concat::fragment{ "/etc/bacula/bacula-dir.conf catalog ${catalog_name}":
    target  => '/etc/bacula/bacula-dir.conf',
    order   => '10',
    content => template("${module_name}/fd/catalog.erb"),
  }
}
