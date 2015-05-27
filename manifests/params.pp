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
  
  ### service params
  
  ## service
  $service = $::osfamily ? {
    /(RedHat|Debian)/ => 'flume-ng',
  }
  
  ## daemon_home for valve
  $daemon_home = '/opt/flume'

  ## pid file for valve
  $pid_file = '/var/run/flume-ng.pid'

  ## JAVA_HOME
  $java_home = '/usr/lib/jvm/jre-1.7.0-openjdk.x86_64'

  ## daemonize bin for repose-valve
  $daemonize = '/usr/sbin/daemonize'
  
  ## daemonize opts for repose-valve
  $start_args = '-c $DAEMON_HOME -p $PID_FILE -u $USER -o $LOG_PATH/stdout.log -e $LOG_PATH/stderr.log -l /var/lock/subsys/$NAME'

  ## run ops for repose-valve
  $run_args = 'agent -n repose-agent -c $CONFIG_DIRECTORY -f $CONFIG_DIRECTORY/cf-flume-conf.properties'
  
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
  
  ## sourcedir
  $sourcedir = "puppet:///modules/${module_name}"
  
  ## user for valve
  $user = 'flume'
  
  ## flume_repose package
  $package = $::osfamily ? {
    /(RedHat|Debian)/ => 'flume-repose',
  }
  
  ### log4j.properties

  ## syslog_port
   $syslog_port = 514

  ## default log level
  $log_level = 'WARN'
  
  ## default local log policy
  $log_local_policy = 'date'
  
  ## default local log size
  $log_local_size = '100MB'
  
  ## default local log rotation count
  $log_local_rotation_count = 4
  
  ## default syslog facility
  $log_facility = 'local4'
  
  ### cf-flume-sink.properties
  
  $source_type = 'avro'
  $source_bind = 'localhost'
  $source_port = 10000
  $sink_timeout = 900
  $sink_cookie_policy = 'IGNORE_COOKIES'
  $sink_handle_redirects= 'false'
  $channel_type = 'file'
  $channel_checkpoint = '/mnt/flume/checkpoint'
  $channel_dataDirs = '/mnt/flume/data'

  ### flume_env.sh 

  $java_opts = '-Xms100m -Xmx200m'

}
