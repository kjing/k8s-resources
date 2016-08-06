# Recipe: NGINX

This recipe shows you how to use NGINX in a Kubernetes cluster to provide SSL termination for other services in the cluster. NGINX will be deployed as a Kubernetes deployment with a service and public load balancer in front of it. SSL certificates, keys, and other secrets are managed via the Kubernetes Secrets API.  

![](https://github.com/GoogleCloudPlatform/nginx-ssl-proxy/blob/master/img/architecture.png)

### Kubernetes Versions

Tested on Kubernetes versions 1.3.2, 1.3.3

# Ingredients

Recommendations:
* When available we prefer the use of official images.  However in this case we are using a Docker image that was developed by Google for Kubernetes.  
* Always use specified versions.
* Use the smallest image possible (generally the alpine variant).

Google Image: [Nginx](https://github.com/GoogleCloudPlatform/nginx-ssl-proxy/blob/master/README.md)

# Preparation

### Prerequisites

This recipe assumes that you have a Kubernetes cluster installed and running, and that you have installed the `kubectl` command line tool somewhere in your path.

You can also test this using [Minikube](https://github.com/kubernetes/minikube) on your local machine.

### Steps

1. **Generate test certificates**

    **THIS IS NOT FOR PRODUCTION USE.**

    Use the setup-certs.sh script to generate test certificates. It will create your own Certificate Authority and
use that to self sign a certificate.

    ```shell
    ./setup-certs.sh /path/to/certs/folder
    ```

1. **Create a DHE param**

    The nginx SSL configuration for this image requires that you generate your own DHE parameter. Here's the command:

    ```shell
    openssl dhparam -out /path/to/secrets/dhparam.pem 2048
    ```

    Then create a Kubernetes secret to store it:

    ```shell
    k create secret generic dhparam --from-file=./dhparam.pem
    ```

2. **Create a user name and password**

    Use this command to create a user ID and password:

    ```shell
    htpasswd -nb YOUR_USERNAME SUPER_SECRET_PASSWORD > /path/to/secrets/htpasswd
    ```

    Then create a Kubernetes secret to store it:

    ```shell
    k create secret generic nginx-secret --from-file=./htpasswd
    ```

2. **Launch a Container**

    Modify the below command to include the actual address or host name you want to proxy to, as well as the correct /path/to/secrets for your certificate, key, and dhparam:

    ```shell
    docker run \
      -e ENABLE_SSL=true \
      -e TARGET_SERVICE=THE_ADDRESS_OR_HOST_YOU_ARE_PROXYING_TO \
      -v /path/to/secrets/cert.crt:/etc/secrets/proxycert \
      -v /path/to/secrets/key.pem:/etc/secrets/proxykey \
      -v /path/to/secrets/dhparam.pem:/etc/secrets/dhparam \
      nginx-ssl-proxy
    ```
    The really important thing here is that you map in your cert to `/etc/secrets/proxycert`, your key to `/etc/secrets/proxykey`, and your dhparam to `/etc/secrets/dhparam` as shown in the command above.

3. **Enable Basic Access Authentication**

    Create an htpaddwd file:

    ```shell
    htpasswd -nb YOUR_USERNAME SUPER_SECRET_PASSWORD > /path/to/secrets/htpasswd
    ```

    Launch the container, enabling the feature and mapping in the htpasswd file:

    ```shell
    docker run \
      -e ENABLE_SSL=true \
      -e ENABLE_BASIC_AUTH=true \
      -e TARGET_SERVICE=THE_ADDRESS_OR_HOST_YOU_ARE_PROXYING_TO \
      -v /path/to/secrets/cert.crt:/etc/secrets/proxycert \
      -v /path/to/secrets/key.pem:/etc/secrets/proxykey \
      -v /path/to/secrets/dhparam.pem:/etc/secrets/dhparam \
      -v /path/to/secrets/htpasswd:/etc/secrets/htpasswd \
      nginx-ssl-proxy
    ```
4. **Add additional nginx config**

   All *.conf from [nginx/extra](nginx/extra) are added during *built* to **/etc/nginx/extra-conf.d** and get included on startup of the container. Using volumes you can overwrite them on *start* of the container:

    ```shell
    docker run \
      -e ENABLE_SSL=true \
      -e TARGET_SERVICE=THE_ADDRESS_OR_HOST_YOU_ARE_PROXYING_TO \
      -v /path/to/secrets/cert.crt:/etc/secrets/proxycert \
      -v /path/to/secrets/key.pem:/etc/secrets/proxykey \
      -v /path/to/secrets/dhparam.pem:/etc/secrets/dhparam \
      -v /path/to/additional-nginx.conf:/etc/nginx/extra-conf.d/additional_proxy.conf \
      nginx-ssl-proxy
    ```

   That way it is possible to setup additional proxies or modifying the nginx configuration.

















## References
* [](https://github.com/GoogleCloudPlatform/nginx-ssl-proxy)
* [](https://github.com/GoogleCloudPlatform/kube-jenkins-imager)
* [](https://mozilla.github.io/server-side-tls/ssl-config-generator/)
* [](https://www.ctl.io/developers/blog/post/how-to-secure-your-private-docker-registry/)
* [](http://puck.in/2016/05/getting-started-with-docker-compose-prometheus-alertmanager-blackbox-exporter-grafana/)
