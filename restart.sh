#!/bin/bash
cd /home
mkdir -p tmp/node_default
mkdir -p node/qdata/dd/keystore
mkdir -p node/qdata/dd/geth
cd /home/node_default
cp genesis.json /home/node/
cp passwords.txt /home/node/
cp raft-init.sh /home/node/
cp raft-start.sh /home/node/
cp stop.sh /home/node
cd /home/node
GENERATE_KEY='#!/bin/bash
	bootnode -genkey nodekey \
	&& bootnode -writeaddress -nodekey nodekey > enode.key \
	&& echo -ne "\n" | constellation-node --generatekeys=tm \
	&& geth account new --password ./passwords.txt --keystore . \
	&& mv UTC* key'
echo "$GENERATE_KEY" > GENERATE_KEY.sh && chmod 755 GENERATE_KEY.sh && sh GENERATE_KEY.sh
GENERATE_CONSTELLATION_START='#!/bin/bash
    set -u
    set -e
    DDIR="qdata/c"
    mkdir -p $DDIR
    mkdir -p qdata/logs
    cp "tm.pub" "$DDIR/tm.pub"
    cp "tm.key" "$DDIR/tm.key"
    rm -f "$DDIR/tm.ipc"
    CMD="constellation-node --url=https://'$SERVICE_IP':9000/ --port=9000 --workdir=$DDIR --socket=tm.ipc --publickeys=tm.pub --privatekeys=tm.key --othernodes=https://'$SERVICE_IP1':9000/"
    $CMD >> "qdata/logs/constellation.log" 2>&1 &
    DOWN=true
    while $DOWN; do
        sleep 0.1
        DOWN=false
        if [ ! -S "qdata/c/tm.ipc" ]; then
                DOWN=true
        fi
    done'
echo "$GENERATE_CONSTELLATION_START" > constellation-start.sh && chmod 755 constellation-start.sh && sh constellation-start.sh
