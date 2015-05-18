# == Class: flume_repose::params
#
# This class exists to
# 1. Declutter the default value assignment for class parameters.
# 2. Manage internally used module variables in a central place.
#
# Therefore, many operating system dependent differences (names, paths, ...)
# are addressed in here.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class is not intended to be used directly.
#
#
# === Links
#
#
# === Authors
#
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * Greg Sharek <mailto:greg.sharek@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
class flume_repose::params {

## ensure
  $ensure = present
  
## enable
  $enable = true

### Package specific in

## service
  $service = $::osfamily ? {
    /(RedHat|Debian)/ => 'flume-ng',
  }

## service capabilities
  $service_hasstatus = $::osfamily ? {
    /(RedHat|Debian)/ => true,
  }

  $service_hasrestart = $::osfamily ? {
    /(RedHat|Debian)/ => true,
  }

## packages
  $packages = $::osfamily ? {
    /(RedHat|Debian)/ => [ 'cf-flume-sink' ],
  }

## configdir
  $configdir = $::osfamily ? {
    /(RedHat|Debian)/ => '/opt/flume/conf',
  }

## logdir
  $logdir = $::osfamily ? {
    /(RedHat|Debian)/ => '/var/log/flume',
  }

## owner
  $owner = $::osfamily ? {
    /(RedHat|Debian)/ => flume,
  }

## group
  $group = $::osfamily ? {
    /(RedHat|Debian)/ => flume,
  }

## mode
  $mode = $::osfamily ? {
    /(RedHat|Debian)/ => '0660',
  }

## dirmode
  $dirmode = $::osfamily ? {
    /(RedHat|Debian)/ => '0750',
  }

## sourcedir
  $sourcedir = "puppet:///modules/${module_name}"

## daemon_home for valve
  $daemon_home = '/opt/flume'

## pid file for valve
  $pid_file = '/var/run/flume-ng.pid'

## user for valve
  $user = 'flume'

## flume_repose package
  $package = $::osfamily ? {
    /(RedHat|Debian)/ => 'flume-repose',
  }

## daemonize bin for repose-valve
  $daemonize = '/usr/sbin/daemonize'

## daemonize opts for repose-valve
  $daemonize_opts = '-c $DAEMON_HOME -p $PID_FILE -u $USER -o $LOG_PATH/stdout.log -e $LOG_PATH/stderr.log -l /var/lock/subsys/$NAME'

## run ops for repose-valve
  $run_opts = 'agent -n repose-agent -c $CONFIG_DIRECTORY -f $CONFIG_DIRECTORY/cf-flume-conf.properties'


## syslog_port
   $syslog_port = 514

## syslog_protocol
  $syslog_protocol = 'udp'

## logging configuration file
  $logging_configuration = 'log4j.properties'

## default log level
  $log_level = 'WARN'

## default local log policy
  $log_local_policy = 'date'

## default local log size
  $log_local_size = '100MB'

## default local log rotation count
  $log_local_rotation_count = 4

## default repose.log syslog facility
  $log_repose_facility = 'local0'

## default http access log syslog facility
  $log_access_facility = 'local1'

## default http access log syslog app name
  $log_access_app_name = ''

## default access logging locally
  $log_access_local = true

## default access log local filename
  $log_access_local_name = 'http_repose'

## default access logging to syslog
  $log_access_syslog = true
}