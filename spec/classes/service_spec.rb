require 'spec_helper'
describe 'flume_repose::service' do

  context 'on RedHat' do
    let :facts do
      {
          :osfamily                => 'RedHat',
          :operationssystemrelease => '6',
      }
    end

    # the defaults for the service class should
    # 1) ensures the service is running
    context 'with defaults for all parameters' do
      it {
        should contain_service( 'flume-ng' ).with_ensure( 'running' )
      }
    end

    # validate ensure is absent properly stops services
    context 'ensure is absent' do
      let(:params) {{ :ensure => 'absent' }}
      it {
        should contain_service( 'flume-ng' ).with_ensure( 'stopped' )
      }
    end

    # Validate ensure present but enable is false stopped service
    context 'ensure is present but enable is off' do
      let(:params) { { :ensure => 'absent', :enable => false } }
      it {
        should contain_service('flume-ng').with(
                   'ensure' => 'stopped',
                   'enable' => false)
      }
    end

    # Validate ensure present but enable is manual
    context 'ensure is present but enable is off' do
      let(:params) { { :ensure => 'absent', :enable => 'manual' } }
      it {
        should contain_service('flume-ng').with(
                   'ensure' => 'stopped',
                   'enable' => 'manual')
      }
    end
    end
end
