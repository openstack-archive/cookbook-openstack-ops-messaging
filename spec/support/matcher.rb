# encoding: UTF-8

# TODO(iartarisi) this should be submitted upstream and be a rabbitmq library
def delete_rabbitmq_user(name)
  ChefSpec::Matchers::ResourceMatcher.new(:rabbitmq_user, :delete, name)
end

# TODO(galstrom21) this should be submitted upstream and be a rabbitmq library
def add_rabbitmq_user(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(:rabbitmq_user, :add, resource_name)
end

# TODO(galstrom21) this should be submitted upstream and be a rabbitmq library
def rabbitmq_user_change_password(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(:rabbitmq_user, :change_password, resource_name)
end

# TODO(galstrom21) this should be submitted upstream and be a rabbitmq library
def rabbitmq_user_set_permissions(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(:rabbitmq_user, :set_permissions, resource_name)
end

# TODO(galstrom21) this should be submitted upstream and be a rabbitmq library
def rabbitmq_user_set_tags(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(:rabbitmq_user, :set_tags, resource_name)
end

# TODO(galstrom21) this should be submitted upstream and be a rabbitmq library
def add_rabbitmq_vhost(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(:rabbitmq_vhost, :add, resource_name)
end
