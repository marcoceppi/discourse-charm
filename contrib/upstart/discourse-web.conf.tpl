description "Discourse Web Unit"
author "Marco Ceppi <marco@ceppi.net>"

stop on stopping discourse

respawn
respawn limit 3 30

instance \$PORT

chdir /home/discourse/discourse

setuid discourse
setgid discourse

$rails_env
env RAILS_ENV=production
env SECRET_TOKEN=$token

exec bundle exec rails server -p \$PORT
