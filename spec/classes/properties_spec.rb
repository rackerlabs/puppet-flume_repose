require 'spec_helper'
describe 'flume_repose::properties' do
  context 'on RedHat' do
    let :facts do
      {
          :osfamily               => 'RedHat',
          :operationsystemrelease => '6'
      }
    end

    # defaults for the properties class
    # 1) specify the config file
    # 2) set defaults
    context 'with defaults for all parameters' do
      it {
        should contain_file( '/opt/flume/conf/cf-flume-conf.properties' )
      }
    end

    # set all parameters
    context 'set all parameters' do
      let(:params) {{
          :sink_identity_endpoint => 'sink_identity_endpoint',
          :sink_identity_user => 'sink_identity_user',
          :sink_identity_pwd => 'sink_identity_pwd',
          :sink_feed_endpoint => 'sink_feed_endpoint',
      }}
      it {

      }
    end
  end
end