#!/bin/bash

#
# This script logs the last 24 hours COMPLETED jobs info into a file to later feed elasticsearch
#
#
# The info recorded is:
#
#     End | Cluster | JobID | Partition | User | Account | AllocNodes | AllocCPUS | Elapsed | Submit | Eligible | Start | CPUTimeRaw in secs | State |
#

THEUSER="jonarbo"
HOMEDIR=/work/${THEUSER}/slurmusagelog

lasttimestampfile=${HOMEDIR}/lasttimestamp
origin="2018-04-01"
admins="ali|apps|benoit|ha42|hendra|jn63|mb4629|root|wa17"

today=`date +"%Y-%m-%d"`
yesterdate=`date +"%Y-%m-%d" -d "yesterday"`

if [ -e "${lasttimestampfile}" ] ; then 
	yesterdate=`cat ${lasttimestampfile}`
else
	yesterdate=${origin}
fi
echo $today > ${lasttimestampfile}

logfile="${HOMEDIR}/slurm.completed.${yesterdate}"

#
# Get all completed jobs from $YESTERDATE
#
ssh ${THEUSER}@slurm1 "sacct  -p -a -s COMPLETED  -S ${yesterdate} -E ${today} --format='end,cluster,JobID,Partition,user,Account,AllocNodes,AllocCPUS,elapsed,submit,Eligible,start,cputimeraw,state'" | grep COMPLETED | gawk -F"|" '{print $1","$2","$3","$4","$5","$6","$7","$8","$9","$10","$11","$12","$13}' | egrep -v  -e "[[:digit:]]+\." > $logfile 

if [ -e "$logfile" ]; then 

	#
	# Remove _ser and _par
	#
	cat $logfile  | sed "s/_ser,/,/g" | sed "s/_par,/,/g" >> $logfile.tmp

	#
	# remove admin users 
	#
	grep -vE "$admins" $logfile.tmp > $logfile

	#
	# append the slurm log file, this will trigger logstash to update
	# 
	cat $logfile >> ${HOMEDIR}/data/slurm.completed.logs.kk

	rm -rf $logfile 
	rm -rf $logfile.tmp 
fi

