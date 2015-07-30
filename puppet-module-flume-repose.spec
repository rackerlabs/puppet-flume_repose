%define user rackerlabs
%define base_name flume_repose

Name:      puppet-module-%{user}-%{base_name}
Version:   1.0.1
Release:   1
BuildArch: noarch
Summary:   Puppet module to configure %{base_name}
License:   GPLv3+
URL:       http://github.com/rackerlabs/puppet-%{base_name}
Source0:   %{name}.tgz

%description
Flume-repose & cf-flume-sink are helper applications which Repose
leverages to post access events to Cloud Feeds.

%define module_dir /etc/puppet/modules/%{base_name}

%prep
%setup -q -c -n %{base_name}

%build

%install
mkdir -p %{buildroot}%{module_dir}
cp -pr * %{buildroot}%{module_dir}/

%files
%defattr (0644,root,root)
%{module_dir}

%changelog
