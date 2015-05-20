# == Class: flume_repose::flume
#
# This class is able to install or remove flume-repose on a node.
#
#
# === Parameters
#
# The default values for the parameters are set in repose::params. Have
# a look at the corresponding <tt>params.pp</tt> manifest file if you need more
# technical information about them.
# 
# [*ensure*]
# String. Controls if the managed resources shall be <tt>present</tt> or
# <tt>absent</tt>. If set to <tt>absent</tt>:
# * The managed software packages are being uninstalled.
# * Any traces of the packages will be purged as good as possible. This may
# include existing configuration files. The exact behavior is provider
# dependent. Q.v.:
# * Puppet type reference: {package, "purgeable"}[http://j.mp/xbxmNP]
# * {Puppet's package provider source code}[http://j.mp/wtVCaL]
# * System modifications (if any) will be reverted as good as possible
# (e.g. removal of created users, services, changed log settings, ...).
# * This is thus destructive and should be used with care.
# Defaults to <tt>present</tt>.
#
# [*enable*]
# Bool/String. Controls if the managed service shall be running(<tt>true</tt>),
# stopped(<tt>false</tt>), or <tt>manual</tt>. This affects the service state
# at both boot and during runtime.  If set to <tt>manual</tt> Puppet will
# ignore the state of the service.
# Defaults to <tt>true</tt>.
#
# The default values for the parameters are set in repose::params. Have
# a look at the corresponding <tt>params.pp</tt> manifest file if you need more
# technical information about them.
#
# [*daemon_home*]
# String. Daemon home path
# Defaults to <tt>/usr/share/lib/repose</tt>
#
# [*log_path*]
# String. Log file directory path
# Defaults to <tt>/var/log/repose</tt>
#
# [*pid_file*]
# String. Pid file location
# Defaults to <tt>/var/run/repose-valve.pid</tt>
#
# [*user*]
# String. User to run the valve as
# Defaults to <tt>repose</tt>
#
# [*daemonize*]
# String. the path to the daemonize binary
# Defaults to <tt>/usr/sbin/daemonize</tt>
#
# [*daemonize_opts*]
# String. The daemonize options to be passed into daemonize.
# DEPRECATED. This does nothing for repose 7+. This is replaced by a different
# variable in the sysconfig file but we are not supporting overwriting it.
# at this time.
# Defaults to <tt>-c $DAEMON_HOME -p $PID_FILE -u $USER -o $LOG_PATH/stdout.log -e $LOG_PATH/stderr.log -l /var/lock/subsys/$NAME</tt>
#
# [*run_opts*]
# String. The options sent to the run command.
# DEPRECATED. This does nothing for repose 7+. This is replaced by a different
# variable in the sysconfig file but we are not supporting overwriting it.
# Defaults to <tt>-p $RUN_PORT -c $CONFIG_DIRECTORY</tt>
#
# === Examples
#
# * Installation:
#
# class { 'repose::valve': }
#
# * Removal/decommissioning:
#
# class { 'repose::valve': ensure => 'absent' }
#
#
# === Authors
#
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
# * Greg Sharek <mailto:greg.sharek@rackspace.com>
#
class flume_repose::flume (
  $ensure            = $flume_repose::params::ensure,
  $enable            = $flume_repose::params::enable,
  $daemon_home       = $flume_repose::params::daemon_home,
  $user              = $flume_repose::params::user,
  $daemonize         = $flume_repose::params::daemonize,
  $daemonize_opts    = $flume_repose::params::daemonize_opts,
  $run_opts          = $flume_repose::params::run_opts,
  $java_options      = undef,
) inherits flume_repose::params {

  class { 'flume_repose':
    ensure           => $ensure,
    enable           => $enable,
  }

  file { '/etc/sysconfig/flume-ng':
    ensure  => $flume_repose::file_ensure,
    owner   => root,
    group   => root,
    require => [ Package[ $flume_repose::params::package ] ],
    notify  => Service[ $flume_repose::params::service ],
  }

  # setup augeas with our shellvars lense
  Augeas {
    incl => '/etc/sysconfig/flume-ng',
    require => File['/etc/sysconfig/flume-ng'],
    lens => 'Shellvars.lns',
  }

  # default flume_repose sysconfig options
  $flume_repose_sysconfig = [
    "set DAEMON_HOME '${daemon_home}'",
    "set LOG_PATH '${log_path}'",
    "set PID_FILE '${pid_file}'",
    "set USER '${user}'",
    "set daemonize '${daemonize}'",
    "set daemonize_opts '\"${daemonize_opts}\"'",
    "set run_opts '\"${run_opts}\"'",
  ]

  # only run if ensure is not absent
  if ! ($ensure == absent) {
    # run augeas with our changes
    augeas {
      'flume_sysconfig':
        context => '/files/etc/sysconfig/flume-ng',
        changes => [ $flume_repose_sysconfig ]
    }
  }

}
