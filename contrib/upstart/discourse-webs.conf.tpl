description "Discourse Webs"
author "Marco Ceppi <marco@ceppi.net>"

start on starting discourse
stop on stopping discourse

script
  . /etc/default/discourse
  for i in `seq 0 $(expr $THINS - 1)`
  do
    start discourse-web PORT=$(expr $START_PORT + $i)
  done
end script
