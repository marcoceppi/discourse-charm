description "Discourse Sidekiq"
author "Marco Ceppi <marco@ceppi.net>"

start on starting discourse
stop on stopping discourse

respawn
respawn limit 3 30

chdir /home/discourse/discourse

setuid discourse
setgid discourse

$rails_env
env RAILS_ENV=production
env SECRET_TOKEN=$token

exec bundle exec sidekiq -e \$RAILS_ENV
