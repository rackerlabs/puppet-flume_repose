# == Class: flume_repose
#
# This class is able to install or remove flume-repose & cf-flume-sink on a node.
#
#
# === Parameters
#
# The default values for the parameters are set in flume_repose::params. Have
# a look at the corresponding <tt>params.pp</tt> manifest file if you need more
# technical information about them.
#
# 
# [*ensure*]
# String. Controls if the managed resources shall be <tt>present</tt> or
# <tt>absent</tt>.  If set to <tt>absent</tt>:
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
# [*install_daemonize*]
# Boolean. Whether or not to install the daemonize package
# Defaults to <tt>false</tt>
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
# [*source_type*]
# Defaults to <tt>source_type</tt>
#
# [*source_bind*]
# Defaults to <tt>source_bind</tt>
#
# [*source_port*]
# Defaults to <tt>source_port</tt>
#
# [*source_event_size*]
# Defaults to <tt>source_event_size</tt>
#
# [*sink_identity_endpoint*]
# The identity endpoint to authenticate against (hostname only).
# Defaults to <tt>undef</tt>
#
# [*sink_identity_user*]
# The identity user to use to post to Clodu Feeds.
# Defaults to <tt>undef</tt>
#
# [*sink_identity_pwd*]
# The password for the sink_identity_user.
# Defaults to <tt>undef</tt>
#
# [*sink_feed_endpoint*]
# The Cloud Feeds feed endpoint where the user access events are to be posted.
# Defaults to <tt>undef</tt>
#
# [*sink_timeout*]
# Defaults to <tt>sink_timeout</tt>
#
# [*sink_cookie_policy*]
# Defaults to <tt>sink_cookie_policy</tt>
#
# [*sink_handle_redirects*]
# Defaults to <tt>sink_handle_redirects</tt>
#
# [*channel_type*]
# Defaults to <tt>channel_type</tt>
#
# [*java_opts*]
# String. Set arguments for the JVM process.
# Defaults to <tt>-Xms100m -Xmx200m</tt>
#
# [*syslog_server*]
# String.  Syslog server  If provided enable sys logging to the given
# server.
# Defaults to <tt>undef</tt>.
#
# [*syslog_port*]
# String.  Port for the syslog server.
# Defaults to <tt>syslog_port</tt>.
#
# [*log_level*]
# String.
# Defaults to <tt>log_level</tt>
#
# [*log_local_policy*]
# String.
# Defaults to <tt>log_local_policy</tt>
#
# [*log_local_size*]
# String.
# Defaults to <tt>log_local_size</tt>
#
# [*log_local_rotation_count*]
# String.
# Defaults to <tt>log_local_rotation_count</tt>
#
# [*logdir*]
# String.
# Defaults to <tt>logdir</tt>
#
# [*log_facility*]
# String.
# Defaults to <tt>log_facility</tt>
#
# === Authors
#
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
# * Greg Sharek <mailto:greg.sharek@rackspace.com>
#

class flume_repose::flume_repose (
  $ensure                   = $flume_repose::params::ensure,
  $enable                   = $flume_repose::params::enable,
  
  ## service
  $daemon_home              = $flume_repose::params::daemon_home,
  $user                     = $flume_repose::params::user,
  $install_daemonize        = $flume_repose::params::install_daemonize,
  $daemonize                = $flume_repose::params::daemonize,
  $start_args               = $flume_repose::params::start_args,
  $run_args                 = $flume_repose::params::run_args,
  $java_home                = $flume_repose::params::java_home,
  
  ## cf-flume-sink.properties
  $source_type              = $flume_repose::params::source_type,
  $source_bind              = $flume_repose::params::source_bind,
  $source_port              = $flume_repose::params::source_port,
  $source_event_size        = $flume_repose::params::source_event_size,

  $sink_identity_endpoint   = undef,
  $sink_identity_user       = undef,
  $sink_identity_pwd        = undef,
  $sink_feed_endpoint       = undef,
 
  $sink_timeout             = $flume_repose::params::sink_timeout,
  $sink_cookie_policy       = $flume_repose::params::sink_cookie_policy,
  $sink_handle_redirects    = $flume_repose::params::sink_handle_redirects,

  $channel_type             = $flume_repose::params::channel_type,

  ## flume_env.sh
  $java_opts                = $flume_repose::params::java_opts,

  ## logf4j
  $syslog_server            = undef,
  $syslog_port              = $flume_repose::params::syslog_port,
  $log_level                = $flume_repose::params::log_level,
  $log_local_policy         = $flume_repose::params::log_local_policy,
  $log_local_size           = $flume_repose::params::log_local_size,
  $log_local_rotation_count = $flume_repose::params::log_local_rotation_count,
  $logdir                   = $flume_repose::params::logdir,
  $log_facility             = $flume_repose::params::log_facility,

  ) inherits flume_repose::params {

  ## enable - we don't validate because all standard options are acceptable
  if $enable != $flume_repose::params::enable {
    debug('$enable overridden by class parameter')
  } else {
    debug("\$enable = '${enable}'")
  }
  
  ### Manage actions
  
  ## service
  class { 'flume_repose::service':
    ensure         => $ensure,
    enable         => $enable,
    daemon_home    => $daemon_home,
    user           => $user,
    daemonize      => $daemonize,
    start_args     => $start_args,
    run_args       => $run_args,
    java_home      => $java_home,
  }
  
  ## package(s)
  class { 'flume_repose::package':
    ensure            => $ensure,
    install_daemonize => $install_daemonize
  }
  
  ## configuration files
  class { 'flume_repose::properties':
    ensure                 => $ensure,
    source_type            => $source_type,
    source_bind            => $source_bind, 
    source_port            => $source_port, 
    source_event_size      => $source_event_size,
    sink_identity_endpoint => $sink_identity_endpoint,
    sink_identity_user     => $sink_identity_user,         
    sink_identity_pwd      => $sink_identity_pwd,
    sink_feed_endpoint     => $sink_feed_endpoint,
    sink_timeout           => $sink_timeout,
    sink_cookie_policy     => $sink_cookie_policy,
    sink_handle_redirects  => $sink_handle_redirects,
    channel_type           => $channel_type,
  }
  
  class { 'flume_repose::flume_env':
    ensure    => $ensure,
    java_opts => $java_opts
  }
  
  class { 'flume_repose::log4j':
    ensure        => $ensure,
    syslog_server => $syslog_server,
    syslog_port   => $syslog_port
  }
}
  
