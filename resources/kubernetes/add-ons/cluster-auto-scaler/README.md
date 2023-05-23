## Testing The Cluster Autoscaler

Open
two
terminal
windows
side
by
side
to
monitor
the
number
of
pods
and
nodes
in
real
time:

### Terminal 1 - Monitor pods in real time

```kubectl get pods --namespace nginx-ns -w```

### Terminal 2 - Monitor nodes in real time

```kubectl get nodes -w```

To
test
the
Cluster
Autoscaler,
we
would
need
to
increase
the
replicas
for
our
deployment
to
a
higher
number (
say
10)
.
This
would
increase
the
requested
CPU
and
make
the
Cluster
Autoscaler
trigger
a
scale-out
action,
and
add
more
nodes
to
our
cluster :

k8s-config/deployment.yml
```kubectl scale --replicas=60 -f 3_k8s_apps/nginx/nginx.yml```

On
applying
the
manifest,
you
will
notice
an
increase
in
the
number
of
pods
and
nodes
in
the
two
open
terminal
windows:

We
have
a
working
Cluster
Autoscaler
at
this
stage!
