description "Discourse Application Stack"
author "Marco Ceppi <marco@ceppi.net>"

start on (local-filesystems and net-device-up IFACE!=lo)
stop on runlevel [06]
