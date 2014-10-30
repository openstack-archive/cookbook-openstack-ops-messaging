# CHANGELOG for cookbook-openstack-ops-messaging

This file is used to list changes made in each version of cookbook-openstack-ops-messaging.

## 10.0.1
* Configure rabbitmq port for both ssl and non-ssl cases
* Fix metadata version constraint for common
* Bump Chef gem to 11.16
* No need to push our rabbit user/password to rabbit cookbook
* Add a temp workaround for an issue #153 in rabbit cookbook to notify
  rabbitmq-server to restart immediately.
* Add another workaround for the issue #153 in rabbit cookbook.

## 10.0.0
* Upgrading to Juno
* Upgrading berkshelf from 2.0.18 to 3.1.5

## 9.0.1
### Bug
* Fix the depends cookbook version issue in metadata.rb
* bump berkshelf to 2.0.18 to allow Supermarket support
* fix fauxhai version for suse

## 9.0.0
* Upgrade to Icehouse

## 8.0.1:
* Add change_password to make rabbitmq work when develop_mode=false

## 8.0.0
* upgrade to Havana

## 7.0.1:

* default the node['openstack'][*]['rabbit'] attributes for all the services
  using rabbitmq (block-storage, compute, image, metering, network) to whatever
  node['openstack']['mq'] attributes are set.

## 7.0.0

* Initial release intended for Grizzly-based OpenStack releases,
  for use with Stackforge upstream repositories.

- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
