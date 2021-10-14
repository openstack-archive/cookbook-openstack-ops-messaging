#
# Cookbook:: openstack-ops-messaging
# Recipe:: default
#
# Copyright:: 2013-2021, AT&T Services, Inc.
# Copyright:: 2013-2021, Chef Software, Inc.
# Copyright:: 2019-2021, Oregon State University
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

default['openstack']['mq']['cluster'] = false

# Allow cluster_disk_nodes to be optionally set based upon a node role search.
# If set to false, mq cluster nodes can be added on-the-fly using the cluster command.
# see https://www.rabbitmq.com/clustering.html
default['openstack']['mq']['search_for_cluster_disk_nodes'] = true

normal['rabbitmq']['use_distro_version'] = true

if platform_family?('debian', 'suse')
  normal['rabbitmq']['config'] = '/etc/rabbitmq/rabbitmq.config'
end

# Enable the rabbitmq management plugin by default
default['openstack']['mq']['rabbitmq']['enable_mgmt_console'] = true
