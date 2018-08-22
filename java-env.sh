#!/bin/bash
# desc: jdk环境脚本
************************************
export JAVA_HOME=/usr/java/jdk1.7.0_79
export JRE_HOME=${JAVA_HOME}/jre
export PATH=$PATH:${JAVA_HOME}/bin:${JRE_HOME}/bin
export CLASSPATH=${JAVA_HOME}/lib:${JRE_HOME}/lib
************************************
