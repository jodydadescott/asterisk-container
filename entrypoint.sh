#!/bin/bash

function main() {
  cd /root
  [ -n "$(ls -A /etc/asterisk 2>/dev/null)" ] && {
    err "Directory /etc/asterisk has files; doing nothing"
  } || {
    err "Directory /etc/asterisk is empty; creating files"
    cp -r /usr/share/asterisk/* /etc/asterisk
  }
  exec /usr/sbin/asterisk -fvvv
}

function err() { echo "$@" 1>&2; }

main "$@"
