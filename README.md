# kubernetes-devops-security

## Fork and Clone this Repo

## Clone to Desktop and VM

## NodeJS Microservice - Docker Image -
`docker run -p 8787:5000 siddharth67/node-service:v1`

`curl localhost:8787/plusone/99`

## NodeJS Microservice - Kubernetes Deployment -
`kubectl create deploy node-app --image siddharth67/node-service:v1`

`kubectl expose deploy node-app --name node-service --port 5000 --type ClusterIP`

`curl node-service-ip:5000/plusone/99`

## Jenkins

![alt text](image.png)

![alt text](image-1.png)


We implemented several security measures throughout our CI/CD pipeline using a variety of security tools. To start, we enhanced developer workstation security by integrating Talisman Git hooks to prevent sensitive data from being committed. We incorporated rigorous testing methodologies, including mutation tests and integration testing, to ensure application robustness.

Our pipeline included tools for Static Application Security Testing (SAST) and Dynamic Application Security Testing (DAST), alongside a comprehensive suite of vulnerability scanners like Trivy, OPA, and KubeSec. These tools allowed us to identify vulnerabilities within Dockerfiles and Kubernetes resources.

We optimized our Kubernetes deployment strategy by validating deployment statuses. Based on the results, we either completed the deployment successfully or rolled back to the previous version if the deployment failed. Additionally, we ensured transparency and collaboration by sending Jenkins build notifications to Slack, keeping the team informed about the pipeline's progress.

Finally, the pipeline concluded with promoting the application to a production instance or namespace, ensuring a secure and reliable deployment process.

## Install Istio

wget https://storage.googleapis.com/istio-release/releases/1.24.0/istio-1.24.0-linux-amd64.tar.gz
tar -zxvf istio-1.24.0-linux-amd64.tar.gz
cd istio-1.24.0/
export PATH=$PWD/bin:$PATH
echo $PATH
istioctl install --set profile=demo -y && kubectl apply -f samples/addons

### On successful installation

       |\          
        | \         
        |  \        
        |   \       
      /||    \      
     / ||     \     
    /  ||      \    
/   ||       \   
/    ||        \  
/     ||         \
/______||__________\
____________________
\__       _____/  
\_____/

✔ Istio core installed ⛵️                                                                                                                                  
✔ Istiod installed 🧠                                                                                                                                      
✔ Egress gateways installed 🛫                                                                                                                             
✔ Ingress gateways installed 🛬                                                                                                                            
✔ Installation complete                                                                                                                                    
serviceaccount/grafana created
configmap/grafana created
service/grafana created <<<---
deployment.apps/grafana created <<<<<<<<---------------- out of the box (for visualizing time series data for infrastructure and application analytics)
configmap/istio-grafana-dashboards created
configmap/istio-services-grafana-dashboards created
deployment.apps/jaeger created <<<<<<<<<<<--------- out of the box (for monitoring and troubleshooting microservices-based distributed systems)
service/tracing created
service/zipkin created
service/jaeger-collector created
serviceaccount/kiali created
configmap/kiali created
clusterrole.rbac.authorization.k8s.io/kiali created
clusterrolebinding.rbac.authorization.k8s.io/kiali created
service/kiali created  <<<---
deployment.apps/kiali created  <<<<<<<<<<----------- out of the box (to visualise the service mesh topology, features like request rates)
serviceaccount/loki created
configmap/loki created
configmap/loki-runtime created
clusterrole.rbac.authorization.k8s.io/loki-clusterrole created
clusterrolebinding.rbac.authorization.k8s.io/loki-clusterrolebinding created
service/loki-memberlist created
service/loki-headless created
service/loki created
statefulset.apps/loki created
serviceaccount/prometheus created
configmap/prometheus created
clusterrole.rbac.authorization.k8s.io/prometheus created
clusterrolebinding.rbac.authorization.k8s.io/prometheus created
service/prometheus created <<<---
deployment.apps/prometheus created <<<<<<<<<<<<<<------------ out of the box (monitoring and alerting tool. It monitors multiple microservices running in your system)

root@devsecops-cloud:~/istio-1.24.0# kubectl get ns
NAME              STATUS   AGE
default           Active   5d22h
istio-system      Active   3m54s <----


root@devsecops-cloud:~/istio-1.24.0# kubectl -n istio-system get all
NAME                                        READY   STATUS    RESTARTS   AGE
pod/grafana-7c69b5ff87-wxwvf                1/1     Running   0          12m
pod/istio-egressgateway-568ccc69d8-8x6h9    1/1     Running   0          13m
pod/istio-ingressgateway-64fc6d787b-pxzbc   1/1     Running   0          13m
pod/istiod-cdfc8b464-rhgw2                  1/1     Running   0          13m
pod/jaeger-66f9675c7b-t7l6b                 1/1     Running   0          12m
pod/kiali-665944f699-flmz8                  1/1     Running   0          12m
pod/loki-0                                  0/2     Pending   0          12m
pod/prometheus-f754dc469-v7fqm              2/2     Running   0          12m

