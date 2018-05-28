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
cd /home/node && chmod 755 *.sh && ./stop.sh
cd /home/node && ./raft-init.sh && ./raft-start.sh

