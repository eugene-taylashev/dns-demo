#!/bin/bash

#-----------------------------------------------------------------------------
#  Output debugging/logging message
#------------------------------------------------------------------------------
dlog(){
  MSG="$1"
#  echo "$MSG" >>$FLOG
  [ $VERBOSE -eq 1 ] && echo "$MSG"
}
# function dlog

#------------------------------------------------------------------------------
# MAIN
#------------------------------------------------------------------------------

dlog "Ready to start"

ip addr show

#-- check params
FCFG=/var/named/named.conf
dlog "Checking config $FCFG"
named-checkconf $FCFG

dlog "Running Bind9"
#-- start named with given config
/usr/sbin/named -g -u named -c $FCFG

dlog "We done"
