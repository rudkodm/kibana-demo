#!/usr/bin/env bash

# Start work with this script:
# source tasks.sh

# Connect to Docker-Machine:
# tcuser ==> ssh docker@${HDP_HOST}

# Run cluster components:
# /etc/init.d/startup_script start

# Reset Ambari password:
# ambari-admin-password-reset

# docker load < HDP_???

: ${HDP_HOST=$(docker-machine ip default)}
: ${HDP_IMAGE_NAME='hdp'}
: ${HDP_SSH_USER='root'}
: ${HDP_SSH_PASSWORD='root'}


hdp-info() {
cat << EOF
  ==============================================
  CONTAINER_HOST:            ${HDP_HOST}
  CONTAINER_NAME:            ${HDP_IMAGE_NAME}
  CONTAINER_SSH_USER:        ${HDP_SSH_USER}
  CONTAINER_SSH_PASSWORD:    ${HDP_SSH_PASSWORD}
  ==============================================
EOF
}


hdp-create-docker-machine() {
    docker-machine rm default
    docker-machine create -d virtualbox --virtualbox-memory=8092 --virtualbox-cpu-count=4 --virtualbox-disk-size=50000 default
}


hdp-setup-docker() {
    eval $(docker-machine start default)
    eval $(docker-machine env default)
}


hdp-start-container() {
    echo "Container ID:" && docker run -v hadoop:/hadoop -m 8g --name ${HDP_IMAGE_NAME} --hostname "sandbox.hortonworks.com" --privileged -d \
    -p 6080:6080 \
    -p 9090:9090 \
    -p 9000:9000 \
    -p 8000:8000 \
    -p 8020:8020 \
    -p 42111:42111 \
    -p 10500:10500 \
    -p 16030:16030 \
    -p 8042:8042 \
    -p 8040:8040 \
    -p 2100:2100 \
    -p 4200:4200 \
    -p 4040:4040 \
    -p 8050:8050 \
    -p 9996:9996 \
    -p 9995:9995 \
    -p 8080:8080 \
    -p 8088:8088 \
    -p 8886:8886 \
    -p 8889:8889 \
    -p 8443:8443 \
    -p 8744:8744 \
    -p 8888:8888 \
    -p 8188:8188 \
    -p 8983:8983 \
    -p 1000:1000 \
    -p 1100:1100 \
    -p 11000:11000 \
    -p 10001:10001 \
    -p 15000:15000 \
    -p 10000:10000 \
    -p 8993:8993 \
    -p 1988:1988 \
    -p 5007:5007 \
    -p 50070:50070 \
    -p 19888:19888 \
    -p 16010:16010 \
    -p 50111:50111 \
    -p 50075:50075 \
    -p 50095:50095 \
    -p 18080:18080 \
    -p 60000:60000 \
    -p 8090:8090 \
    -p 8091:8091 \
    -p 8005:8005 \
    -p 8086:8086 \
    -p 8082:8082 \
    -p 60080:60080 \
    -p 8765:8765 \
    -p 5011:5011 \
    -p 6001:6001 \
    -p 6003:6003 \
    -p 6008:6008 \
    -p 1220:1220 \
    -p 21000:21000 \
    -p 6188:6188 \
    -p 61888:61888 \
    -p 2181:2181 \
    -p 2222:22 \
    sandbox-hdp /usr/sbin/sshd -D

    # Set root pasword to 'root'
    echo -e "${HDP_SSH_USER}\n${HDP_SSH_PASSWORD}" | docker exec -i ${HDP_IMAGE_NAME} passwd

    # Copy id_rsa.pub to HDP /root/.ssh/authorized_keys
    ssh-copy-id ${HDP_SSH_USER}@${HDP_HOST} -p 2222
}


hdp-kill-container() {
    echo 'Stop container:' && docker stop ${HDP_IMAGE_NAME}
    echo 'Delete container:' && docker rm ${HDP_IMAGE_NAME}
}

hdp-ssh() {
    ssh ${HDP_SSH_USER}@${HDP_HOST} -p 2222
}