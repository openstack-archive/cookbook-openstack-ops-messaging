name             'openstack-ops-messaging'
maintainer       'openstack-chef'
maintainer_email 'openstack-discuss@lists.openstack.org'
license          'Apache-2.0'
description      'Provides the shared messaging configuration for Chef for OpenStack.'
version          '20.0.0'

%w(ubuntu redhat centos).each do |os|
  supports os
end

depends 'openstack-common', '>= 20.0.0'
depends 'rabbitmq', '>= 5.8.5'

issues_url 'https://launchpad.net/openstack-chef'
source_url 'https://opendev.org/openstack/cookbook-openstack-ops-messaging'
chef_version '>= 16.0'
