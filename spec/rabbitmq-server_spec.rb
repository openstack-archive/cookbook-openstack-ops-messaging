# encoding: UTF-8
require_relative 'spec_helper'

describe 'openstack-ops-messaging::rabbitmq-server' do
  before { ops_messaging_stubs }
  describe 'ubuntu' do
    before do
      @chef_run = ::ChefSpec::Runner.new ::UBUNTU_OPTS
      @chef_run.converge 'openstack-ops-messaging::rabbitmq-server'
    end

    it 'overrides default rabbit attributes' do
      expect(@chef_run.node['openstack']['mq']['port']).to eql '5672'
      expect(@chef_run.node['openstack']['mq']['listen']).to eql '127.0.0.1'
      expect(@chef_run.node['rabbitmq']['address']).to eql '127.0.0.1'
      expect(@chef_run.node['rabbitmq']['default_user']).to eql 'guest'
      expect(@chef_run.node['rabbitmq']['default_pass']).to eql 'rabbit-pass'
    end

    it 'overrides rabbit and openstack image attributes' do
      chef_run = ::ChefSpec::Runner.new ::UBUNTU_OPTS do |n|
        n.set['openstack']['mq']['bind_interface'] = 'eth0'
        n.set['openstack']['mq']['port'] = '4242'
        n.set['openstack']['mq']['user'] = 'foo'
        n.set['openstack']['mq']['vhost'] = '/bar'
      end

      chef_run.converge 'openstack-ops-messaging::rabbitmq-server'

      expect(chef_run.node['openstack']['mq']['listen']).to eql '33.44.55.66'
      expect(chef_run.node['openstack']['mq']['port']).to eql '4242'
      expect(chef_run.node['openstack']['mq']['user']).to eql 'foo'
      expect(chef_run.node['openstack']['mq']['vhost']).to eql '/bar'
      expect(chef_run.node['openstack']['image']['rabbit']['port']).to eql '4242'
      expect(chef_run.node['openstack']['image']['rabbit']['username']).to eql 'foo'
      expect(chef_run.node['openstack']['image']['rabbit']['vhost']).to eql '/bar'
    end

    describe 'cluster' do
      before do
        @chef_run = ::ChefSpec::Runner.new(::UBUNTU_OPTS) do |n|
          n.set['openstack']['mq'] = {
            'cluster' => true
          }
        end
        @chef_run.converge 'openstack-ops-messaging::rabbitmq-server'
      end

      it 'overrides cluster' do
        expect(@chef_run.node['rabbitmq']['cluster']).to be_true
      end

      it 'overrides erlang_cookie' do
        expect(@chef_run.node['rabbitmq']['erlang_cookie']).to eql(
          'erlang-cookie'
        )
      end

      it 'overrides and sorts cluster_disk_nodes' do
        expect(@chef_run.node['rabbitmq']['cluster_disk_nodes']).to eql(
          ['guest@host1', 'guest@host2']
        )
      end
    end

    it 'includes rabbit recipes' do
      expect(@chef_run).to include_recipe 'rabbitmq'
      expect(@chef_run).to include_recipe 'rabbitmq::mgmt_console'
    end

    describe 'lwrps' do
      it 'does not delete the guest user' do
        expect(@chef_run).not_to delete_rabbitmq_user('remove rabbit guest user')
      end

      it "deletes a user not called 'guest'" do
        chef_run = ChefSpec::Runner.new(::UBUNTU_OPTS) do |node|
          node.node.set['openstack']['mq']['user'] = 'not-a-guest'
        end.converge('openstack-ops-messaging::rabbitmq-server')

        expect(chef_run).to delete_rabbitmq_user('remove rabbit guest user')
      end

      it 'adds user' do
        resource = @chef_run.find_resource(
          'rabbitmq_user',
          'add openstack rabbit user'
        ).to_hash

        expect(resource).to include(
          user: 'guest',
          password: 'rabbit-pass',
          action: [:add]
        )
      end

      it 'changes password' do
        resource = @chef_run.find_resource(
          'rabbitmq_user',
          'change openstack rabbit user password'
        ).to_hash

        expect(resource).to include(
          user: 'guest',
          password: 'rabbit-pass',
          action: [:change_password]
        )
      end

      it 'adds vhost' do
        resource = @chef_run.find_resource(
          'rabbitmq_vhost',
          'add openstack rabbit vhost'
        ).to_hash

        expect(resource).to include(
          vhost: '/',
          action: [:add]
        )
      end

      it 'sets user permissions' do
        resource = @chef_run.find_resource(
          'rabbitmq_user',
          'set openstack user permissions'
        ).to_hash

        expect(resource).to include(
          user: 'guest',
          vhost: '/',
          permissions: '.* .* .*',
          action: [:set_permissions]
        )
      end

      it 'sets administrator tag' do
        resource = @chef_run.find_resource(
          'rabbitmq_user',
          'set rabbit administrator tag'
        ).to_hash

        expect(resource).to include(
          user: 'guest',
          tag: 'administrator',
          action: [:set_tags]
        )
      end
    end
  end
end
