# About

This charm installs the Discourse application, http://discourse.org

# Install

After you've successfully bootstrapped an environment, run the following:

    juju deploy cs:~marcoceppi/discourse
    juju deploy postgresql

Then create relations

    juju add-relation discourse postgresql:db-admin

Discourse requires `db-admin` level access in order to enable the hstore
plugin. Finally, expose discourse:

    juju expose discourse

# Configure

There are several configuration options you can use to manage your Discourse
deployment. With the exception of admins, all defaults should suffice for most
deployments. Take care when adjusting other options as they may produce an
unstable deployment if unexpected values are used.

## admins

In order to access the Discourse Admin tools you must specify which users
should be admins. After creating your account in Discourse, add your name and
the name of others who should be admin using this configuration option. The
option takes a string of comma separated usernames. You can find a username by
visiting a user's profile and copying the last part of the URL, in this case
"marcoceppi": `http://meta.discourse.org/users/marcoceppi`. To set just one
admin do the following:

    juju set discourse admins="marcoceppi"

Where "marcoceppi" is the username. For multiple admins use commas to
separate values:

    juju set discourse admins="marcoceppi,codinghorror,sam,eviltrout"

If a user does not exist they will not be granted admin access and will
simply be skipped.

This will not be updated when a user is granted access via the admin panel. Also,
in the event you need to remove an admin you'll not only have to update this
configuration option but you'll also need to Revoke admin in the admin panel.
This option is designed to set up "god" users, to recover a board if
administrative access is lost, and during initial setup to define who gets
access to the site after installation. Further moderator and admin assignments
should happen in the admin panel.

## repository

If you maintain a forked version of the Discourse repository, you can deploy or
swap to that modified repository at any time. It's recommended you use upstreams
git repo at `https://github.com/discourse/discourse.git` or at least monitor it
for security and feature updates.

    juju set discourse repository="https://code.example.tld/repo/discourse.git"

In order to make use of the `version` option, you will need to push to your
Discourse repo with the `--tags` option. Otherwise git tags will not be moved
over which the `version` option relies on.

## release

Release is an easy way to "pin" your install at a known and familiar version of
Discourse, allowing you to "upgrade" to another version when you're ready. By
default this Discourse charm deploys against the "latest-release" Git tag which
is pointed at the latest version of Discourse.

For production deployments of Discourse it's recommended you change this version
either during deployment or shortly after to the corrosponding [release](https://github.com/discourse/discourse/tags)
of Discourse you deployed. Doing so will ensure that during scale-out you'll
maintain the same version of Discourse between units. Failure to do so may
result in broken behavior due to version inconsistency between units.

    juju set discourse release="v0.9.1"

Release can be any valid git ref (`git tag`, `git branch`) in the given `repository`

## thins

This option allows you to control how many instances of thin you wish to run on
one unit. By default (auto) will select a number of 2 or greater depending on
machine resources (CPU and RAM) available. If you wish to override this behavior
you can manipulate this option as long as it's a positive integer. All other values
will result in "auto" being used.

    juju set discourse thins=2

Upstream recommends at least 2 instances of thin running in order to properly
handle requests to the application.

## env

If you wish to modify the environment variables sent to the Application you can
override them here. This option is designed to allow [performance tweaking](http://meta.discourse.org/t/tuning-ruby-and-rails-for-discourse/4126?u=marcoceppi)
to be done against a Discourse install. By default this charm will apply the
recommended performance tuning for the verion of Ruby installed. To remove these
simply set this configuration option to a blank string (`""`)

    juju set discourse env="RUBY_GC_MALLOC_LIMIT=90000000"

You can specify multiple variables using a space between `KEY=VAL` pairings

# Extras

These are additional things you can do to enhance your base install.

## Shared queuing server

If you have a need for a scaled out queuing server, or if you find yourself
with many discourse units, it will be beneficial to use a separate redis
server for queue management. To conserve resources all units, by default,
have their own `redis-server` installed. However, you can deploy and add
a relation to the [redis-master](http://jujucharms.com/charms/precise/redis-master)
charm in order to provide a central redis server.

    juju deploy redis-master redis
    juju add-relation discourse redis:db

In doing so the local `redis-server` installs will be removed and the site
re-configured to use the new redis service. For more information on scaling
out redis, refer to the [redis-slave](http://jujucharms.com/charms/precise/redis-slave)
charm.

# Additional Help

Nothing yet?
