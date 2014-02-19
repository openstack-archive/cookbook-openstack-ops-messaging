# encoding: UTF-8
require_relative 'spec_helper'

describe 'openstack-ops-messaging::rabbitmq-server' do
  describe 'redhat' do
    before { ops_messaging_stubs }

    let(:runner) { ChefSpec::Runner.new(REDHAT_OPTS) }
    let(:node)  { runner.node }
    let(:chef_run) do
      runner.converge(described_recipe)
    end

    it 'does not set use_distro_version to true' do
      expect(chef_run.node['rabbitmq']['use_distro_version']).to eql false
    end

  end
end
