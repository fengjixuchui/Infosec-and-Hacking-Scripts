#!/bin/bash

#    This file is part of PenTestKit
#    Copyright (C) 2017-2021 @maldevel
#    https://github.com/maldevel/PenTestKit
#
#    PenTestKit - Useful tools for Penetration Testing.
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#    For more see the file 'LICENSE' for copying permission.


if [ $# -eq 1 ]; then
  echo "## Services"
  echo

  cat $1/*.gnmap|grep "Ports:"| while read -r line ; do
    os=`echo "$line"|cut -d$'\t' -f3|grep 'OS:'|sed 's/OS: //'`
    host=`echo "$line"|cut -d$'\t' -f1|cut -d' ' -f2`
    ports=`echo "$line"|cut -d$'\t' -f2|sed 's/Ports: //'`

  IFS=","
  space="\n"
  hostports=""

  for port in $ports; do
    openport=$(expr match "$port" '\(.*\(open\|open|filtered\)/\(tcp\|udp\).*\)')
    if [ -n "$openport" ]; then
      hostports=$hostports"* "$(echo $openport|sed 's|/| |g'|sed 's/open//'|sed 's/|filtered//'|sed -r 's/(tcp|udp)//'|sed 's/  */ /g'|sed 's/^ //')$space
    fi
  done

    if [ -n "$hostports" ]; then
      echo "### $host"
      echo
      if [ -n "$os" ]; then
        echo "* $os"
        echo
      fi
      printf "$hostports"
      echo
    fi
  done

else
  echo "Please provide a directory path."
fi
