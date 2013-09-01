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
#  Enable Accumulo metrics and logging.
#

ACCUMULO_HOME=${ACCUMULO_HOME:-"/opt/accumulo-1.4.3-cdh4.3.0-SNAPSHOT"}
ACCUMULO_CONF_DIR=${ACCUMULO_CONF_DIR:-"${ACCUMULO_HOME}/conf"}
ACCUMULO_METRICS=${ACCUMULO_CONF_DIR}/accumulo-metrics.xml

if [ ! -e ${ACCUMULO_METRICS} ] ; then
  echo "${ACCUMULO_METRICS} not found. Exiting."
  exit 1
fi

#
# In Accumulo 1.4.3, metrics and logging are disabled
# by default. If we find anything enabled, don't modify
# anything.
#
# If this changes in 1.5 or beyond, revisit.
#
grep -qi true ${ACCUMULO_METRICS}
if [ $? -gt 0 ] ; then
  echo "Non-default metrics configuration detected, manual inspection required. Exiting."
  exit 1
else
  cp -av ${ACCUMULO_METRICS} ${ACCUMULO_METRICS}.disabled
  sed -e "s/false/true/" ${ACCUMULO_METRICS}.disabled > ${ACCUMULO_METRICS}
fi

# EOF
