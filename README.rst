OpenStack Chef Cookbook - ops-messaging
=======================================

.. image:: https://governance.openstack.org/badges/cookbook-openstack-ops-messaging.svg
    :target: https://governance.openstack.org/reference/tags/index.html

Description
===========

This cookbook provides shared message queue configuration for the
OpenStack deployment provided by Chef for OpenStack. The `OpenStack
chef-repo`_ contains documentation for using this cookbook in the
context of a full OpenStack deployment. It currently supports RabbitMQ
and will soon other queues.

.. _OpenStack chef-repo: https://opendev.org/openstack/openstack-chef

Requirements
============

- Chef 16 or higher
- Chef Workstation 21.10.640 for testing (also includes berkshelf for
  cookbook dependency resolution)

Platforms
=========

- ubuntu
- redhat
- centos

Cookbooks
=========

The following cookbooks are dependencies:

- 'openstack-common', '>= 20.0.0'
- 'rabbitmq', '=> 5.8.5'

Usage
=====

The usage of this cookbook is optional, you may choose to set up your
own messaging service without using this cookbook. If you choose to do
so, you will need to provide all of the attributes listed under the
`Attributes <#attributes>`__.

Resources/Providers
===================

None

Templates
=========

None

Recipes
=======

rabbitmq-server
---------------

- Installs and configures RabbitMQ and is called via the server recipe

Attributes
==========

-  ``openstack["mq"]["cluster"]`` - whether or not to cluster rabbit,
   defaults to ``false``

The following attributes are defined in ``attributes/messaging.rb`` of
the common cookbook, but are documented here due to their relevance:

-  ``openstack["endpoints"]["mq"]["host"]`` - The IP address to bind the
   rabbit service to
-  ``openstack["endpoints"]["mq"]["port"]`` - The port to bind the
   rabbit service to
-  ``openstack["endpoints"]["mq"]["bind_interface"]`` - The interface
   name to bind the rabbit service to
-  ``openstack["mq"]["rabbitmq"]["use_ssl"]`` - Enables/disables SSL for
   RabbitMQ, the default is false.

If the value of the ``bind_interface`` attribute is non-nil, then the
rabbit service will be bound to the first IP address on that interface.
If the value of the ``bind_interface`` attribute is nil, then the rabbit
service will be bound to the IP address specified in the host attribute.

Testing
=======

Please refer to the `TESTING.md`_ for instructions for testing the
cookbook.

.. _TESTING.md: cookbook-openstack-ops-messaging/src/branch/master/TESTING.md

Berkshelf
=========

Berks will resolve version requirements and dependencies on first run
and store these in ``Berksfile.lock``. If new cookbooks become available
you can run ``berks update`` to update the references in
``Berksfile.lock``.  ``Berksfile.lock`` will be included in stable
branches to provide a known good set of dependencies. ``Berksfile.lock``
will not be included in development branches to encourage development
against the latest cookbooks.

License and Author
==================

+-----------------+-------------------------------------------+
| **Author**      | John Dewey (john@dewey.ws)                |
+-----------------+-------------------------------------------+
| **Author**      | Matt Ray (matt@opscode.com)               |
+-----------------+-------------------------------------------+
| **Author**      | Craig Tracey (craigtracey@gmail.com)      |
+-----------------+-------------------------------------------+
| **Author**      | Ionut Artarisi (iartarisi@suse.cz)        |
+-----------------+-------------------------------------------+
| **Author**      | JieHua Jin (jinjhua@cn.ibm.com)           |
+-----------------+-------------------------------------------+
| **Author**      | Mark Vanderwiel (vanderwl@us.ibm.com)     |
+-----------------+-------------------------------------------+
| **Author**      | Jan Klare (j.klare@x-ion.de)              |
+-----------------+-------------------------------------------+
| **Author**      | Lance Albertson (lance@osuosl.org)        |
+-----------------+-------------------------------------------+

+-----------------+--------------------------------------------------+
| **Copyright**   | Copyright (c) 2013, Opscode, Inc.                |
+-----------------+--------------------------------------------------+
| **Copyright**   | Copyright (c) 2013, Craig Tracey                 |
+-----------------+--------------------------------------------------+
| **Copyright**   | Copyright (c) 2013, AT&T Services, Inc.          |
+-----------------+--------------------------------------------------+
| **Copyright**   | Copyright (c) 2013, SUSE Linux GmbH.             |
+-----------------+--------------------------------------------------+
| **Copyright**   | Copyright (c) 2013-2014, IBM Corp.               |
+-----------------+--------------------------------------------------+
| **Copyright**   | Copyright (c) 2019-2021, Oregon State University |
+-----------------+--------------------------------------------------+

Licensed under the Apache License, Version 2.0 (the "License"); you may
not use this file except in compliance with the License. You may obtain
a copy of the License at

::

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
