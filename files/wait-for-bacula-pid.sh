#!/bin/bash

BACULATIMEOUT=60
BACULAPORT=9101
BACULARUN=/var/run/bacula

while getopts 't:p:' OPT; do
  case $OPT in
    t)  BACULATIMEOUT=$OPTARG;;
    p)  BACULAPORT=$OPTARG;;
    r)  BACULARUN=$OPTARG;;
    *)  JELP="yes";;
  esac
done

if [ "$JELP" = "yes" ];
then
  echo "unexpected options, aborting"
  exit 1
fi

for i in 1..${BACULATIMEOUT};
do
  if [ -f "${BACULARUN}/bacula-dir.${BACULAPORT}.pid" ];
  then
    echo "found ${BACULARUN}/bacula-dir.${BACULAPORT}.pid - iteration $i"
    exit 0
  fi
  sleep 1
done

exit 1
