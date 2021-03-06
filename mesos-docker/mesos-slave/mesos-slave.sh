#!/bin/bash
read -p "Please input the mesos-slave running port:(default:5051)" slaveport
if [ -z "${slaveport}" ];then
  slaveport=5051
fi
read -p "Please input the mesos-master's ip:" masterip
read -p "Please input the mesos-master's port:(default:5050)" masterport
if [ -z "${masterport}" ];then
	masterport=5050
fi
rm -rf ./tmp
docker run -d --privileged --restart=always \
  -p $slaveport:5051 \
  -e MESOS_PORT=5051 \
  -e MESOS_MASTER=zk://$masterip:$masterport/mesos \
  -e MESOS_SWITCH_USER=0 \
  -e MESOS_CONTAINERIZERS=docker,mesos \
  -e MESOS_LOG_DIR=/var/log/mesos \
  -e MESOS_WORK_DIR=/var/tmp/mesos \
  -v "$(pwd)/log/mesos:/var/log/mesos" \
  -v "$(pwd)/tmp/mesos:/var/tmp/mesos" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /sys:/sys \
  -v /usr/local/bin/docker:/usr/local/bin/docker \
  mesosphere/mesos-slave:1.5.0 --no-systemd_enable_support 