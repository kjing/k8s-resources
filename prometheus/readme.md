TODO

use persistent storage


https://prometheus.io/docs/introduction/getting_started/



# Recipe: Prometheus

Redis is an open source (BSD licensed), in-memory data structure store, used as database, cache and message broker.

### Considerations

In general I am a bit old school and prefer to run data persistence / management applications outside of Kubernetes.  They generally already have various types of high availability built in, and they also tend to require very specific kernel tuning and storage to run optimally.   

Redis falls into this category.  It has it's own clustering and high availability functionality. In addition it requires very specific kernel parameters.  

This recipe will deploy Redis in a very simple manner but will leverage the capabilities of Kubernetes for a reasonably available service.  We will run a single instance of Redis backed by persistent storage using both RDB and AOF data persistence models.  If Redis were to crash under this configuration at most one second of writes could be lost and Kubernetes will automatically restart Redis.

### Data Persistence

We need to use persistent storage for the disk that Redis will use. For example on Google you can easily create a persistent disk with this command:

```
$ gcloud compute disks create --size 10GB redis-master
```

Redis offers two types of data persistence, RDB and AOF. The general indication is that you should use both persistence methods if you want a degree of data safety comparable to what PostgreSQL can provide you.

#### RDB

* RDB is a very compact single-file point-in-time representation of your Redis data. RDB files are perfect for backups and disaster recovery. For instance you may want to archive your RDB files every hour for the latest 24 hours, and to save an RDB snapshot every day for 30 days. This allows you to easily restore different versions of the data set in case of disasters.
* RDB allows faster restarts with big datasets compared to AOF.

#### AOF

* Using AOF Redis is much more durable: you can have different fsync policies such as fsync every second, or fsync at every query. With the default policy of fsync every second write performance is still great and you can only lose one second worth of writes.
* The AOF log is an append only log, so there are no seeks, nor corruption problems if there is a power outage. Even if the log ends with an half-written command for some reason (disk full or other reasons) the redis-check-aof tool is able to fix it easily.

### Kubernetes Versions

Tested on version 1.3.2

# Ingredients

Recommendations:
* When available we prefer the use of official images.
* Always use specified versions
* Use the smallest image possible (generally the alpine variant.)

Official Image: [Redis](https://hub.docker.com/_/redis/)

Example:

```
- name: redis
  image: redis:3.2.1-alpine
```

# Preparation

### Prerequisites

This recipe assumes that you have a Kubernetes cluster installed and running, and that you have installed the `kubectl` command line tool somewhere in your path.

You can also test this using `minikube` if you have it installed locally.




### Examples
http://www.robustperception.io/understanding-machine-cpu-usage/

overall value across all CPUs for the machine:

`sum by (mode, instance) (irate(node_cpu{job="node-exporter"}[5m]))`

calculate the percentage of CPU used, by subtracting the idle usage from 100%:

`100 - (avg by (instance) (irate(node_cpu{job="node-exporter",mode="idle"}[5m])) * 100)`


`prometheus_target_interval_length_seconds{quantile="0.99"}`





## References

* [reference](http://puck.in/2016/05/getting-started-with-docker-compose-prometheus-alertmanager-blackbox-exporter-grafana/)
* [Authentication](http://www.robustperception.io/adding-basic-auth-to-prometheus-with-nginx/)
