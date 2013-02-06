# About

This charm installs the Discourse application, http://discourse.com

# Install

After you've successfully bootstrapped an environment, run the following:

    juju deploy discourse
    juju deploy postgresql
    juju deploy redis-master redis

Then create relations

    juju add-relation discourse redis:db
    juju add-relation discourse postgresql:db-admin

Discourse requires `db-admin` level access in order to enable the hstore plugin. Finally, expose discourse

    juju expose discourse

