require 'spec_helper'
describe 'flume_repose::package' do
  context 'on RedHat' do
    let :facts do
    {
      :osfamily               => 'RedHat',
      :operationsystemrelease => '6'
    }
  end

  # the defaults for the package class should
  # 1) Install flume-repose & cf-flume-sink
  context 'with defaults for all parameters' do
    it {
      should contain_package( 'flume-repose' ).with_ensure( 'present' )
      should contain_package( 'cf-flume-sink' ).with_ensure( 'present' )
    }
  end

  # validate uninstall properly purged packages
  context 'uninstall parameters' do
    let(:params) {{ :ensure => 'absent' }}
    it {
     should contain_package( 'flume-repose' ).with_ensure( 'purged' )
     should contain_package( 'cf-flume-sink' ).with_ensure( 'purged' )
    }
  end

  end
end