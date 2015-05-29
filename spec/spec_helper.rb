# encoding: UTF-8
require 'chefspec'
require 'chefspec/berkshelf'

ChefSpec::Coverage.start! { add_filter 'openstack-ops-messaging' }

LOG_LEVEL = :fatal
REDHAT_OPTS = {
  platform: 'redhat',
  version: '7.1',
  log_level: LOG_LEVEL
}
UBUNTU_OPTS = {
  platform: 'ubuntu',
  version: '14.04',
  log_level: LOG_LEVEL
}
SUSE_OPTS = {
  platform: 'suse',
  version: '11.3',
  log_level: ::LOG_LEVEL
}

shared_context 'ops_messaging_stubs' do
  before do
    allow_any_instance_of(Chef::Recipe).to receive(:address_for)
      .with('lo')
      .and_return '127.0.0.1'
    allow_any_instance_of(Chef::Recipe).to receive(:address_for)
      .with('eth0')
      .and_return '33.44.55.66'
    allow_any_instance_of(Chef::Recipe).to receive(:search)
      .with(:node, 'roles:os-ops-messaging AND chef_environment:_default')
      .and_return [
        { 'hostname' => 'host2' },
        { 'hostname' => 'host1' }
      ]
    allow_any_instance_of(Chef::Recipe).to receive(:get_password)
      .with('user', anything)
      .and_return 'rabbit-pass'
    allow_any_instance_of(Chef::Recipe).to receive(:get_password)
      .with('service', 'rabbit_cookie')
      .and_return 'erlang-cookie'
  end
end
