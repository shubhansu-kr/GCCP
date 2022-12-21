export PROJECT=$GOOGLE_CLOUD_PROJECT

curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

while [[ $VERIFY_DETAILS != 'y' ]];
do echo " " && 
read -p "${BOLD}${YELLOW}Enter Region name   : ${RESET}" REGION_NAME && 
read -p "${BOLD}${YELLOW}Enter zone : ${RESET}" ZONE && 
echo "${BOLD} " && 
echo "${YELLOW}Region : ${CYAN}$REGION_NAME  " && 
echo "${YELLOW}zone : ${CYAN}$ZONE  " && 
echo " " && 
read -p "${BOLD}${YELLOW}Verify all details are correct? [ y/n ] : ${RESET}" VERIFY_DETAILS;
done

gcloud config set compute/zone us-central1-a
gcloud container clusters create my-cluster
gcloud container clusters get-credentials my-cluster
kubectl create deployment hello-server --image=gcr.io/google-samples/hello-app:1.0
kubectl expose deployment hello-server --type=LoadBalancer --port 8080
kubectl get service

gcloud container clusters delete my-cluster
