#!/bin/bash

git clone https://github.com/mongodb/mongo-tools /tmp/mongo-tools
cd /tmp/mongo-tools
./make build

# check if ~/.mongo-tools exists
if [ ! -d ~/.mongo-tools ]; then
	mkdir ~/.mongo-tools
fi
mv bin ~/.mongo-tools/
rm -rf /tmp/mongo-tools
