curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

gcloud beta container clusters create "standard-cluster-1" --zone "us-central1-a"

completed "Task 1"

gcloud container clusters resize standard-cluster-1 --num-nodes 4 --zone=us-central1-a

#gcloud container clusters update standard-cluster-1 --zone us-central1-a

completed "Task 2"

kubectl create deployment standard-cluster-1 --image=nginx:latest
kubectl get pods -o wide
kubectl expose deployment standard-cluster-1 --type LoadBalancer --port 80 --target-port 80
kubectl get services

EXTERNAL_IP=`kubectl get svc standard-cluster-1 -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`
while [ $EXTERNAL_IP = '<pending>' ];
do sleep 4 && export EXTERNAL_IP=`kubectl get svc standard-cluster-1 -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"` && echo $EXTERNAL_IP ;
done

#curl -ks https://`kubectl get svc standard-cluster-1 -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`


warning "if error, visit ${CYAN}https://console.cloud.google.com/kubernetes?project=$GOOGLE_CLOUD_PROJECT ${YELLOW} and do it manually"

completed "Task 3"

completed "Lab"

remove_files