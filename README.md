# Description #

This cookbook provides shared message queue configuration for the OpenStack **Grizzly** reference deployment provided by Chef for OpenStack. The http://github.com/mattray/chef-openstack-repo contains documentation for using this cookbook in the context of a full OpenStack deployment. It currently supports RabbitMQ and will soon other queues.

# Requirements #

Chef 11 with Ruby 1.9.x required.

# Platforms #

* Ubuntu-12.04

# Cookbooks #

The following cookbooks are dependencies:

* rabbitmq
* openstack-common

# Resources/Providers #

None

# Templates #

None

# Recipes #

## server ##

- message queue server configuration, selected by attributes

## rabbitmq-server ##

- configures the RabbitMQ server for OpenStack

# Attributes #

* `openstack['messaging']['server_role']` - the role name to search for the messaging service
* `openstack['messaging']['service']` - the messaging service to use; currently supports RabbitMQ

* `openstack['messaging']['rabbitmq_options']['port']` - the port to use for RabbitMQ; default 5672
* `openstack['messaging']['rabbitmq_options']['address']` - the address for RabbitMQ to listen on; default 0.0.0.0
* `openstack['messaging']['rabbitmq_options']['user']` - the RabbitMQ user to use for OpenStack; default 'guest'
* `openstack['messaging']['rabbitmq_options']['vhost']` - the RabbitMQ vhost to use for OpenStack; default '/'

License and Author
==================

|                      |                                                    |
|:---------------------|:---------------------------------------------------|
| **Author**           |  John Dewey (<john@dewey.ws>)                      |
| **Author**           |  Matt Ray (<matt@opscode.com>)                     |
| **Author**           |  Craig Tracey (<craigtracey@gmail.com>)            |
|                      |                                                    |
| **Copyright**        |  Copyright (c) 2012, John Dewey                    |
| **Copyright**        |  Copyright (c) 2013, Opscode, Inc.                 |
| **Copyright**        |  Copyright (c) 2013, Craig Tracey                  |


Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
