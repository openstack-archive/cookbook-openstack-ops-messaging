require_relative 'spec_helper'

describe 'openstack-ops-messaging::server' do
  describe 'ubuntu' do

    before do
      messaging_stubs
    end

    it "select 'rabbitmq-server' recipe" do
      chef_run = ::ChefSpec::ChefRunner.new(::UBUNTU_OPTS) do |node|
        node.set['lsb'] = {'codename' => 'precise'}
        node.set['openstack'] = {
          'messaging' => {
            'service' => 'rabbitmq'
          }
        }
        node.set['rabbitmq'] = {
          'erlang_cookie_path' => '/path/to/nowhere'
        }
      end
      chef_run.converge 'openstack-ops-messaging::server'
      expect(chef_run).to include_recipe "openstack-ops-messaging::rabbitmq-server"
    end

  end
end
