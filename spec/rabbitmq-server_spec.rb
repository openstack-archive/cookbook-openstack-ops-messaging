# encoding: UTF-8
require_relative 'spec_helper'

describe 'openstack-ops-messaging::rabbitmq-server' do
  describe 'ubuntu' do
    let(:runner) { ChefSpec::Runner.new(UBUNTU_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) { runner.converge(described_recipe) }

    include_context 'ops_messaging_stubs'

    it 'overrides default rabbit attributes' do
      expect(chef_run.node['openstack']['mq']['port']).to eq('5672')
      expect(chef_run.node['openstack']['mq']['listen']).to eq('127.0.0.1')
      expect(chef_run.node['rabbitmq']['address']).to eq('127.0.0.1')
      expect(chef_run.node['rabbitmq']['default_user']).to eq('guest')
      expect(chef_run.node['rabbitmq']['default_pass']).to eq('rabbit-pass')
      expect(chef_run.node['rabbitmq']['use_distro_version']).to be_true
    end

    it 'overrides rabbit and openstack image attributes' do
      node.set['openstack']['mq']['bind_interface'] = 'eth0'
      node.set['openstack']['mq']['port'] = '4242'
      node.set['openstack']['mq']['user'] = 'foo'
      node.set['openstack']['mq']['vhost'] = '/bar'

      expect(chef_run.node['openstack']['mq']['listen']).to eq('33.44.55.66')
      expect(chef_run.node['openstack']['mq']['port']).to eq('4242')
      expect(chef_run.node['openstack']['mq']['user']).to eq('foo')
      expect(chef_run.node['openstack']['mq']['vhost']).to eq('/bar')
      expect(chef_run.node['openstack']['mq']['image']['rabbit']['port']).to eq('4242')
      expect(chef_run.node['openstack']['mq']['image']['rabbit']['userid']).to eq('foo')
      expect(chef_run.node['openstack']['mq']['image']['rabbit']['vhost']).to eq('/bar')
    end

    describe 'cluster' do
      before do
        node.set['openstack']['mq'] = {
          'cluster' => true
        }
      end

      it 'overrides cluster' do
        expect(chef_run.node['rabbitmq']['cluster']).to be_true
      end

      it 'overrides erlang_cookie' do
        expect(chef_run.node['rabbitmq']['erlang_cookie']).to eq(
          'erlang-cookie'
        )
      end

      it 'overrides and sorts cluster_disk_nodes' do
        expect(chef_run.node['rabbitmq']['cluster_disk_nodes']).to eq(
          ['guest@host1', 'guest@host2']
        )
      end
    end

    it 'includes rabbit recipes' do
      expect(chef_run).to include_recipe 'rabbitmq'
      expect(chef_run).to include_recipe 'rabbitmq::mgmt_console'
    end

    describe 'lwrps' do
      it 'does not delete the guest user' do
        expect(chef_run).not_to delete_rabbitmq_user('remove rabbit guest user')
      end

      it "deletes a user not called 'guest'" do
        node.node.set['openstack']['mq']['user'] = 'not-a-guest'
        expect(chef_run).to delete_rabbitmq_user('remove rabbit guest user')
      end

      it 'adds user' do
        resource = chef_run.find_resource(
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
        resource = chef_run.find_resource(
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
        resource = chef_run.find_resource(
          'rabbitmq_vhost',
          'add openstack rabbit vhost'
        ).to_hash

        expect(resource).to include(
          vhost: '/',
          action: [:add]
        )
      end

      it 'sets user permissions' do
        resource = chef_run.find_resource(
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
        resource = chef_run.find_resource(
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
