require_relative "spec_helper"

describe "openstack-ops-messaging::rabbitmq-server" do
  before { ops_messaging_stubs }
  describe "ubuntu" do
    before do
      @chef_run = ::ChefSpec::ChefRunner.new(::UBUNTU_OPTS) do |n|
        n.set["openstack"]["mq"] = {
          "user" => "rabbit-user",
          "vhost" => "/test-vhost"
        }
      end
      @chef_run.converge "openstack-ops-messaging::rabbitmq-server"
    end

    it "overrides default rabbit attributes" do
      expect(@chef_run.node["openstack"]["mq"]["port"]).to eql "5672"
      expect(@chef_run.node["openstack"]["mq"]["listen"]).to eql "127.0.0.1"
      expect(@chef_run.node["rabbitmq"]["address"]).to eql "127.0.0.1"
      expect(@chef_run.node["rabbitmq"]["default_user"]).to eql "rabbit-user"
      expect(@chef_run.node['rabbitmq']['default_pass']).to eql "rabbit-pass"
      expect(@chef_run.node['rabbitmq']['erlang_cookie']).to eql(
        "erlang-cookie"
      )
      expect(@chef_run.node['rabbitmq']['cluster']).to be_true
      expect(@chef_run.node['rabbitmq']['cluster_disk_nodes']).to eql(
        ["rabbit-user@host1", "rabbit-user@host2"]
      )
    end

    it "includes rabbit recipes" do
      expect(@chef_run).to include_recipe "rabbitmq"
      expect(@chef_run).to include_recipe "rabbitmq::mgmt_console"
    end

    describe "lwrps" do
      it "deletes guest user" do
        resource = @chef_run.find_resource(
          "rabbitmq_user",
          "remove rabbit guest user"
        ).to_hash

        expect(resource).to include(
          :user => "guest",
          :action => [:delete]
        )
      end

      it "doesn't delete guest user" do
        opts = ::UBUNTU_OPTS.merge(:evaluate_guards => true)
        chef_run = ::ChefSpec::ChefRunner.new(opts) do |n|
          n.set["openstack"]["mq"] = {
            "user" => "guest",
            "vhost" => "/test-vhost"
          }
        end
        chef_run.converge "openstack-ops-messaging::rabbitmq-server"

        resource = chef_run.find_resource(
          "rabbitmq_user",
          "remove rabbit guest user"
        )

        expect(resource).to be_nil
      end

      it "adds user" do
        resource = @chef_run.find_resource(
          "rabbitmq_user",
          "add openstack rabbit user"
        ).to_hash

        expect(resource).to include(
          :user => "rabbit-user",
          :password => "rabbit-pass",
          :action => [:add]
        )
      end

      it "adds vhost" do
        resource = @chef_run.find_resource(
          "rabbitmq_vhost",
          "add openstack rabbit vhost"
        ).to_hash

        expect(resource).to include(
          :vhost => "/test-vhost",
          :action => [:add]
        )
      end

      it "sets user permissions" do
        resource = @chef_run.find_resource(
          "rabbitmq_user",
          "set openstack user permissions"
        ).to_hash

        expect(resource).to include(
          :user => "rabbit-user",
          :vhost => "/test-vhost",
          :permissions => '.* .* .*',
          :action => [:set_permissions]
        )
      end

      it "sets administrator tag" do
        resource = @chef_run.find_resource(
          "rabbitmq_user",
          "set rabbit administrator tag"
        ).to_hash

        expect(resource).to include(
          :user => "rabbit-user",
          :tag => "administrator",
          :action => [:set_tags]
        )
      end
    end

    describe "mnesia" do
      before do
        ::File.stub(:exists?).and_call_original
        opts = ::UBUNTU_OPTS.merge(:evaluate_guards => true)
        @chef_run = ::ChefSpec::ChefRunner.new opts do |n|
          n.set["openstack"]["mq"] = {
            "user" => "rabbit-user",
            "vhost" => "/test-vhost"
          }
        end
        @cmd = <<-EOH.gsub(/^\s+/, "")
          service rabbitmq-server stop;
          rm -rf mnesia/;
          touch .reset_mnesia_database;
          service rabbitmq-server start
        EOH
        @file = "/var/lib/rabbitmq/.reset_mnesia_database"
      end

      it "resets database" do
        ::File.should_receive(:exists?).
          with(@file).
          and_return(false)
        @chef_run.converge "openstack-ops-messaging::rabbitmq-server"

        expect(@chef_run).to execute_command(@cmd).with(
          :cwd => "/var/lib/rabbitmq"
        )
      end

      it "doesn't reset database when already did" do
        ::File.should_receive(:exists?).
          with(@file).
          and_return(true)
        @chef_run.converge "openstack-ops-messaging::rabbitmq-server"

        expect(@chef_run).not_to execute_command(@cmd)
      end
    end
  end
end
