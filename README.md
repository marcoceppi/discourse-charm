# About

This charm installs the Discourse application, http://discourse.org

# Install

After you've successfully bootstrapped an environment, run the following:

    juju deploy discourse
    juju deploy postgresql

Then create relations

    juju add-relation discourse postgresql:db-admin

Discourse requires `db-admin` level access in order to enable the hstore
plugin. Finally, expose discourse:

    juju expose discourse

# Configure

There is currently only one configuration option for Discourse, this allows
you to set which user will be admin. To option takes a string of comma
separated usernames. You can find a username by visiting a user's profile
and copying the last part of the URL, in this case "marcoceppi": 
`http://meta.discourse.org/users/marcoceppi`. To set just one admin do the
following:

    juju set admins="marcoceppi"

Where "marcoceppi" is the username. For multiple admins use commas to
separate values:

    juju set admins="marcoceppi,codinghorror,sam,eviltrout"

In the event you wish to remove an admin, say `sam`, simply supply the
same list of users again only sans the user you wish to remove:

    juju set admins="marcoceppi,codinghorror,eviltrout"

If a user does not exist they will not be granted admin access and will
simply be skipped.

# Extras

These are additional things you can do to enhance your base install.

## Shared queuing server

If you have a need for a scaled out queuing server, or if you find yourself
with many discourse units, it will be beneficial to use a separate redis
server for queue management. To conserve resources all units, by default,
have their own `redis-server` installed. However, you can deploy and add
a relation to the [redis-master](jujucharms.com/charms/precise/redis-master)
charm in order to provide a central redis server.

    juju deploy redis-master redis
    juju add-relation discourse redis:db

In doing so the local `redis-server` installs will be removed and the site
re-configured to use the new redis service. For more information on scaling
out redis, refer to the [redis-slave](jujucharms.com/charms/precise/redis-slave)
charm.
