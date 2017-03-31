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

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

This is where you list OS compatibility, version compatibility, etc.

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
