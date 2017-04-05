# == Class: flume_repose:log4j
#
# Manages the log4j.properties files. Enables local & syslog logging.
#
#
# == Parameters
#
# The default values for the parameters are set in flume_repose::params. Have
# a look at the corresponding <tt>params.pp</tt> manifest file if you need more
# technical information about them.
#
# [*ensure*]
# Bool. Ensure configuraiton file is present/absent.
# Defaults to <tt>present</tt>
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

class flume_repose::log4j (
  $ensure                   = $flume_repose::params::ensure,
  $syslog_server            = undef,
  $syslog_port              = $flume_repose::params::syslog_port,
  $log_level                = $flume_repose::params::log_level,
  $log_local_policy         = $flume_repose::params::log_local_policy,
  $log_local_size           = $flume_repose::params::log_local_size,
  $log_local_rotation_count = $flume_repose::params::log_local_rotation_count,
  $logdir                   = $flume_repose::params::logdir,
  $log_facility             = $flume_repose::params::log_facility,
  ) inherits flume_repose::params {

  ### Validate
    
  validate_string( $syslog_server )
  validate_string( $syslog_port )
  validate_string( $log_level )
  validate_string( $log_local_policy )
  validate_string( $log_local_size )
  validate_string( $log_local_rotation_count )
  validate_string( $logdir )
  validate_string( $log_facility )

  if ! ($ensure in [ present, absent ]) {
    fail("\"${ensure}\" is not a valid ensure parameter value")
    } else {
    $file_ensure = $ensure ? {
      present => file,
      absent  => absent,
    }
  }
  debug("\$ensure = '${ensure}'")
  
  $logging_configuration_file = "${flume_repose::params::configdir}/log4j.properties"
  
  $template = template( "${module_name}/log4j.properties.erb" )
  
  file { $logging_configuration_file:
    ensure   => $file_ensure,
    owner   => flume,
    group   => flume,
    require => [ Package[ $flume_repose::params::package ] ],
    content => $template
  }
}
