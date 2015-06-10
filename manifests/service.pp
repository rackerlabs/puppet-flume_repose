# == Class: flume_repose::service
#
# This class exists to define the services and any related
# actions, functionality and logical units in a central place.
#
#
# === Parameters
#
# [*ensure*]
#  String. If this is set to absent, then the service is stopped.  Otherwise
#  if this is set, it will be set to running unless enable is set to false.
#  Defaults to <tt>present</tt>
#
# [*enable*]
#  Boolean/String. This toggles if the service should be stopped, running or
#  manual.
#  Defaults to <tt>true</tt>
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
# String. User to run flume-ng as
# Defaults to <tt>repose</tt>
#
# [*daemonize*]
# String. the path to the daemonize binary
# Defaults to <tt>/usr/sbin/daemonize</tt>
#
# [*start_args*]
# String. The daemonize options to be passed into daemonize.
# Defaults to <tt>-c $DAEMON_HOME -p $PID_FILE -u $USER -o $LOG_PATH/stdout.log -e $LOG_PATH/stderr.log -l /var/lock/subsys/$NAME</tt>
#
# [*run_args*]
# String. The options sent to the run command.
# Defaults to <tt>agent -n repose-agent -c $CONFIG_DIRECTORY -f $CONFIG_DIRECTORY/cf-flume-conf.properties'</tt>
#
# [*java_home*] 
# String.  Set JAVA_HOME so flume can find java.
# Defaults to <tt>/usr/lib/jvm/jre-1.7.0-openjdk.x86_64</tt>
#
# === Examples
#
# This class may be imported by other classes to use its functionality:
#   class { 'flume_repose::service': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
# === Authors
#
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
# * Greg Sharek <mailto:greg.sharek@rackspace.com>
#
class flume_repose::service (
  $ensure          = $flume_repose::params::ensure,
  $enable          = $flume_repose::params::enable,
  $daemon_home     = $flume_repose::params::daemon_home,
  $user            = $flume_repose::params::user,
  $daemonize       = $flume_repose::params::daemonize,
  $start_args      = $flume_repose::params::start_args,
  $run_args        = $flume_repose::params::run_args,
  $java_home       = $flume_repose::params::java_home,
  ) inherits flume_repose::params {

  ### Validate

  validate_string( $daemon_home )
  validate_string( $user )
  validate_string( $daemonize )
  validate_string( $start_args )
  validate_string( $run_args )
  validate_string( $java_home )

  ### Logic
  
  ## set params: off
  if ! ($ensure in [ present, absent ]) {
    fail("\"${ensure}\" is not a valid ensure parameter value")
  }
  elsif $ensure == absent {
    $service_ensure = stopped
    ## set params: in operation
  } 
  else {
    $service_ensure = $enable ? {
      false   => stopped,
      true    => running,
      default => manual
    }
  }

  #### Set service files

  file { '/etc/sysconfig/flume-ng':
    ensure  => $flume_repose::file_ensure,
    owner   => root,
    group   => root,
    require => [ Package[ $flume_repose::params::package ] ],
    notify  => Service[ $flume_repose::params::service ],
  }
  
  # setup augeas with our shellvars lense
  Augeas {
    incl    => '/etc/sysconfig/flume-ng',
    require => File['/etc/sysconfig/flume-ng'],
    lens    => 'Shellvars.lns',
  }
  
  # default flume_repose sysconfig options
  $flume_repose_sysconfig = [
                             "set JAVA_HOME '${java_home}'",
                             "set DAEMON_HOME '${daemon_home}'",
                             "set LOG_PATH '${logdir}'",
                             "set PID_FILE '${pid_file}'",
                             "set USER '${user}'",
                             "set daemonize '${daemonize}'",
                             "set START_ARGS '\"${start_args}\"'",
                             "set RUN_ARGS '\"${run_args}\"'",
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
  
  ### Manage actions
  
  service { $flume_repose::params::service:
    ensure     => $service_ensure,
    enable     => $enable,
    hasstatus  => $flume_repose::params::service_hasstatus,
    hasrestart => $flume_repose::params::service_hasrestart,
  }
}
