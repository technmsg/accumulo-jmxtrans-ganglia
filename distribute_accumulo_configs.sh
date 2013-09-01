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
ACCUMULO_HOME=${ACCUMULO_HOME:-"/opt/accumulo-1.4.3-cdh4.3.0-SNAPSHOT"}
ACCUMULO_CONF_DIR=${ACCUMULO_CONF_DIR:-"${ACCUMULO_HOME}/conf"}
SLAVES="${ACCUMULO_CONF_DIR}/slaves"

if [ ! -e ${SLAVES} ] ; then
  echo "Slaves file missing. Exiting."
  exit 1
fi

for HOST in `cat ${SLAVES}` ; do

  echo "** $HOST **"

  scp ${ACCUMULO_CONF_DIR}/accumulo-env.sh $HOST:${ACCUMULO_CONF_DIR}/
  scp ${ACCUMULO_CONF_DIR}/accumulo-metrics.xml $HOST:${ACCUMULO_CONF_DIR}/
  scp ${ACCUMULO_CONF_DIR}/accumulo-site.xml $HOST:${ACCUMULO_CONF_DIR}/
  scp ${ACCUMULO_CONF_DIR}/log4j.properties $HOST:${ACCUMULO_CONF_DIR}/

done

if [ "$1" == "restart" ] ; then
  echo "restarting cluster"
  ${ACCUMULO_HOME}/bin/stop-all.sh
  ${ACCUMULO_HOME}/bin/start-all.sh
fi

# EOF
