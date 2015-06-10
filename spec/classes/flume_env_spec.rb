require 'spec_helper'
describe 'flume_repose::flume_env' do
  context 'on RedHat' do
    let :facts do
      {
          :osfamily => 'RedHat',
          :operationssystemreleaes => '6'
      }
    end

    # defaults for the log4j class
    # 1) specify the config file
    # 2) set JAVA_OPTS
    context 'with defaults for all parameters' do
      it {
        should contain_file( '/opt/flume/conf/flume-env.sh' ).with(
            'ensure' => 'file',
            'owner'  => 'flume',
            'group'  => 'flume' ).
            with_content( /JAVA_OPTS="-Xms100m -Xmx200m"/ )
      }
    end

  end
end