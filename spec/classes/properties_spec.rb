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
        should contain_file( '/opt/flume/conf/cf-flume-conf.properties' ).with(
                   'ensure' => 'file',
                   'owner'  => 'flume',
                   'group'  => 'flume' ).
                   with_content( /repose-agent.sources.r1.type = avro/ ).
                   with_content( /repose-agent.sources.r1.bind = localhost/ ).
                   with_content( /repose-agent.sources.r1.port = 10000/ ).
                   with_content( /repose-agent.sinks.k1.feeds.properties.CONNECTION_TIMEOUT = 900/ ).
                   with_content( /repose-agent.sinks.k1.feeds.properties.COOKIE_POLICY = IGNORE_COOKIES/ ).
                   with_content( /repose-agent.sinks.k1.feeds.properties.HANDLE_REDIRECTS = false/ ).
                   with_content( /repose-agent.channels.c1.type = file/ ).
                   with_content( /repose-agent.channels.c1.checkpointDir = \/mnt\/flume\/checkpoint/ ).
                   with_content( /repose-agent.channels.c1.dataDirs = \/mnt\/flume\/data/ )
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
        should contain_file( '/opt/flume/conf/cf-flume-conf.properties' ).with(
                   'ensure' => 'file',
                   'owner'  => 'flume',
                   'group'  => 'flume' ).
                   with_content( /repose-agent.sinks.k1.identity.endpoint = sink_identity_endpoint/ ).
                   with_content( /repose-agent.sinks.k1.identity.username = sink_identity_user/ ).
                   with_content( /repose-agent.sinks.k1.identity.password = sink_identity_pwd/ ).
                   with_content( /repose-agent.sinks.k1.feeds.endpoint = sink_feed_endpoint/ )
      }
    end

    # set all parameters and event size
    context 'set all parameters and event size' do
      let(:params) {{
          :sink_identity_endpoint => 'sink_identity_endpoint',
          :sink_identity_user => 'sink_identity_user',
          :sink_identity_pwd => 'sink_identity_pwd',
          :sink_feed_endpoint => 'sink_feed_endpoint',
          :source_event_size => 'source_event_size',
      }}
      it {
        should contain_file( '/opt/flume/conf/cf-flume-conf.properties' ).with(
                   'ensure' => 'file',
                   'owner'  => 'flume',
                   'group'  => 'flume' ).
                   with_content( /repose-agent.sinks.k1.identity.endpoint = sink_identity_endpoint/ ).
                   with_content( /repose-agent.sinks.k1.identity.username = sink_identity_user/ ).
                   with_content( /repose-agent.sinks.k1.identity.password = sink_identity_pwd/ ).
                   with_content( /repose-agent.sinks.k1.feeds.endpoint = sink_feed_endpoint/ ).
                   with_content( /repose-agent.sources.r1.eventSize = source_event_size/ )
      }
    end
  end
end
