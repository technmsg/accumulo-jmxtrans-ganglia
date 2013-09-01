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
#  Enable JMX in Accumulo environment script.
#

ACCUMULO_HOME=${ACCUMULO_HOME:-"/opt/accumulo-1.4.3-cdh4.3.0-SNAPSHOT"}
ACCUMULO_CONF_DIR=${ACCUMULO_CONF_DIR:-"${ACCUMULO_HOME}/conf"}
ACCUMULO_ENV=${ACCUMULO_CONF_DIR}/accumulo-env.sh

if [ ! -e ${ACCUMULO_ENV} ] ; then
  echo "${ACCUMULO_ENV} not found"
  exit 1
fi

grep -q jmxremote ${ACCUMULO_ENV}
if [ $? -gt 0 ] ; then
  cat accumulo-env.cf >> ${ACCUMULO_ENV}
else
  echo "JMX entries found already, manual inspection required"
  exit 1
fi

# EOF
