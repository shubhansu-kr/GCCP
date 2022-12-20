curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

export my_zone=us-central1-a
export my_cluster=standard-cluster-1
source <(kubectl completion bash)
gcloud container clusters get-credentials $my_cluster --zone $my_zone
git clone https://github.com/GoogleCloudPlatform/training-data-analyst
ln -s ~/training-data-analyst/courses/ak8s/v1.1 ~/ak8s
cd ~/ak8s/Deployments/

cat > nginx-deployment.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.7.9
        ports:
        - containerPort: 80
EOF
kubectl apply -f ./nginx-deployment.yaml
kubectl get deployments
completed "Task 1"

kubectl scale --replicas=1 deployment nginx-deployment
kubectl get deployments
kubectl scale --replicas=3 deployment nginx-deployment
kubectl get deployments
 
kubectl set image deployment.v1.apps/nginx-deployment nginx=nginx:1.9.1 --record
kubectl rollout status deployment.v1.apps/nginx-deployment
kubectl get deployments

completed "Task 2"


kubectl rollout history deployment nginx-deployment
kubectl rollout undo deployments nginx-deployment
kubectl rollout history deployment nginx-deployment
kubectl rollout history deployment/nginx-deployment --revision=3

cat > service-nginx.yaml <<EOF
apiVersion: v1
kind: Service
metadata:
  name: nginx
spec:
  type: LoadBalancer
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 60000
    targetPort: 80
EOF
kubectl apply -f ./service-nginx.yaml
kubectl get service nginx

warning "if error, visit ${CYAN}https://console.cloud.google.com/kubernetes/workload/deploy?project=$GOOGLE_CLOUD_PROJECT ${YELLOW} and DEPLOY Workloads manually"

completed "Task 3"

cat > nginx-canary.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-canary
  labels:
    app: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
        track: canary
        Version: 1.9.1
    spec:
      containers:
      - name: nginx
        image: nginx:1.9.1
        ports:
        - containerPort: 80
EOF
kubectl apply -f nginx-canary.yaml
kubectl get deployments
kubectl scale --replicas=0 deployment nginx-deployment
kubectl get deployments


completed "Task 3"

completed "Lab"

remove_files