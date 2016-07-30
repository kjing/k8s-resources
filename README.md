# k8s-resources

## A TypicaL Journey

#### No Containers

You begin with an "old school" business.  Let's say we have a PostgreSQL database cluster and a Redis cluster and various applications, reporting tools, and web properties interacting with these clusters.  You're not a bright shiny startup, but an existing business that has been around for while and you have a lot of legacy "stuff".

#### Some Containers

You discover Docker and start containerizing.  You find that once you learn how to put your web applications in containers it gives you automatic restarts, easier deployments and more consistency across environments.  You decide containers are cool and start containerizing other things.

So far though, these containers work by leveraging your *existing infrastructure* - they can access your storage, they leverage your DNS to find your database and Redis server(s), etc.  You think to yourself - this is awesome!  It becomes trivially easy for your QA team to spin up a machine pointing to the QA database, run tests and spin it down - they just need to learn some Docker commands.

#### Lots of Containers

But it's getting harder to manage all your containers.  You need/want something to place containers on hosts for you, you want to manage rolling updates, load balancing and scaling become concerns and you discover Kubernetes.  "Aha" you say!  My troubles are over!  I am going to manage my containers using Kubernetes.

You don't really consider containerizing/moving your legacy data stores (they sit on special hardware and storage) and you have some legacy stuff you don't want to touch, but you think an architecture like this seems pretty reasonable:

```
+--------------------+       +-------------+       +-------------+
|                    |       |             |       |             |
|     Kubernetes     |<----->|  PostgreSQL |<----->|   Legacy    |
|                    |       |             |       |             |
|                    |       +-------------+       +-------------+
|                    |                               /            
|                    |       +-------------+        /
|                    |       |             |       /
|                    |<----->|    Redis    |<-----/
|                    |       |             |
+--------------------+       +-------------+
```

#### Challenges (Kubernetes 1.3)

* You discover anything inside Kubernetes has its own DNS and cannot "see" anything outside of Kubernetes
* Your containers that were trivially easy to run outside of Kubernetes, cannot see or access your PostgreSQL or Redis production systems from inside Kubernetes.
* You might consider moving Redis inside Kubernetes (but not PostgreSQL yet), however you find that Redis clustering, sentinels, etc. don't exactly fit how Kubernetes works.  There are many examples of how to run Redis inside Kubernetes none seem to be truly a full production-level example. Pet Sets are brand new.




New Cluster Setup
-----------------

0. Clone k8s-resources `git clone https://github.com/dstroot/k8s-resources.git && cd k8s-resources`

1. Setup Namespaces  http://kubernetes.io/docs/admin/namespaces/

   NOTE: Use kubectl create -f <directory> where possible. This looks for config objects in all .yaml, .yml, and .json files in <directory> and passes them to create.

   `kubectl create -f namespaces`

2. Build out backend

   NOTE:
   * It’s typically best to create a service before corresponding replication controllers, so that the scheduler can spread the pods comprising the service.
   * Best practices: http://kubernetes.io/docs/user-guide/config-best-practices/

Information taken from here: https://github.com/kubernetes/kubernetes/tree/master/examples/k8petstore


### Redis

Redis is configured via a .conf file.  So when you are building redis containers and you want to tune your configuration you change the .conf and rebuild the container. So the docker file would look like this:

```
# Copyright 2016 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# Redis Dockerfile
#
# https://github.com/dockerfile/redis
#

# Pull base image.
#
# Just a stub.

FROM redis

ADD etc_redis_redis.conf /etc/redis/redis.conf

CMD ["redis-server", "/etc/redis/redis.conf"]
# Expose ports.
EXPOSE 6379
```

and the redis.conf file would be:

```
pidfile /var/run/redis.pid
port 6379
tcp-backlog 511
timeout 0
tcp-keepalive 0
loglevel verbose
syslog-enabled yes
databases 1
save 1 1
save 900 1
save 300 10
save 60 10000
stop-writes-on-bgsave-error yes
rdbcompression no
rdbchecksum yes
dbfilename dump.rdb
dir /data
slave-serve-stale-data no
slave-read-only yes
repl-disable-tcp-nodelay no
slave-priority 100
maxmemory <bytes>
appendonly yes
appendfilename "appendonly.aof"
appendfsync everysec
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 1
aof-load-truncated yes
lua-time-limit 5000
slowlog-log-slower-than 10000
slowlog-max-len 128
latency-monitor-threshold 0
notify-keyspace-events "KEg$lshzxeA"
list-max-ziplist-entries 512
list-max-ziplist-value 64
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
hll-sparse-max-bytes 3000
activerehashing yes
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit slave 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60
hz 10
aof-rewrite-incremental-fsync yes
```
