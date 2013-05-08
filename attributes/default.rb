default['openstack']['role']['messaging'] = 'os-ops-messaging'

default['openstack']['messaging']['service'] = 'rabbitmq'

# default['rabbitmq']['port'] = 5672
# default['rabbitmq']['address'] = '0.0.0.0'

default['openstack']['messaging']['host'] = node['rabbitmq']['address']
default['openstack']['messaging']['port'] = node['rabbitmq']['port']
default['openstack']['messaging']['user'] = 'rabbit'
default['openstack']['messaging']['password'] = 'password'
default['openstack']['messaging']['vhost'] = '/nova'

