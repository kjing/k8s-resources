# gcloud script

# create your kubernetes cluster
gcloud container clusters create cluster-1 --num-nodes 5

# use google cloud console to ssh into each cluster machine
# $ sudo su -
# $ sudo echo never > /sys/kernel/mm/transparent_hugepage/enabled
# $ sudo nano /etc/rc.local
# Add the same line above the exit 0 (echo never > /sys/kernel/mm/transparent_hugepage/enabled)

# https://cloud.google.com/solutions/real-time/kubernetes-redis-bigquery#optional_updating_the_startup_scripts_for_long-term_redis_reliability
#
# http://stackoverflow.com/questions/34141454/sysctl-values-for-google-container-engine-instances
#
# http://redis.io/topics/admin
#
# http://serverfault.com/questions/271380/how-can-i-increase-the-value-of-somaxconn





# create persistent disks
gcloud compute disks create --size 10GB redis-master

# Wordpress
gcloud compute disks create --size 200GB mysql-disk
gcloud compute disks create --size 200GB wordpress-disk

# create persistent disks
gcloud compute disks create --size 10GB sqlpad

# Ghost
gcloud compute disks create --size 200GB ghost-config
gcloud compute disks create --size 200GB ghost-content

# Prometheus
gcloud compute disks create --size 200GB prometheus

# Grafana
gcloud compute disks create --size 200GB grafana

#################################################################
#
#      CLEANUP - Uncomment below
#
#################################################################

# Delete your cluster:
gcloud container clusters delete cluster-1

# Delete your  disks:
gcloud compute disks delete redis-master

# Wordpress disks
gcloud compute disks delete mysql-disk
