export PROJECT=$GOOGLE_CLOUD_PROJECT

curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

gcloud config set compute/zone us-east1-d
gcloud container clusters create --machine-type=e2-medium --zone=us-east1-d lab-cluster 
gcloud container clusters get-credentials lab-cluster 
kubectl create deployment hello-server --image=gcr.io/google-samples/hello-app:1.0
kubectl expose deployment hello-server --type=LoadBalancer --port 8080
kubectl get service
sleep 10
kubectl get service

gcloud container clusters delete lab-cluster 

