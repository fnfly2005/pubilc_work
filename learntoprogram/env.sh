#!/bin/bash
#java/python-环境变量
#add python env
export PATH="/Users/fannian/anaconda2/bin:$PATH"

#add java env
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_181.jdk/Contents/Home
export CLASSPATH=$CLASSPATH:$JAVA_HOME/lib:$JAVA_HOME/jre/liba
export PATH=$JAVA_HOME/bin:$PATH
