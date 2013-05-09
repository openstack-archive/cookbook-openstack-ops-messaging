default['openstack']['role']['messaging'] = 'os-ops-messaging'

default['openstack']['messaging']['service'] = 'rabbitmq'

default['openstack']['messaging']['host'] = node['rabbitmq']['address']
default['openstack']['messaging']['port'] = node['rabbitmq']['port']
default['openstack']['messaging']['user'] = 'rabbit'
default['openstack']['messaging']['password'] = nil
default['openstack']['messaging']['vhost'] = '/nova'

