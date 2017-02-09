## Traefik Recipe

This recipe will deploy [traefik](https://docs.traefik.io/) on Kubernetes.  

https://docs.traefik.io/user-guide/kubernetes/

**Table of Contents**

  - [Sqlpad Recipe](#guestbook-example)
    - [Prerequisites](#prerequisites)
    - [Quick Start](#quick-start)
    - [Step One: Start up the redis master](#step-one-start-up-the-redis-master)
      - [Define a Deployment](#define-a-deployment)
      - [Define a Service](#define-a-service)
      - [Create a Service](#create-a-service)
      - [Finding a Service](#finding-a-service)
        - [Environment variables](#environment-variables)
        - [DNS service](#dns-service)
      - [Create a Deployment](#create-a-deployment)
      - [Optional Interlude](#optional-interlude)
    - [Step Two: Start up the redis slave](#step-two-start-up-the-redis-slave)
    - [Step Three: Start up the guestbook frontend](#step-three-start-up-the-guestbook-frontend)
      - [Using 'type: LoadBalancer' for the frontend service (cloud-provider-specific)](#using-type-loadbalancer-for-the-frontend-service-cloud-provider-specific)
    - [Step Four: Cleanup](#step-four-cleanup)
    - [Troubleshooting](#troubleshooting)
    - [Appendix: Accessing the guestbook site externally](#appendix-accessing-the-guestbook-site-externally)
      - [Google Compute Engine External Load Balancer Specifics](#google-compute-engine-external-load-balancer-specifics)

The Recipe consists of:

deployed a node.js based application called Sqlpad.  The application can be used to interact with several popular SQL databases.

**Note**:  If you are running this example on a [Google Container Engine](https://cloud.google.com/container-engine/) installation, see [this Google Container Engine guestbook walkthrough](https://cloud.google.com/container-engine/docs/tutorials/guestbook) instead. The basic concepts are the same, but the walkthrough is tailored to a Container Engine setup.

### Prerequisites

This example requires a running Kubernetes cluster. First, check that kubectl is properly configured by getting the cluster state:

```console