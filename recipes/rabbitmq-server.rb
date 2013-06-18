#
# Cookbook Name:: openstack-ops-messaging
# Recipe:: rabbitmq-server
#
# Copyright 2012, John Dewey
# Copyright 2013, Opscode, Inc.
# Copyright 2013, Craig Tracey <craigtracey@gmail.com>
#
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class ::Chef::Recipe
  include ::Openstack
end

node.set["rabbitmq"]["port"] = node["openstack"]["messaging"]["rabbitmq_options"]["port"]
node.set["rabbitmq"]["address"] = node["openstack"]["messaging"]["rabbitmq_options"]["address"]
node.set["rabbitmq"]["use_distro_version"] = true

include_recipe "rabbitmq::default"
include_recipe "rabbitmq::mgmt_console"

rabbit_password = user_password "rabbit"
rabbit_user = node["openstack"]["messaging"]["rabbitmq_options"]["user"]
rabbit_vhost = node["openstack"]["messaging"]["rabbitmq_options"]["vhost"]

# remove the guest user if we dont need it
rabbitmq_user "remove rabbit guest user" do
  user 'guest'
  action :delete
  not_if { rabbit_user.eql?('guest') }
end

rabbitmq_user "add openstack rabbit user" do
  user rabbit_user
  password rabbit_password
  action :add
end

rabbitmq_vhost "add openstack rabbit vhost" do
  vhost rabbit_vhost
  action :add
end

rabbitmq_user "set openstack user permissions" do
  user rabbit_user
  vhost rabbit_vhost
  permissions '.* .* .*'
  action :set_permissions
end

# Necessary for graphing.
rabbitmq_user "set rabbit administrator tag" do
  user rabbit_user
  tag "administrator"
  action :set_tags
end
