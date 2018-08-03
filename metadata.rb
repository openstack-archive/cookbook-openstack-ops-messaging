name             'openstack-ops-messaging'
maintainer       'openstack-chef'
maintainer_email 'openstack-dev@lists.openstack.org'
license          'Apache-2.0'
description      'Provides the shared messaging configuration for Chef for OpenStack.'
version          '18.0.0'

recipe 'server', 'Installs and configures server packages for messaging queue used by the deployment.'
recipe 'rabbitmq-server', 'Installs and configures RabbitMQ and is called via the server recipe'

%w(ubuntu redhat centos).each do |os|
  supports os
end

depends 'openstack-common', '>= 18.0.0'
depends 'rabbitmq'

issues_url 'https://launchpad.net/openstack-chef' if respond_to?(:issues_url)
source_url 'https://github.com/openstack/cookbook-openstack-ops-messaging' if respond_to?(:source_url)
chef_version '>= 12.5' if respond_to?(:chef_version)
