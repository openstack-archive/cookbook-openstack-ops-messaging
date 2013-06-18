default['openstack']['messaging']['server_role'] = 'os-ops-messaging'
default['openstack']['messaging']['service'] = 'rabbitmq'

case default['openstack']['messaging']['service']
when "rabbitmq"
  default['openstack']['messaging']['rabbitmq_options'] = {}
  default['openstack']['messaging']['rabbitmq_options']['port'] = 5672
  default['openstack']['messaging']['rabbitmq_options']['address'] = "0.0.0.0"
  default['openstack']['messaging']['rabbitmq_options']['user'] = "guest"
  default['openstack']['messaging']['rabbitmq_options']['vhost'] = "/"
end
