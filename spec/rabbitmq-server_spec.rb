require_relative 'spec_helper'

describe 'openstack-ops-messaging::rabbitmq-server' do
  describe 'ubuntu' do
    before do
      messaging_stubs
      @chef_run = ::ChefSpec::ChefRunner.new(::UBUNTU_OPTS) do |node|
        node.set['lsb'] = {'codename' => 'precise'}
        node.set['openstack']= {'messaging' => {
            'service' => 'rabbitmq',
            'rabbitmq_options' => {
              'user' => 'openstack_rabbit_user',
              'vhost' => '/openstack_rabbit_vhost'
            }
          }
        }
        node.set['rabbitmq'] = {
          'erlang_cookie_path' => '/path/to/nowhere'
        }
      end

      @rabbitmq_user_mock = double "rabbitmq_user"
      @rabbitmq_vhost_mock = double "rabbitmq_vhost"
    end

    it "rabbitmq-server basic test" do
      @chef_run.converge "openstack-ops-messaging::rabbitmq-server"

      expect(@chef_run).to include_recipe "openstack-ops-messaging::rabbitmq-server"
      expect(@chef_run).to include_recipe "rabbitmq::default"
      expect(@chef_run).to include_recipe "rabbitmq::mgmt_console"
    end

    it "removes the rabbit guest user" do
      ::Chef::Recipe.any_instance.stub(:rabbitmq_user)
      ::Chef::Recipe.any_instance.should_receive(:rabbitmq_user).
        with("remove rabbit guest user") do |&arg|
          @rabbitmq_user_mock.should_receive(:user).
            with "guest"
          @rabbitmq_user_mock.should_receive(:action).
            with :delete
          @rabbitmq_user_mock.should_receive(:not_if)

          @rabbitmq_user_mock.instance_eval &arg
        end

      @chef_run.converge "openstack-ops-messaging::rabbitmq-server"
    end

    it "adds the openstack rabbit user" do
      ::Chef::Recipe.any_instance.stub(:rabbitmq_user)
      ::Chef::Recipe.any_instance.should_receive(:rabbitmq_user).
        with("add openstack rabbit user") do |&arg|
          @rabbitmq_user_mock.should_receive(:user).
            with "openstack_rabbit_user"
          @rabbitmq_user_mock.should_receive(:password).
            with "rabbitpassword"
          @rabbitmq_user_mock.should_receive(:action).
            with :add

          @rabbitmq_user_mock.instance_eval &arg
        end

      @chef_run.converge "openstack-ops-messaging::rabbitmq-server"
    end

    it "adds the openstack rabbit vhost" do
      ::Chef::Recipe.any_instance.stub(:rabbitmq_vhost)
      ::Chef::Recipe.any_instance.should_receive(:rabbitmq_vhost).
        with("add openstack rabbit vhost") do |&arg|
          @rabbitmq_vhost_mock.should_receive(:vhost).
            with "/openstack_rabbit_vhost"
          @rabbitmq_vhost_mock.should_receive(:action).
            with :add

          @rabbitmq_vhost_mock.instance_eval &arg
        end

      @chef_run.converge "openstack-ops-messaging::rabbitmq-server"
    end

    it "set openstack user permissions" do
      ::Chef::Recipe.any_instance.stub(:rabbitmq_user)
      ::Chef::Recipe.any_instance.should_receive(:rabbitmq_user).
        with("set openstack user permissions") do |&arg|
          @rabbitmq_user_mock.should_receive(:user).
            with "openstack_rabbit_user"
          @rabbitmq_user_mock.should_receive(:vhost).
            with "/openstack_rabbit_vhost"
          @rabbitmq_user_mock.should_receive(:permissions).
            with ".* .* .*"
          @rabbitmq_user_mock.should_receive(:action).
            with :set_permissions

          @rabbitmq_user_mock.instance_eval &arg
        end

      @chef_run.converge "openstack-ops-messaging::rabbitmq-server"
    end

    it "set rabbit administrator tag" do
      ::Chef::Recipe.any_instance.stub(:rabbitmq_user)
      ::Chef::Recipe.any_instance.should_receive(:rabbitmq_user).
        with("set rabbit administrator tag") do |&arg|
          @rabbitmq_user_mock.should_receive(:user).
            with "openstack_rabbit_user"
          @rabbitmq_user_mock.should_receive(:tag).
            with "administrator"
          @rabbitmq_user_mock.should_receive(:action).
            with :set_tags

          @rabbitmq_user_mock.instance_eval &arg
        end

      @chef_run.converge "openstack-ops-messaging::rabbitmq-server"
    end

  end
end
