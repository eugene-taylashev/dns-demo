#!/bin/sh

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

#-- out some internal params
ip addr show
dlog "ID:" 
id named

#-- adjust permission 
chown -R named:named /var/named

#-- check params
FCFG=/var/named/named.conf
dlog "Checking config $FCFG"
named-checkconf $FCFG

dlog "Running Bind9"
#-- start named with given config
/usr/sbin/named -g -u named -c $FCFG

dlog "We done"
