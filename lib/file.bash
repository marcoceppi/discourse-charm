#!/bin/bash

##
# Copyright 2013 Canonical, Ltd.
#
# This file is part of Charm Helpers.
#
# Charm Helpers is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Charm Helpers is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Charm Helpers.  If not, see <http://www.gnu.org/licenses/>.
##

##
# Parse a template file
# Replace variables in a template with Cheetah
#
# param perms - Octal permission of the new file
# param ownership - user:group ownership of the new file
# param template - Path to the template file
# param destination - Path for generated file
# param variables,, - Variables to include from environment
#
#
# Example:
# ch_template_file 755 me:nogroup environments.yaml $HOME/.juju/environments.yaml "HOME VAR1 VAR2"
# ch_template_file 0644 me:nogrop /var/lib/templates/f.tpl /tmp/ HOME VAR1 VAR2
##
ch_template_file() {
  local perms=$1
  local user_dot_group=$2
  local filename=$3
  local destination=$4
  shift 4 && local environment=$*
  for var in $environment; do
    export $var
  done
  if [ -d $destination ]; then
    destination="$destination/$(basename $filename)"
  fi
  cheetah fill --stdout --env $filename > $destination
  chmod $perms $destination
  chown -Rf $user_dot_group $destination
}

##
# Create tmpfs
# Create a temporary filesystem in RAM
#
# param size - Size of the new tmpfs
# param mount_point - Where to mount the new tmpfs
#
# Example:
# ch_create_tmpfs 120M /mnt/_tmp
##
ch_create_tmpfs() {
  local tmpfs_size=$1
  local mount_point=$2

  #TODO on precise use /etc/fstab.d/

  if [ ! -z "$tmpfs_size" ]; then
    grep -q $mount_point /etc/fstab || echo "tmpfs $mount_point tmpfs size=$tmpfs_size 0 0" >> /etc/fstab
    mount -at tmpfs
  fi
}
