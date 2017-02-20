# # List of files to be backed up
# FileSet {
#   Name = "Full Set"
#   Include {
#     Options {
#       signature = MD5
#     }
# #
# #  Put your list of files here, preceded by 'File =', one per line
# #    or include an external list with:
# #
# #    File = <file-name
# #
# #  Note: / backs up everything on the root partition.
# #    if you have other partitions such as /usr or /home
# #    you will probably want to add them too.
# #
# #  By default this is defined to point to the Bacula binary
# #    directory to give a reasonable FileSet to backup to
# #    disk storage during initial testing.
# #
#     File = /usr/sbin
#   }
#
# #
# # If you backup the root directory, the following two excluded
# #   files can be useful
# #
#   Exclude {
#     File = /var/lib/bacula
#     File = /nonexistant/path/to/file/archive/dir
#     File = /proc
#     File = /tmp
#     File = /sys
#     File = /.journal
#     File = /.fsck
#   }
# }
#
#
# $includelist    = [ '/var/log', '/etc', '/var/spool/cron' ],
# $excludelist = [ '/', '/dev', '/sys', '/proc' ],
#
define bacula::dir::fileset (
                              $fileset_name = $name,
                              $includelist = [ '/var/log', '/etc', '/var/spool/cron' ],
                              $excludelist = [ '/', '/dev', '/sys', '/proc' ],
                              $signature = 'MD5',
                              $gzip = false,
                              $gzip_level = '6',
                              $onefs = false,
                              $aclsupport = false,
                            ) {
  $fileset_name_filename=downcase($fileset_name)

  file { "/etc/bacula/bacula-dir/filesets/${fileset_name_filename}.conf":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template("${module_name}/dir/fileset.erb"),
  }
}
