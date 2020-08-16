#!/bin/bash
#   Copyright 2015 Peter Rosell
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
set -xe

ETCD_VERSION=$1

VERSION=${ETCD_VERSION:-master}

if [ "${VERSION:0:5}" == "tags/" ]; then
    DOCKER_VERSION=${VERSION:6}
else
    DOCKER_VERSION=$VERSION
fi
if [ "${DOCKER_VERSION:0:1}" == "v" ]; then
    DOCKER_VERSION=${DOCKER_VERSION:1}
fi

mkdir -p .working
cd .working

# Clone and checkout etcd from github
if [ ! -d etcd ]; then
    git clone https://github.com/etcd-io/etcd.git
else
    echo "etcd is already cloned. Will use the current clone. If you want a newer version of etcd just delete the etcd directory and rerun the build script."
fi
cd etcd
git checkout $VERSION

# Build it for armv7
go mod vendor
env GOOS=linux GOARCH=arm GOARM=7 ./build
cd ..

# Fetch the binaries from the build
mkdir -p package
cp etcd/bin/etcd* package
cp ../Dockerfile .
docker buildx build --platform linux/arm/v7 -t peterrosell/etcd-rpi:$DOCKER_VERSION .
docker push peterrosell/etcd-rpi:$DOCKER_VERSION

#curl -fsSL -o go-wrapper https://raw.githubusercontent.com/docker-library/golang/master/go-wrapper
#docker build -t peterrosell/etcd-rpi:$DOCKER_VERSION .
