# Horizontal Pod Autoscaler (HPA)  

The  Horizontal Pod Autscaler ( HPA) is a special Kubernetes object that automatically scales up or down the number of pods in a deployment/replica set. 
It works by tracking metrics such as CPU, memory, etc. 
Whenever the utilization of these resources exceeds a certain percentage, a scale-out action is triggered, adding more identical pods to the deployment. 
Similarly, when the utilization percentage reduces, a scale in action is triggered, and unnecessary pods are terminated.  

## HPA Manifest  
To track the metrics mentioned above, we need to install the metrics-server in the kube-system namespace of our cluster. 
You can install that by following the [documentation here](https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html) .  

## Configure HPA  
- Install the `metrics-server`    
``` kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml ```     
- Configure `hpa` for specific deployment/replica-set.  

## Testing the HPA    
- Generate the load   
The command will create a POD called load-generator at the cluster using the busybox image and would provide us with a bash terminal from the POD container.     
``` kubectl run -i --tty load-generator --rm --image=busybox --restart=Never /bin/sh kubectl run -i --tty load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while true; do wget -q -O- http://<loadbalanceruri><endpoint>; done" ``` 
- Put a load   
The below script infinitely sends requests to the Nginx deployment via the load balancer. 
Do not forget to replace the loadbalancer-url with your current load balancer URL.  
``` while true; do wget -q -O- http://<loadbalancer-url>; done ```    
