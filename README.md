# Description #

This cookbook provides shared messaging configuration for the OpenStack **Grizzly** reference deployment provided by Chef for OpenStack. The http://github.com/mattray/chef-openstack-repo contains documentation for using this cookbook in the context of a full OpenStack deployment. It currently supports RabbitMQ and may eventually support other messaging technologies such as ActiveMQ or ZeroMQ.

# Requirements #

Chef 11 with Ruby 1.9.x required.

# Platforms #

* Ubuntu-12.04

# Cookbooks #

The following cookbooks are dependencies:

* openssl
* rabbitmq

# Resources/Providers #

None

# Recipes #

## default ##

Selects the messaging service selected by the attribute `['openstack']['messaging']['service']`.

## rabbitmq ##

Currently the only supported messaging service. Defaults to using the latest release from RabbitMQ.org. Override any attributes from the [rabbitmq cookbook](https://github.com/opscode-cookbooks/rabbitmq) to change behavior.

# Attributes #

* `default['openstack']['role']['messaging']` - which role should other nodes search on to find the messaging service, defaults to 'os-ops-messaging'
* `default['openstack']['messaging']['service']` - which service to use, defaults to 'rabbitmq'
* `default['openstack']['messaging']['host']` - messaging host, default is '0.0.0.0'
* `default['openstack']['messaging']['port']` - messaging port, default is 5672
* `default['openstack']['messaging']['user']` - messaging user, default is 'rabbit'
* `default['openstack']['messaging']['password']` - messaging password, defaults to secure generated password
* `default['openstack']['messaging']['vhost']` - messaging vhost, defaults to '/nova'

# Templates #

None

License and Author
==================

|                      |                                                    |
|:---------------------|:---------------------------------------------------|
| **Author**           |  John Dewey (<john@dewey.ws>)                      |
| **Author**           |  Justin Shepherd (<justin.shepherd@rackspace.com>) |
| **Author**           |  Jason Cannavale (<jason.cannavale@rackspace.com>) |
| **Author**           |  Ron Pedde (<ron.pedde@rackspace.com>)             |
| **Author**           |  Joseph Breu (<joseph.breu@rackspace.com>)         |
| **Author**           |  William Kelly (<william.kelly@rackspace.com>)     |
| **Author**           |  Darren Birkett (<darren.birkett@rackspace.co.uk>) |
| **Author**           |  Evan Callicoat (<evan.callicoat@rackspace.com>)   |
| **Author**           |  Matt Ray (<matt@opscode.com>)                     |
|                      |                                                    |
| **Copyright**        |  Copyright 2012, John Dewey                        |
| **Copyright**        |  Copyright (c) 2012-2013, Rackspace US, Inc.       |
| **Copyright**        |  Copyright (c) 2012-2013, Opscode, Inc.            |

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
