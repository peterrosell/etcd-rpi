# etcd-rpi

## Build docker image

To build a new docker image from source you just run the build script with a git tag as parameter.

This can now be run on a linux for amd64. By running cross compiling of the go code and only
add files when building the docker image it works without running it on a Raspberry Pi.

Example:

```bash
./build.sh v3.4.10
```

NOTE! To make the correct OS and architecture be specified for the image the build is done
with the experimental `buildx` docker feature. To use it you must make sure
[experimental mode](https://docs.docker.com/engine/reference/commandline/cli/#experimental-features) is
enabled for the docker client by adding `"experimental":"enabled"` to `~/.docker/config.json`.

Image are pushed to docker hub.

## Start etcd docker image

The environment variable GOMAXPROCS specifies how many CPU cores the Go process will use. 
If you only run etcd on the RPi use 4 cores to use the full capacity.
All parameters for the image are forwarded to the etcd process.

```bash
docker run -d --env GOMAXPROCS=4 -v /var/lib/etcd:/var/lib/etcd -p 2379:2379 -p 2380:2380 
--name=etcd peterrosell/etcd-rpi:2.3.7
-name etcd1 
-initial-advertise-peer-urls http://192.168.11.21:2380 
-listen-peer-urls http://0.0.0.0:2380 
-listen-client-urls http://0.0.0.0:2379 
-advertise-client-urls http://192.168.11.21:2379 
-initial-cluster-token etcd-cluster-1 
-initial-cluster etcd1=http://192.168.11.21:2380 
-initial-cluster-state new
-strict-reconfig-check
```
