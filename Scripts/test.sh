#!/bin/bash
#
# Test the JMeter Docker image using a trivial test plan.

# Example for using User Defined Variables with JMeter
# export TARGET_HOST="www.map5.nl"
# export TARGET_PORT="80"
# export TARGET_PATH="/kaarten.html"
# export TARGET_KEYWORD="Kaartdiensten"

T_DIR=$1

# Reporting dir: start fresh
R_DIR=${T_DIR}/report
#rm -rf ${R_DIR} > /dev/null 2>&1
#mkdir -p ${R_DIR}

#/bin/rm -f ${T_DIR}/Sample.jtl ${T_DIR}/jmeter.log  > /dev/null 2>&1

#./run.sh -Dlog_level.jmeter=DEBUG \
#	-n -t ${T_DIR}/Sample.jmx -l ${T_DIR}/Test-JTL/Sample.jtl -j ${T_DIR}/jmeter.log \
#	-e -o ${R_DIR}

jmeter -n -t ${T_DIR}/sample-plan.jmx -j ${T_DIR}/jmeter.log

echo "==== jmeter.log ===="
cat ${T_DIR}/jmeter.log

echo "==== Raw Test Report ===="
#cat ${T_DIR}/Test-JTL/Sample.jtl

echo "==== HTML Test Report ===="
#echo "See HTML test report in ${R_DIR}/index.html"
