name              "openstack-ops-messaging"
maintainer        "Opscode, Inc."
maintainer_email  "matt@opscode.com"
license           "Apache 2.0"
description       "Provides the shared messaging configuration for Chef for OpenStack."
version           "0.1.0"

recipe "default", "Selects messaging service."
recipe "rabbitmq", "Configures RabbitMQ."

%w{ ubuntu }.each do |os|
  supports os
end

depends "openssl", ">= 1.0.2"
depends "rabbitmq", ">= 2.0.0"
