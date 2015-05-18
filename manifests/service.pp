# == Class: repose::service
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
  $ensure = $flume_repose::params::ensure,
  $enable = $flume_repose::params::enable,
) inherits flume_repose::params {

### Logic

## set params: off
  if $ensure == absent {
    $service_ensure = stopped
## set params: in operation
  } else {
    $service_ensure = $enable ? {
      false   => stopped,
      true    => running,
      default => manual
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