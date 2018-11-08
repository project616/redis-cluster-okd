REDIS CLUSTER ON TOP OF OPENSHIFT ORIGIN
====



Deploy all the pods
---

    $ oc create -f redis_configmap.yml
    $ oc create -f redis_cache_service.yml
    $ oc create -f redis_buildconfig.yml

After the build of the imagestream is completed, bootstrap the nodes:

    $ for node in $(seq 0 5); { oc create -f redis_node_$node.yml; sleep 2; }


Finally, in order to manage the cluster and eventually make some maintenance on it, we need
to deploy a redis-trib pod that we used to bootstrap the cluster.
So, move on redis-trib dir and run:

    $ oc create -f redis_trib_buildconfig.yml
    $ oc create -f redis_trib_node.yml


Bootstrap the cluster
---

The redis-trib pod coming from the redis-mgmt buildconfig represents the management pod used 
to run the redis-trib script in order to configure in the correct way the cluster.
In particular, sending the command:

    $ kubectl exec -it $(oc get pods | awk '/trib/ {print $0}') -- redis-trib create \
        --replicas 1 $(kubectl get pods -l app=redis-cluster -o \
        jsonpath='{range.items[*]}{.status.podIP}:6379 ')

Now you can login to any node of the redis cluster and try see the generated cluster info.
