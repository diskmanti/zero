#!/bin/bash
# Ron Compos, 08-11-2017
# Randomly run cowsay or cowthink at login

motd=/etc/profile.d/motd.sh
if [ ! -f $motd ]; then
  echo 'if [ $RANDOM -lt 16383 ]; then /bin/fortune | /bin/cowsay; else /bin/fortune | /bin/cowthink; fi' > $motd
  #if [ $RANDOM -lt 16383 ]; then echo up; else echo down; fi
  #echo "File exists: $motd"
fi
