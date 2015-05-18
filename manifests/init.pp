# == Class: flume_repose
#
# This class is able to install or remove repose on a node.
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
# === Authors
#
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
# * Greg Sharek <mailto:greg.sharek@rackspace.com>
#

class flume_repose (
  $ensure       = $flume_repose::params::ensure,
  $ensure       = $flume_repose::params::ensure,
  $enable       = $flume_repose::params::enable,
) inherits flume_repose::params {

### Validate parameters

## ensure
  if ! ($ensure) {
    fail("\"${ensure}\" is required. It should be present, absent")
  } else if !($ensure == "absent" or $ensure == "present" ) {
    fail("\"${ensure}\" is required. It should be present, absent")
  } else {
    $file_ensure = $ensure ? {
      absent  => absent,
      default => file,
    }
    $dir_ensure = $ensure ? {
      absent  => absent,
      default => directory,
    }
  }
  if $::debug {
    if $ensure != $flume_repose::params::ensure {
      debug('$ensure overridden by class parameter')
    }
    debug("\$ensure_flume = '${ensure}'")
  }

## enable - we don't validate because all standard options are acceptable
  if $::debug {
    if $enable != $flume_repose::params::enable {
      debug('$enable overridden by class parameter')
    }
    debug("\$enable = '${enable}'")
  }

### Manage actions

## package(s)
  class { 'flume_repose::package':
    ensure       => $ensure,
  }
}