# encoding: UTF-8
# TODO(iartarisi) this should be submitted upstream and be a rabbitmq library
def delete_rabbitmq_user(name)
  ChefSpec::Matchers::ResourceMatcher.new(:rabbitmq_user, :delete, name)
end
