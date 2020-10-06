require_relative 'spec_helper'

describe 'openstack-ops-messaging::rabbitmq-server' do
  describe 'ubuntu' do
    let(:runner) { ChefSpec::SoloRunner.new(UBUNTU_OPTS) }
    let(:node) { runner.node }
    cached(:chef_run) { runner.converge(described_recipe) }

    include_context 'ops_messaging_stubs'

    it 'overrides default rabbit attributes' do
      expect(chef_run.node['openstack']['endpoints']['mq']['port']).to eq('5672')
      expect(chef_run.node['openstack']['mq']['listen']).to eq('127.0.0.1')
      expect(chef_run.node['openstack']['mq']['rabbitmq']['use_ssl']).to be_falsey
      expect(chef_run.node['rabbitmq']['port']).to eq('5672')
      expect(chef_run.node['rabbitmq']['address']).to eq('127.0.0.1')
      expect(chef_run.node['rabbitmq']['use_distro_version']).to be_truthy
    end

    context 'override rabbit and openstack image attributes' do
      cached(:chef_run) do
        node.override['openstack']['bind_service']['mq']['interface'] = 'enp0s3'
        node.override['openstack']['bind_service']['mq']['port'] = '4242'
        node.override['openstack']['endpoints']['mq']['port'] = '4242'
        node.override['openstack']['mq']['user'] = 'foo'
        node.override['openstack']['mq']['vhost'] = '/bar'
        runner.converge(described_recipe)
      end
      it 'overrides rabbit and openstack image attributes' do
        expect(chef_run.node['openstack']['mq']['listen']).to eq('33.44.55.66')
        expect(chef_run.node['openstack']['mq']['image']['rabbit']['port']).to eq('4242')
        expect(chef_run.node['openstack']['mq']['image']['rabbit']['userid']).to eq('foo')
        expect(chef_run.node['openstack']['mq']['image']['rabbit']['vhost']).to eq('/bar')
      end
    end

    context 'rabbit ssl' do
      cached(:chef_run) do
        node.override['openstack']['mq']['rabbitmq']['use_ssl'] = true
        node.override['openstack']['bind_service']['mq']['port'] = '1234'
        runner.converge(described_recipe)
      end

      it 'overrides rabbit ssl attributes' do
        expect(chef_run.node['openstack']['mq']['rabbitmq']['use_ssl']).to be_truthy
      end
    end

    context 'cluster' do
      cached(:chef_run) do
        node.override['openstack']['mq'] = { 'cluster' => true }
        runner.converge(described_recipe)
      end

      it 'overrides cluster' do
        expect(chef_run.node['rabbitmq']['clustering']['enable']).to be_truthy
      end

      it 'overrides erlang_cookie' do
        expect(chef_run.node['rabbitmq']['erlang_cookie']).to eq(
          'erlang-cookie'
        )
      end

      it 'overrides and sorts cluster_disk_nodes' do
        expect(chef_run.node['rabbitmq']['clustering']['cluster_nodes']).to eq(
          [{ 'name' => 'openstack@host1' }, { 'name' => 'openstack@host2' }]
        )
      end

      context 'search_for_cluster_disk_nodes false' do
        cached(:chef_run) do
          node.override['openstack']['mq'] = { 'cluster' => true }
          node.override['openstack']['mq']['search_for_cluster_disk_nodes'] = false
          runner.converge(described_recipe)
        end
        it 'does not search for cluster_disk_nodes' do
          expect(chef_run.node['rabbitmq']['clustering']['cluster_nodes']).to eq([])
        end
      end
    end

    it 'includes rabbit recipes' do
      expect(chef_run).to include_recipe 'rabbitmq'
      expect(chef_run).to include_recipe 'rabbitmq::mgmt_console'
    end

    describe 'lwrps' do
      context 'custom mq attributes' do
        cached(:chef_run) do
          node.override['openstack']['mq']['user'] = 'not-a-guest'
          node.override['openstack']['mq']['vhost'] = '/foo'
          runner.converge(described_recipe)
        end

        it 'adds openstack rabbit user' do
          expect(chef_run).to add_rabbitmq_user(
            'add openstack rabbit user'
          ).with(user: 'not-a-guest', password: 'rabbit-pass')
        end

        it 'changes openstack rabbit user password' do
          expect(chef_run).to change_password_rabbitmq_user(
            'change openstack rabbit user password'
          ).with(user: 'not-a-guest', password: 'rabbit-pass')
        end

        it 'adds openstack rabbit vhost' do
          expect(chef_run).to add_rabbitmq_vhost(
            'add openstack rabbit vhost'
          ).with(vhost: '/foo')
        end

        it 'sets openstack user permissions' do
          expect(chef_run).to set_permissions_rabbitmq_user(
            'set openstack user permissions'
          ).with(user: 'not-a-guest', vhost: '/foo', permissions: '.* .* .*')
        end

        it 'sets administrator tag' do
          expect(chef_run).to set_tags_rabbitmq_user(
            'set rabbit administrator tag'
          ).with(user: 'not-a-guest', tag: 'administrator')
        end
      end
    end
  end
end
