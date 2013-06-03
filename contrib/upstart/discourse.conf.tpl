description "Discourse Application"
author "Marco Ceppi <marco@ceppi.net>"

start on (local-filesystems and net-device-up IFACE!=lo)

chdir /home/discourse/discourse

setuid discourse
setgid discourse

$rails_env
env RAILS_ENV=production
env SECRET_TOKEN=$token

exec foreman start

respawn
