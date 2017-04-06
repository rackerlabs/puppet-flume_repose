# == Class: flume_repose::package
#
# This class exists to coordinate all software package management related
# actions, functionality and logical units in a central place.
#
#
# === Parameters
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
#
# === Examples
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

class flume_repose::package (
  $ensure            = $flume_repose::params::ensure,
  $install_daemonize = false,
  ) inherits flume_repose::params {

  ### Logic

  ## set params: removal
  if ! ($ensure in [ present, absent ]) {
    fail("\"${ensure}\" is not a valid ensure parameter value")
  }
  elsif $ensure == absent {
    $package_ensure = purged
    ## set params: in operation
  } 
  else {
    $package_ensure = $ensure
  }

  ### Manage actions
  
  package { $flume_repose::params::package:
    ensure  => $package_ensure,
    before  => Service[ $flume_repose::params::service ],
  }
  
  package { $flume_repose::params::packages:
    ensure   => $package_ensure,
    require  => Package[ $flume_repose::params::package ],
  } 

  if $install_daemonize {
    package { 'daemonize':
      ensure  => $package_ensure,
      before  => Service[ $flume_repose::params::service ],
    }
  }
}
