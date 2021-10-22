require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
  config.log_level = :warn
end

REDHAT_7 = {
  platform: 'redhat',
  version: '7',
}.freeze

REDHAT_8 = {
  platform: 'redhat',
  version: '8',
}.freeze

ALL_RHEL = [
  REDHAT_7,
  REDHAT_8,
].freeze

UBUNTU_OPTS = {
  platform: 'ubuntu',
  version: '18.04',
}.freeze

shared_context 'ops_messaging_stubs' do
  before do
    allow_any_instance_of(Chef::Recipe).to receive(:address_for)
      .with('lo')
      .and_return '127.0.0.1'
    allow_any_instance_of(Chef::Recipe).to receive(:address_for)
      .with('enp0s3')
      .and_return '33.44.55.66'
    allow_any_instance_of(Chef::Recipe).to receive(:search)
      .with(:node, 'recipes:openstack-ops-messaging\\:\\:rabbitmq-server AND chef_environment:_default')
      .and_return [
        { 'hostname' => 'host2' },
        { 'hostname' => 'host1' },
      ]
    allow_any_instance_of(Chef::Recipe).to receive(:get_password)
      .with('user', anything)
      .and_return 'rabbit-pass'
    allow_any_instance_of(Chef::Recipe).to receive(:get_password)
      .with('service', 'rabbit_cookie')
      .and_return 'erlang-cookie'
  end
end
