# == Class: flume_repose::flume_env
#
# This is a class for managing the flume_env.sh file
#
# === Parameters
#
# [*ensure*]
# Bool. Ensure configuraiton file is present/absent.
# Defaults to <tt>present</tt>
#
# [*java_opts*]
# String. Set arguments for the JVM process.
# Defaults to <tt>-Xms100m -Xmx200m</tt>
#
# === Examples
#
# === Authors
#
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
# * Greg Sharek <mailto:greg.sharek@rackspace.com>
#

class flume_repose::flume_env (
  $ensure    = present,                                   
  $java_opts = $flume_repose::params::java_opts,
  ) inherits flume_repose::params {
  
  ### Validate parameters
  
  validate_string( $java_opts )
  
  ## ensure
  if ! ($ensure in [ present, absent ]) {
    fail("\"${ensure}\" is not a valid ensure parameter value")
    } else {
    $file_ensure = $ensure ? {
      present => file,
      absent  => absent,
    }
  }
  debug("\$ensure = '${ensure}'")
    
  $flume_env_path = "${flume_repose::params::configdir}/flume-env.sh"          
  $template = template( "${module_name}/flume-env.sh.erb" )
  
  file { "${flume_env_path}":
    ensure  => $file_ensure,
    owner   => flume,
    group   => flume,
    require => [ Package[ $flume_repose::params::package ] ],
    content => $template
  }
}
  
