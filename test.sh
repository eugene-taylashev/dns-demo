#!/bin/bash
#--------------------------------------------------------------------------------------
# Perform functionality tests for a dnsserver container
#--------------------------------------------------------------------------------------

n=0  #-- count number of tests
g=0  #-- count success
b=0  #-- count failure

#== Test 1: container is running
n=$((n+1))
RES_ALL=$(docker ps)
RES_DOC='dnsmaster'
#echo $RES_ALL

if [[ "$RES_ALL" =~ .*"$RES_DOC".* ]] ; then
    echo "[ok] - ($n) Container $RES_DOC is running"
    g=$((g+1))
else
    echo "[not ok] - ($n) Container $RES_DOC is NOT running"
    b=$((b+1))
    echo 'Aborting testing...'
    exit 13
fi


#== Test: DNS resolves A record
n=$((n+1))
RES_ALL=$(dig -4 -p 5353 @localhost baron.lbsec.com)
RES_DNS='10.10.1.2'
#baron.lbsec.com.        86400   IN      A       10.10.1.2
#echo $RES_ALL

if grep -q "$RES_ALL" <<< $RES_DNS ; then
    echo "[ok] - ($n) DNS is resolving an A record"
    g=$((g+1))
else
    echo "[not ok] - ($n) DNS is NOT resolving an A record"
    b=$((b+1))
fi


#== Test: DNSSEC
n=$((n+1))
RES_ALL=$(dig -4 -p 5353 @localhost +dnssec +multiline baron.lbsec.com)
RES_DNS='RRSIG'
#baron.lbsec.com.        86400 IN RRSIG A 13 3 86400 (
#                                20201022134646 20201006010737 59150 lbsec.com.
#                                EH68Q8b3xqav/50AokFc0xRY+t4w734CJehTbjk4oA9n
#                                rUpPfnmX/IEO0s6IaTk2K4xC7aMYOsPYO0tU2Jh2jw== )

#echo $RES_ALL

if grep -q "$RES_ALL" <<< $RES_DNS ; then
    echo "[ok] - ($n) DNSSEC signing works"
    g=$((g+1))
else
    echo "[not ok] - ($n) DNSSEC signing does NOT work"
    b=$((b+1))
fi


#== Test: DNS update with the TSIG key
n=$((n+1))

#-- prepare the update file:
TKEY=hmac-sha256:lb_key:AfgPlwpcSeTtf3g6y3NVp0Gx71dxGqwCnB5Px98tHpc=
FUPD=update.txt
echo -e "server localhost 5353\nupdate add mar.lbsec.com 86400 A 10.10.1.13\nsend" >$FUPD

#-- run update
nsupdate -y $TKEY $FUPD
if [ $? -eq 0 ]; then
    echo "[ok] - ($n) DNS update is working"
    g=$((g+1))
else 
    echo "[not ok] - ($n) DNS update is NOT working"
    b=$((b+1))
fi

rm -f $FUPD


#== Test: Zone Transfer with the TSIG key (assumption: port 5354 tcp)
n=$((n+1))

RES_ALL=$(dig -y $TKEY -4p 5354 @localhost axfr lbsec.com)
RES_DNS='SOA'
#echo $RES_ALL

if grep -q "$RES_ALL" <<< $RES_DNS ; then
    echo "[ok] - ($n) Zone Transfer is working"
    g=$((g+1))
else
    echo "[not ok] - ($n) Zone Transfer is NOT working"
    b=$((b+1))
fi



#== We are done
echo "[ok] - We are done: $g - success; $b - failure; $n total tests"

