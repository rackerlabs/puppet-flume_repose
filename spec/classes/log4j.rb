asdfasdfasxdfrequire 'spec_helper'
describe 'flume_repose::log4jAAAA' do
  context 'on RedHat' do
    let :facts do
      {
          :osfamily => 'RedHat',
          :operationsystemrelease => '6'
      }
    end

    # defaults for log4j
    # 1) specify config file
    # 2) no syslog
    # 3) Date
    contextAA 'with defaults for all parameters' do
      it {
        should contain_file( '/opt/flume/conf/log4j.properties' ).with(
                   'ensure' => 'file',
                   'owner'  => 'flume',
                   'group'  => 'flume' ).
                   with_content( /org.apache.log4j.DailyRollingFileAppenderAAAAA/ ).
                   with_content( /log4j.rootLogger=defaultFile/ ).
                   without_content( /org.apache.log4j.net.SyslogAppender/ )
      }
    end


    # configure Syslog server

  end
  end