#!/bin/bash

BACULATIMEOUT=60
BACULAPORT=9101
BACULARUN=/var/run/bacula
BACULADAEMON=dir

while getopts 't:p:r:d:' OPT; do
  case $OPT in
    t)  BACULATIMEOUT=$OPTARG;;
    p)  BACULAPORT=$OPTARG;;
    r)  BACULARUN=$OPTARG;;
    d)  BACULADAEMON=$OPTARG;;
    *)  JELP="yes";;
  esac
done

if [ "$JELP" = "yes" ];
then
  echo "unexpected options, aborting"
  exit 1
fi

for i in $(seq 1 ${BACULATIMEOUT});
do
  if [ -f "${BACULARUN}/bacula-${BACULADAEMON}.${BACULAPORT}.pid" ];
  then
    echo "found ${BACULARUN}/bacula-${BACULADAEMON}.${BACULAPORT}.pid - iteration $i"
    exit 0
  fi
  sleep 1
done

exit 1
