require 'spec_helper'
describe 'flume_repose::flume_repose' do
  context 'on RedHat' do
  let :facts do
    {
        :osfamily               => 'RedHat',
        :operationsystemrelease => '6',
    }
  end

  # the defaults for the init class should be
  # 1) install package
  # 2) configure service
  # 3) configure flume
  context 'with defaults for all parameters' do
    it {
      should contain_class( 'flume_repose::service' ).with_ensure( 'present' )
      should contain_class( 'flume_repose::package' ).with_ensure( 'present' )
      should contain_file( '/opt/flume/conf/cf-flume-conf.properties' ).with(
                 'ensure' => 'file',
                 'owner'  => 'flume',
                 'group'  => 'flume' )
      should contain_file( '/opt/flume/conf/flume-env.sh' ).with(
                 'ensure' => 'file',
                 'owner'  => 'flume',
                 'group'  => 'flume' )
      should contain_file( '/opt/flume/conf/log4j.properties' ).with(
                 'ensure' => 'file',
                 'owner'  => 'flume',
                 'group'  => 'flume' )
    }
  end

  # validate uninstall properly passes ensure = absent around
  context 'uninstall parameters' do
    let(:params) { { :ensure => 'absent' }}
    it {
      should contain_class( 'flume_repose::service' ).with_ensure( 'absent' )
      should contain_class( 'flume_repose::package' ).with_ensure( 'absent' )
      should contain_file( '/opt/flume/conf/cf-flume-conf.properties' ).with(
                 'ensure' => 'absent',
                 'owner'  => 'flume',
                 'group'  => 'flume' )
       should contain_file( '/opt/flume/conf/flume-env.sh' ).with(
                  'ensure' => 'absent',
                  'owner'  => 'flume',
                  'group'  => 'flume' )
       should contain_file( '/opt/flume/conf/log4j.properties' ).with(
                  'ensure' => 'absent',
                  'owner'  => 'flume',
                  'group'  => 'flume' )
    }
  end
  end
end
