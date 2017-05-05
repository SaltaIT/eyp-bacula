# bacula

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What bacula affects](#what-bacula-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with bacula](#beginning-with-bacula)
4. [Usage](#usage)
5. [Reference](#reference)
5. [Limitations](#limitations)
6. [Development](#development)
    * [TODO](#todo)
    * [Contributing](#contributing)

## Overview

bacula client and server services management

## Module Description

You can manage 4 different services:

* bacula director: **bacula::dir**
* bacula storage daemon: **bacula::sd**
* bacula console: **bacula::bconsole**
* bacula client (file daemon): **bacula::fd**

## Setup

### What bacula affects

* A list of files, packages, services, or operations that the module will alter,
  impact, or execute on the system it's installed on.
* This is a great place to stick any warnings.
* Can be in list or paragraph form.

### Setup Requirements

This module requires pluginsync enabled

### Beginning with bacula

![bacula schema](http://www.bacula.org/7.4.x-manuals/en/images/Conf-Diagram.png "bacula schema")

```puppet
class { 'bacula::fd':
  fdname => 'bacula-fd',
}

class { 'bacula::sd':
  sdname => 'bacula-sd',
}

bacula::sd::device { 'data1':
  archive_device => '/var/bacula/data1',
}

bacula::sd::device { 'data2':
  archive_device => '/var/bacula/data2',
}

bacula::sd::autochanger { 'autochanger1':
  devices => [ 'data1', 'data2' ],
}

class { 'bacula::dir':
}

bacula::dir::catalog { 'mycatalog':
  dbpassword => 'baculapassw0rd',
}

bacula::dir::fileset { 'Full':
}

bacula::dir::schedule { 'weekly':
  run => [ "Full 1st sun at 23:05", "Incremental mon-sat at 23:05" ],
}

bacula::dir::client { 'bacula-fd':
  addr     => '127.0.0.1',
  catalog  => 'mycatalog',
}

bacula::dir::storage { 'local-autochanger1':
  password => 'dmlzY2EgY2F0YWx1bnlhIGxsaXVyZQo',
  device   => 'autochanger1',
}

bacula::dir::pool { '30days':
  volume_retention => '30 days',
  label_format     => '30days-',
}

bacula::dir::job { 'demo':
  client   => 'bacula-fd',
  fileset  => 'Full',
  schedule => 'weekly',
  storage  => 'local-autochanger1',
  pool     => '30days',
}

class { 'bacula::bconsole': }
```


## Usage

### bacula-fd

```puppet
class { 'bacula::fd': }

bacula::fd::director { 'monitor':
  director_password => '123',
  monitor => true,
}
```

### bacula-sd

```puppet
class { 'bacula::sd': }

bacula::sd::device { 'data1':
  archive_device => '/var/bacula/data1',
}

bacula::sd::device { 'data2':
  archive_device => '/var/bacula/data1',
}

bacula::sd::autochanger { 'autochanger1':
  devices => [ 'data1', 'data2' ],
}
```

bacula director using hiera:

```yaml
---
classes:
  - bacula::sd
  - bacula::dir
  - bacula::bconsole

mysql::mysql_username_uid: 116
mysql::mysql_username_gid: 125

xtrabackup:
  'bacula':
    hour: '3'
    minute: '0'
    destination: '/var/mysql/backup'
    retention: '5'

bacula::dir::director_password: 'passw0rd'
bacula::sd::director_password: 'passw0rd'
bacula::bconsole::director_password: 'passw0rd'

baculasddevices:
  data1:
    archive_device: '/var/bacula/data1'

baculadircatalogs:
  mycatalog:
    dbpassword: 'dbpassw0rd'

baculadirfilesets:
  log_etc_cron: {}
  log_etc_cron_xtrabackup:
    includelist:
      - '/var/log'
      - '/etc'
      - 'var/spool/cron'
      - '/var/mysql/backup'

baculadirschedules:
  weekly:
    run:
      - 'Full 1st sun at 03:00'
      - 'Incremental mon-sat at 03:00'

baculadirclients:
  'EF-BaculaDir01':
    addr: '127.0.0.1'
    catalog: mycatalog
    password: 'passw0rd'

baculadirstorages:
  localdata:
    password: 'passw0rd'
    device: 'data1'

baculadirpools:
  30days:
    volume_retention: '30 days'
    label_format: '30days-'

baculadirjobtemplates:
  'defaultjob':
    fileset: 'log_etc_cron'
    scheduled: weekly
    storage: localdata
    pool: '30days'
  'defaultjobdb':
    fileset: 'log_etc_cron_xtrabackup'
    scheduled: weekly
    storage: localdata
    pool: '30days'

baculadirjobs:
  'EF-BaculaDir01':
    jobdefs: 'defaultjobdb'
    client: 'EF-BaculaDir01'
```

bacula client using hiera:

```yaml
---
classes:
  - bacula::fd

bacula::fd::director_password: passw0rd
```

## Reference

### classes

#### bacula::fd

bacula file daemon (client)

* **manage_package**:        = true,
* **package_ensure**:        = 'installed',
* **manage_service**:        = true,
* **manage_docker_service**: = true,
* **service_ensure**:        = 'running',
* **service_enable**:        = true,
* **port**:                  = '9102',
* **fdname**:                = $::fqdn,
* **director_name**:         = $::fqdn,
* **director_password**:     = 'dmlzY2EgY2F0YWx1bnlhIGxsaXVyZQo',
* **max_concurrent_jobs**:   = '20',
* **plugin_dir**:            = undef,
* **fdaddr**:                = undef,
* **debug_level**:           = undef,

#### bacula::dir

bacula director

* **manage_package**:              = true,
* **package_ensure**:              = 'installed',
* **manage_service**:              = true,
* **manage_docker_service**:       = true,
* **service_ensure**:              = 'running',
* **service_enable**:              = true,
* **director_name**:               = $::fqdn,
* **max_concurrent_jobs**:         = '20',
* **director_password**:           = 'dmlzY2EgY2F0YWx1bnlhIGxsaXVyZQo',
* **port**:                        = '9101',
* **diraddr**:                     = undef,
* **bacula_log**:                  = '/var/log/bacula/bacula.log',
* **baculalog_frequency**:         = 'daily',
* **baculalog_rotate**:            = '15',
* **baculalog_size**:              = '100M',
* **baculalog_logrotate_ensure**:  = 'present',
* **mail_from**:                   = "bacula@${::fqdn}",
* **mailto_notification**:         = "bacula@${::fqdn}",
* **mailto_operator**:             = "bacula@${::fqdn}",
* **mailto_daemon_notifications**: = "bacula@${::fqdn}",
* **notification_subject**:        = 'Bacula: %t %e of %c %l',
* **operator_subject**:            = 'Bacula: Intervention needed for %j',
* **daemon_subject**:              = 'Bacula daemon message',
* **debug_level**:                 = undef,
* **setup_mysql**:                 = true,
* **root_db_password**:            = 'dmlzY2EgY2F0YWx1bnlhIGxsaXVyZQo',


#### bacula::sd

bacula storage daemon

* **manage_package**:        = true,
* **package_ensure**:        = 'installed',
* **manage_service**:        = true,
* **manage_docker_service**: = true,
* **service_ensure**:        = 'running',
* **service_enable**:        = true,
* **sdname**:                = $::fqdn,
* **port**:                  = '9103',
* **max_concurrent_jobs**:   = '20',
* **sdaddr**:                = undef,
* **director_name**:         = $::fqdn,
* **director_password**:     = 'dmlzY2EgY2F0YWx1bnlhIGxsaXVyZQo',
* **debug_level**:           = undef,

#### bacula::bconsole

bacula command-line console

* **manage_package**:    = true,
* **package_ensure**:    = 'installed',
* **director_name**:     = $::fqdn,
* **director_password**: = 'dmlzY2EgY2F0YWx1bnlhIGxsaXVyZQo',
* **director_port**:     = '9101',
* **director_address**:  = '127.0.0.1',

### defines

#### director

##### bacula::dir::catalog

* **dbpassword**:,
* **catalog_name**:         = $name,
* **dbname**:               = 'bacula',
* **dbuser**:               = 'bacula',
* **$dbsocket**:             = '/var/mysql/bacula/mysqld.sock',
* **dbaddress**:            = undef,
* **dbport**:               = undef,
* **create_db_and_tables**: = true

##### bacula::dir::client

* **catalog**:,
* **addr**:,
* **password**:       = 'dmlzY2EgY2F0YWx1bnlhIGxsaXVyZQo',
* **client_name**:    = $name,
* **description**:    = undef,
* **port**:           = '9102',
* **file_retention**: = '30 days',
* **job_retention**:

##### bacula::dir::fileset

* **fileset_name**: = $name,
* **includelist**: = [ '/var/log', '/etc', '/var/spool/cron' ],
* **excludelist**: = [ '/', '/dev', '/sys', '/proc' ],
* **signature**:   = 'MD5',
* **gzip**:        = false,
* **gzip_level**:  = '6',
* **onefs**:       = false,
* **aclsupport**:  = false,

##### bacula::dir::job

* **job_name**:       = $name,
* **jobdefs**:        = undef,
* **type**:           = 'Backup',
* **level**:          = undef,
* **client**:         = undef,
* **fileset**:        = undef,
* **scheduled**:      = undef,
* **storage**:        = undef,
* **pool**:           = undef,
* **spool_data**:     = false,
* **priority**:       = undef,
* **run_before_job**: = undef,
* **run_after_job**:  = undef,
* **write_bootstrap**: = '/var/lib/bacula/%c.bsr',

##### bacula::dir::jobtemplate

* **job_name**:       = $name,
* **type**:           = 'Backup',
* **level**:          = undef,
* **client**:         = undef,
* **fileset**:        = undef,
* **scheduled**:      = undef,
* **storage**:        = undef,
* **pool**:           = undef,
* **spool_data**:     = false,
* **priority**:       = undef,
* **run_before_job**: = undef,
* **run_after_job**:  = undef,
* **write_bootstrap**: = '/var/lib/bacula/%c.bsr',

##### bacula::dir::pool

* **pool_name**:           = $name,
* **pool_type**:           = 'Backup',
* **recycle**:             = undef,
* **autoprune**:           = undef,
* **volume_retention**:    = undef,
* **maximum_volume_size**: = undef,
* **maximum_volumes**:     = undef,
* **label_format**:        = undef,
* **description**:         = undef,

##### bacula::dir::schedule

* **run**:,
* **schedule_name**: = $name,
* **description**:   = undef,

##### bacula::dir::storage

* **password**:,
* **device**:,
* **storage_name**:        = $name,
* **addr**:                = '127.0.0.1',
* **sd_port**:             = '9103',
* **media_type**:          = "File-${::fqdn}",
* **max_concurrent_jobs**: = '20',
* **description**:         = undef,

#### storage daemon

##### bacula::sd::autochanger

* **devices**:,
* **autochanger_name**: = $name,
* **command**:          = '',
* **device**:           = '/dev/null',
* **description**:      = undef,

##### bacula::sd::director

* **password**:,
* **director_name**: = $name,
* **monitor**:       = false,
* **description**:   = undef,

#### file daemon

##### bacula::fd::director

* **password**:,
* **director_name**: = $name,
* **monitor**:       = false,
* **description**:   = undef,


## Limitations

Tested on Ubuntu 14.04 and Ubuntu 16.04

## Development

We are pushing to have acceptance testing in place, so any new feature should
have some test to check both presence and absence of any feature

### TODO

TODO list

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
