require "chefspec"

::LOG_LEVEL = :fatal
::UBUNTU_OPTS = {
  :platform  => "ubuntu",
  :version   => "12.04",
  :log_level => ::LOG_LEVEL
}

def messaging_stubs
  ::Chef::Recipe.any_instance.stub(:user_password).and_return("rabbitpassword")
end
