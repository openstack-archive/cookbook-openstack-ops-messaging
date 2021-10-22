require_relative 'spec_helper'

describe 'openstack-ops-messaging::rabbitmq-server' do
  ALL_RHEL.each do |p|
    context "redhat #{p[:version]}" do
      let(:runner) { ChefSpec::SoloRunner.new(p) }
      let(:node) { runner.node }
      cached(:chef_run) { runner.converge(described_recipe) }

      include_context 'ops_messaging_stubs'

      it 'does not set use_distro_version to true' do
        expect(chef_run.node['rabbitmq']['use_distro_version']).to be_truthy
      end
    end
  end
end
