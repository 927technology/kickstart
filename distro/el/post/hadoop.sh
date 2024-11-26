#!/bin/bash

# commands
cmd_cat=/usr/bin/cat
cmd_chmod=/usr/bin/chmod
cmd_chown=/usr/bin/chown
cmd_cp=/usr/bin/cp
cmd_hdfs=/usr/local/hadoop/bin/hdfs
cmd_ln=/usr/bin/ln
cmd_mkdir=/usr/bin/mkdir
cmd_mv=/usr/bin/mv
cmd_rm=/usr/bin/rm
cmd_start-dfs=/usr/local/hadoop/sbin/start-dfs.sh
cmd_start-yarn=/usr/local/hadoop/sbin/start-yarn.sh
cmd_su=/usr/bin/su
cmd_tar=/usr/bin/tar
cmd_useradd=/usr/sbin/useradd
cmd_wget=/usr/bin/wget
cmd_yum=/usr/bin/yum

# variables
hadoop_version=3.4.0
hdfs_path=/home/hadoop/hdfs

# exported variables
export HADOOP_HOME=/usr/local/hadoop

# prerequisites
${cmd_yum} install -y java-21-openjdk java-21-openjdk-devel

# create hadoop user
${cmd_useradd} hadoop
${cmd_su} hadoop --login --shell=/bin/sh "--command=/usr/bin/ssh-keygen -t rsa -N '' -f /home/hadoop/.ssh/id_rsa"
${cmd_su} hadoop --login --shell=/bin/sh "--command=/bin/cat /home/hadoop/.ssh/id_rsa.pub >> /home/hadoop/.ssh/authorized_keys"

# setup ssh
${cmd_chmod} 700 /home/hadoop/hadoop/.ssh
${cmd_chmod} 600 /home/hadoop/hadoop/.ssh/authorized_keys

# accept ssh fingerprint
${cmd_su} hadoop --login --shell=/bin/sh "--command=/usr/bin/ssh -o StrictHostKeyChecking=no localhost"

# configure hadoop user environment
${cmd_cat} << EOF.bashrc >> /home/hadoop/.bashrc
export HADOOP_HOME=/usr/local/hadoop
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"

export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
EOF.bashrc

# get hadoop
${cmd_wget} https://dlcdn.apache.org/hadoop/common/hadoop-${hadoop_version}/hadoop-${hadoop_version}.tar.gz -P /home/hadoop/
${cmd_tar} xzvf /home/hadoop/hadoop-${hadoop_version}.tar.gz -C /usr/local/
${cmd_rm} -f /home/hadoop/hadoop-${hadoop_version}.tar.gz

# setup application path
chown hadoop:hadoop -R /usr/local/hadoop-${hadoop_version}
${cmd_ln} -s /usr/local/hadoop-${hadoop_version} /usr/local/hadoop

# javax activation
#${cmd_wget} https://jcenter.bintray.com/javax/activation/javax.activation-api/1.2.0/javax.activation-api-1.2.0.jar -P /home/hadoop

# create dfs folders
${cmd_mkdir} -p ${hdfs_path}/{namenode,datanode}
${cmd_chown} hadoop:hadoop -R ${hdfs_path}/{namenode,datanode}

# hadoop-env.sh
${cmd_cat} << EOF.hadoop-env >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
export HADOOP_CLASSPATH+='"${HADOOP_HOME}/lib/*.jar"'
EOF.hadoop-env

# core-site.xml
${cmd_cp} ${HADOOP_HOME}/etc/hadoop/core-site.xml ${HADOOP_HOME}/etc/hadoop/core-site.xml.bkup
cat << EOF.core-site > ${HADOOP_HOME}/etc/hadoop/core-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<configuration>
  <property>
    <name>fs.default.name</name>
    <value>hdfs://0.0.0.0:9000</value>
    <description>The default file system URI</description>
  </property>
</configuration>
EOF.core-site


# hdfs-site.xml
${cmd_cp} ${HADOOP_HOME}/etc/hadoop/hdfs-site.xml ${HADOOP_HOME}/etc/hadoop/hdfs-site.xml.bkup
${cmd_cat} << EOF.hdfs-site > ${HADOOP_HOME}/etc/hadoop/hdfs-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<configuration>
  <property>
    <name>dfs.replication</name>
    <value>1</value>
  </property>
  
  <property>
    <name>dfs.name.dir</name>
    <value>file:///home/hadoop/hdfs/namenode</value>
  </property>
  
  <property>
    <name>dfs.name.dir</name>
    <value>file:///home/hadoop/hdfs/datanode</value>
  </property>
</configuration>
EOF.hdfs-site

# mapred-site.xml
${cmd_cp} ${HADOOP_HOME}/etc/hadoop/mapred-site.xml ${HADOOP_HOME}/etc/hadoop/mapred-site.xml.bkup
${cmd_cat} << EOF.mapred-site > ${HADOOP_HOME}/etc/hadoop/mapred-site.xml
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<configuration>
  <property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
  </property>
</configuration>
EOF.mapred-site

# yarn-site.xml
${cmd_cp} ${HADOOP_HOME}/etc/hadoop/yarn-site.xml ${HADOOP_HOME}/etc/hadoop/yarn-site.xml.bkup
${cmd_cat} << EOF.yarn-site > ${HADOOP_HOME}/etc/hadoop/yarn-site.xml
<?xml version="1.0"?>

<configuration>
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
</configuration>
EOF.yarn-site


# initalize file system
${cmd_hdfs} namenode -format -force

# enable services
${cmd_cat} << EOF.crontab > /etc/cron.d/hadoop
@reboot hadoop ${start_dfs}
@reboot hadoop ${start_yarn}
EOF.crontab

# firewall
firewall-offline-cmd --add-port=8088/tcp
firewall-offline-cmd --add-port=9870/tcp
