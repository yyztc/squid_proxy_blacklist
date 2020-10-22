#!/bin/bash

BINDIR=`dirname $0`
LOG_FILE=${BINDIR}/update_proxy_blacklist.log
TMP_FILE=${BINDIR}/update_proxy_blacklist.tmp
OUT_FILE=${BINDIR}/blacklist.txt


## Step.1 Clear old tmp list
echo `date '+%Y/%m/%d %H:%M:%S'` old black list is `wc -l ${OUT_FILE} | awk '{print $1}'` lines >> ${LOG_FILE}
cat /dev/null > ${TMP_FILE}


## Step.2 Create new list

# --- from malwaredomainlist.com
echo `date '+%Y/%m/%d %H:%M:%S'` http get from malwaredomainlist.com >> ${LOG_FILE}
curl http://www.malwaredomainlist.com/hostslist/hosts.txt |\
awk '/^127.0.0.1/ { print $2 }' >> ${TMP_FILE} 2>> ${LOG_FILE}

# --- from malwaredomains.com
echo `date '+%Y/%m/%d %H:%M:%S'` http get malwaredomains.com >> ${LOG_FILE}
curl http://mirror1.malwaredomains.com/files/domains.txt |\
perl -wn -e 'if(/^\t([^\t]+)?\t([^\t]+)/){print "$2\n"}' >> ${TMP_FILE} 2>> ${LOG_FILE}

# --- from winhelp2002.mvps.org
echo `date '+%Y/%m/%d %H:%M:%S'` http get winhelp2002.mvps.org >> ${LOG_FILE}
curl https://winhelp2002.mvps.org/hosts.txt |\
awk '/^0.0.0.0/ { print $2 }' >> ${TMP_FILE} 2>> ${LOG_FILE}


## Step.3 Sort and Uniq and Add Dot
cat ${TMP_FILE} | sort | uniq | perl -wp -e 's/^([^.])/.$1/' | perl ${BINDIR}/eliminate_overlap_name.pl > ${OUT_FILE}

echo `date '+%Y/%m/%d %H:%M:%S'` new black list is `wc -l ${OUT_FILE} | awk '{print $1}'` lines >> ${LOG_FILE}


## Step.4 Squid reload
# set root cron: service squid reload

