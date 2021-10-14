#
# Cookbook:: openstack-ops-messaging
# Recipe:: rabbitmq-server
#
# Copyright:: 2013-2021, Chef Software, Inc.
# Copyright:: 2013-2021, AT&T Services, Inc.
# Copyright:: 2013-2021, Craig Tracey <craigtracey@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class ::Chef::Recipe
  include ::Openstack
end

user = node['openstack']['mq']['user']
pass = get_password 'user', user
vhost = node['openstack']['mq']['vhost']
bind_mq = node['openstack']['bind_service']['mq']
bind_mq = bind_mq
bind_mq_address = bind_address bind_mq

# Used by OpenStack#rabbit_servers/#rabbit_server
node.default['openstack']['mq']['listen'] = bind_mq_address
if node['openstack']['mq']['rabbitmq']['use_ssl']
  if node['rabbitmq']['ssl_port'] != bind_mq['port']
    node.default['rabbitmq']['ssl_port'] = bind_mq['port']
  else
    Chef::Log.error "Unable to listen on the port #{bind_mq['port']} for RabbitMQ TCP, which is listened on by SSL!"
  end
else
  node.default['rabbitmq']['port'] = bind_mq['port']
end
node.default['rabbitmq']['address'] = bind_mq_address
node.default['rabbitmq']['nodename'] = "#{user}@#{node['hostname']}"

# Clustering
if node['openstack']['mq']['cluster']
  node.default['rabbitmq']['clustering']['enable'] = node['openstack']['mq']['cluster']
  node.default['rabbitmq']['erlang_cookie'] = get_password 'service', 'rabbit_cookie'
  if node['openstack']['mq']['search_for_cluster_disk_nodes']
    qs = "recipes:openstack-ops-messaging\\:\\:rabbitmq-server AND chef_environment:#{node.chef_environment}"
    node.default['rabbitmq']['clustering']['use_auto_clustering'] = true
    node.default['rabbitmq']['clustering']['cluster_nodes'] =
      search(:node, qs).sort_by { |n| n['hostname'] }.map do |n|
        { name: "#{user}@#{n['hostname']}" }
      end
  end
end

include_recipe 'rabbitmq'
if node['openstack']['mq']['rabbitmq']['enable_mgmt_console']
  include_recipe 'rabbitmq::mgmt_console'
else
  rabbitmq_plugin 'rabbitmq_management' do
    action :disable
  end
end

rabbitmq_user 'add openstack rabbit user' do
  user user
  password pass
  sensitive true
end

rabbitmq_user 'change openstack rabbit user password' do
  user user
  password pass
  sensitive true
  action :change_password
end

rabbitmq_vhost 'add openstack rabbit vhost' do
  vhost vhost
  sensitive true
end

rabbitmq_user 'set openstack user permissions' do
  user user
  vhost vhost
  permissions '.* .* .*'
  sensitive true
  action :set_permissions
end

# Necessary for graphing.
rabbitmq_user 'set rabbit administrator tag' do
  user user
  tag 'administrator'
  sensitive true
  action :set_tags
end
