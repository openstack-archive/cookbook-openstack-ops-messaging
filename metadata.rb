# encoding: UTF-8
name 'openstack-ops-messaging'
maintainer 'openstack-chef'
maintainer_email 'openstack-dev@lists.openstack.org'
license 'Apache 2.0'
description 'Provides the shared messaging configuration for Chef for OpenStack.'
version '13.0.0'

recipe 'server', 'Installs and configures server packages for messaging queue used by the deployment.'
recipe 'rabbitmq-server', 'Installs and configures RabbitMQ and is called via the server recipe'

%w(ubuntu redhat centos).each do |os|
  supports os
end

depends 'openstack-common', '>= 13.0.0'
depends 'rabbitmq', '~> 4.1'