NAME                           TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)                                                                      AGE
service/grafana                ClusterIP      10.103.246.111   <none>        3000/TCP                                                                     12m
service/istio-egressgateway    ClusterIP      10.107.125.155   <none>        80/TCP,443/TCP                                                               13m
service/istio-ingressgateway   LoadBalancer   10.103.97.101    <pending>     15021:30376/TCP,80:30225/TCP,443:30701/TCP,31400:32394/TCP,15443:30557/TCP   13m
service/istiod                 ClusterIP      10.96.33.53      <none>        15010/TCP,15012/TCP,443/TCP,15014/TCP                                        13m
service/jaeger-collector       ClusterIP      10.111.134.22    <none>        14268/TCP,14250/TCP,9411/TCP,4317/TCP,4318/TCP                               12m
service/kiali                  ClusterIP      10.99.1.40       <none>        20001/TCP,9090/TCP                                                           12m
service/loki                   ClusterIP      10.111.19.226    <none>        3100/TCP,9095/TCP                                                            12m
service/loki-headless          ClusterIP      None             <none>        3100/TCP                                                                     12m
service/loki-memberlist        ClusterIP      None             <none>        7946/TCP                                                                     12m
service/prometheus             ClusterIP      10.99.27.64      <none>        9090/TCP                                                                     12m
service/tracing                ClusterIP      10.108.6.9       <none>        80/TCP,16685/TCP                                                             12m
service/zipkin                 ClusterIP      10.110.25.110    <none>        9411/TCP                                                                     12m

NAME                                   READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/grafana                1/1     1            1           12m
deployment.apps/istio-egressgateway    1/1     1            1           13m
deployment.apps/istio-ingressgateway   1/1     1            1           13m
deployment.apps/istiod                 1/1     1            1           13m
deployment.apps/jaeger                 1/1     1            1           12m
deployment.apps/kiali                  1/1     1            1           12m
deployment.apps/prometheus             1/1     1            1           12m

NAME                                              DESIRED   CURRENT   READY   AGE
replicaset.apps/grafana-7c69b5ff87                1         1         1       12m
replicaset.apps/istio-egressgateway-568ccc69d8    1         1         1       13m
replicaset.apps/istio-ingressgateway-64fc6d787b   1         1         1       13m
replicaset.apps/istiod-cdfc8b464                  1         1         1       13m
replicaset.apps/jaeger-66f9675c7b                 1         1         1       12m
replicaset.apps/kiali-665944f699                  1         1         1       12m
replicaset.apps/prometheus-f754dc469              1         1         1       12m

NAME                    READY   AGE
statefulset.apps/loki   0/1     12m

- edit kiali svc type to NodePort
- http://devsecops-demo.germanywestcentral.cloudapp.azure.com:31900/kiali/console/overview?duration=60&refresh=60000

## Sidecar Container can be injected in 2 ways

### Manual Injection
kubectl apply -f <istioctl kube-inject -f movies.yaml>

### Automatic Injection
kubectl label namespace <name> istio-injection=enabled
kubectl apply -f movies.yaml
No need to run istioctl or do anything with your yaml


## Prometheus - AlertManager

https://prometheus.io/docs/alerting/latest/alertmanager/

The Alertmanager handles alerts sent by client applications such as the Prometheus server.

wget https://github.com/prometheus/alertmanager/releases/download/v0.28.0-rc.0/alertmanager-0.28.0-rc.0.linux-amd64.tar.gz
tar -xvzf alertmanager-0.28.0-rc.0.linux-amd64.tar.gz
devsecops@devsecops-cloud:~$ cd alertmanager-0.28.0-rc.0.linux-amd64/
devsecops@devsecops-cloud:~/alertmanager-0.28.0-rc.0.linux-amd64$ cat alertmanager.yml
devsecops@devsecops-cloud:~/alertmanager-0.28.0-rc.0.linux-amd64$ ./alertmanager
ts=2024-12-14T17:42:03.494Z caller=tls_config.go:313 level=info msg="Listening on" address=[::]:9093
ts=2024-12-14T17:42:03.494Z caller=tls_config.go:316 level=info msg="TLS is disabled." http2=false address=[::]:9093

http://devsecops-demo.germanywestcentral.cloudapp.azure.com:9093/#/alerts
http://devsecops-demo.germanywestcentral.cloudapp.azure.com:9093/#/status

https://prometheus.io/docs/alerting/latest/configuration/#slack_config

- On slack, create channel 'Prometheus
  use this webhook url in alertmanager.yml https://hooks.slack.com/services/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

then reload the configuration : curl -XPOST localhost:9093/-/reload

root@devsecops-cloud:~# kubectl -n istio-system edit cm prometheus
Add this alerting section from prometheus_cm_alerting_section.yml, like so..
Also add, alert-rules from https://samber.github.io/awesome-prometheus-alerts/
https://samber.github.io/awesome-prometheus-alerts/rules#istio
https://www.bairesdev.com/tools/json2yaml/ - convert yaml to json



![img_2.png](img_2.png)






