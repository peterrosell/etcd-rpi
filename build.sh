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

if [ ! -d etcd ]; then
    git clone https://github.com/coreos/etcd.git
else
    echo "etcd is already cloned. Will use the current clone. If you want a newer version of etcd just delete the etcd directory and rerun the build script."
fi
cd etcd
git checkout $VERSION
cp ../Dockerfile Dockerfile
curl -fsSL -o go-wrapper https://raw.githubusercontent.com/docker-library/golang/master/go-wrapper
docker build -t peterrosell/etcd-rpi:$DOCKER_VERSION .
