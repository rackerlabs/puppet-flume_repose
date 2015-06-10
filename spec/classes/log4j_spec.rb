require 'spec_helper'
describe 'flume_repose::log4j' do
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
    context 'with defaults for all parameters' do
      it {
        should contain_file( '/opt/flume/conf/log4j.properties' ).with(
                   'ensure' => 'file',
                   'owner'  => 'flume',
                   'group'  => 'flume' ).
                   with_content( /org.apache.log4j.DailyRollingFileAppender/ ).
                   with_content( /log4j.rootLogger=WARN, defaultFile/ ).
                   without_content( /org.apache.log4j.net.SyslogAppender/ )
      }
    end

    # configure Syslog server
    context '' do
      let(:params) { {
          :syslog_server => "syslog_server",
          :syslog_port   => '100',
          :log_facility  => "local10"
      } }
      it {
        should contain_file( '/opt/flume/conf/log4j.properties' ).with(
                   'ensure' => 'file',
                   'owner'  => 'flume',
                   'group'  => 'flume' ).
                   with_content( /log4j.rootLogger=WARN, syslog, defaultFile/ ).
                   with_content( /org.apache.log4j.net.SyslogAppender/ ).
                   with_content( /log4j.appender.syslog.syslogHost=syslog_server:100/ ).
                   with_content( /log4j.appender.syslog.Facility=local10/ )
      }
    end

    #
  end
end