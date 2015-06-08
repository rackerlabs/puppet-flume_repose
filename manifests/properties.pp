#
# == Class: flume_repose::properties
#
# This class definesthe cf-flume-sink.properties file which configures flume 
# and the cf-flume-sink.
#
#
# === Parameters
#
# [*ensure*]
# String. Controls if the managed resources shall be <tt>present</tt> or
# <tt>absent</tt>.  If set to <tt>absent</tt>:
# Defaults to <tt>present</tt>
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
# [*channel_checkpoint*]
# Defaults to <tt>channel_checkpoint</tt>
#
# [*channel_dataDirs*]
# Defaults to <tt>channel_dataDirs</tt>
#
# === Examples
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
class flume_repose::properties (
  $ensure                 = present,
  $source_type            = $flume_repose::params::source_type,
  $source_bind            = $flume_repose::params::source_bind,
  $source_port            = $flume_repose::params::source_port,

  $sink_identity_endpoint = undef,
  $sink_identity_user     = undef,
  $sink_identity_pwd      = undef,
  $sink_feed_endpoint     = undef,
  
  $sink_timeout           = $flume_repose::params::sink_timeout,
  $sink_cookie_policy     = $flume_repose::params::sink_cookie_policy,
  $sink_handle_redirects  = $flume_repose::params::sink_handle_redirects,

  $channel_type           = $flume_repose::params::channel_type,
  $channel_checkpoint     = $flume_repose::params::channel_checkpoint,
  $channel_dataDirs       = $flume_repose::params::channel_dataDirs,                             
  ) inherits flume_repose::params {

  ### Validate parameters

  debug( "source_port: ${source_port}" )
  
  validate_string( $source_type )
  validate_string( $source_bind )
  #  until we update our version of stdlib
  #  validate_integer( $source_port )
  validate_string( $sink_identity_endpoint )
  validate_string( $sink_identity_user )
  validate_string( $sink_identity_pwd )
  validate_string( $sink_identity_feed_endpoint )
  #  until we update our version of stdlib
  #  validate_integer( $sink_timeout )
  validate_string( $sink_cookie_policy )
  validate_string( $sink_handle_redirects )
  validate_string( $channel_type )
  validate_string( $channel_checkpoint )
  validate_string( $channel_dataDirs )
  
  ## ensure
  
  if ! ($ensure in [ present, absent ]) {
    fail("\"${ensure}\" is not a valid ensure parameter value")
    } else {
    $file_ensure = $ensure ? {
      present => file,
      absent  => absent,
    }
  }
  
  if $::debug {
    debug("\$ensure = '${ensure}'")
  }
  
  $config_path = "${flume_repose::params::configdir}/cf-flume-conf.properties"
  
  $template = template( "${module_name}/cf-flume-conf.properties.erb" )
  
  file { "${config_path}":
    ensure  => $file_ensure,
    owner   => $flume_repose::params::owner,
    group   => $flume_repose::params::group,
    require => [ Package[ $flume_repose::params::package ] ],
    content => $template
  }
}
