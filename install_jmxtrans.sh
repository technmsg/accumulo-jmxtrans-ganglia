#!/bin/sh
#
#  Copyright 2013 Cloudera Inc.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
# 
#  http://www.apache.org/licenses/LICENSE-2.0
# 
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

# 
# Install jmxtrans and configure it to poll Accumulo metrics.
#
# Assumes a fair bit:
# - you're root on Ganglia monitor host
# - you have Ganglia gmetad installed on the monitor host
# - you have Ganglia gmond installed on the tablet servers
# - you have Accumulo installed on the host
# - you have root key-based authentication to all tablet servers
# - the .json templates and jmxtrans RPM are in current working dir
# - you've set the three options below to match your environment

# 1. Accumulo base directory
ACCUMULO_HOME=${ACCUMULO_HOME:-"/opt/accumulo-1.4.3-cdh4.3.0-SNAPSHOT"}

# 2. Name of the RPM you're going to be installing; do not include path
JMXTRANS_RPM="jmxtrans-20121016.145842.6a28c97fbb-0.noarch.rpm"

# 3. Hostname of the Ganglia monitor (not localhost)
GANGLIA_MONITOR="accumulo-cdh4-1"

#
#
#
ACCUMULO_CONF_DIR=${ACCUMULO_CONF_DIR:-"${ACCUMULO_HOME}/conf"}

# Temporary directory for node configuration.
NODE_CFGS="jmxtrans_cfg"
mkdir ${NODE_CFGS}
if [ ! -d ${NODE_CFGS} ] ; then
  echo "Can't create node config dir. Exiting."
  exit 1
fi

SLAVES="${ACCUMULO_CONF_DIR}/slaves"
if [ ! -e ${SLAVES} ] ; then
  echo "Slaves file missing. Exiting."
  exit 1
fi
for HOST in `cat ${SLAVES}` ; do

  echo "** $HOST **"

  # Install
  echo Installing jmxtrans
  scp $JMXTRANS_RPM $HOST:
  ssh $HOST rpm -ivh $JMXTRANS_RPM

  # Configuration
  echo Configuring jmxtrans
  scp /usr/share/jmxtrans/jmxtrans.sh $HOST:/usr/share/jmxtrans/
  ssh $HOST chkconfig --level 345 jmxtrans on
  JMXTRANS_TSERVER_CFG="accumulo-tserver-${HOST}.json"
  sed -e "s/MonitorHost/${GANGLIA_MONITOR}/g" -e "s/localhost/${HOST}/g" accumulo-tserver.json > ${NODE_CFGS}/${JMXTRANS_TSERVER_CFG}
  JMXTRANS_LOGGER_CFG="accumulo-logger-${HOST}.json"
  sed -e "s/MonitorHost/${GANGLIA_MONITOR}/g" -e "s/localhost/${HOST}/g" accumulo-logger.json > ${NODE_CFGS}/${JMXTRANS_LOGGER_CFG}
  scp "${NODE_CFGS}/${JMXTRANS_TSERVER_CFG}" "${NODE_CFGS}/${JMXTRANS_LOGGER_CFG}" $HOST:/var/lib/jmxtrans/

  # Fire it up!
  echo Starting jmxtrans
  ssh $HOST service jmxtrans start

  # Restart gmond, to detect new metrics.
  echo Restarting gmond
  ssh $HOST service gmond restart   

done

# Restart gmetad, to detect new metrics.
service gmetad restart

# EOF
