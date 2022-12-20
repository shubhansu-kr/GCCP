curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

gcloud services enable container.googleapis.com
gcloud services enable containerregistry.googleapis.com

while [[ $VERIFY_DETAILS != 'y' ]];
do echo " " && 
read -p "${BOLD}${YELLOW}Enter Region : ${RESET}" REGION && 
read -p "${BOLD}${YELLOW}Enter Zone : ${RESET}" ZONE && 
echo "${BOLD} " && 
echo "${YELLOW}Region : ${CYAN}$REGION  " && 
echo "${YELLOW}Zone : ${CYAN}$ZONE  " && 
echo " " && 
read -p "${BOLD}${YELLOW}Verify all details are correct? [ y/n ] : ${RESET}" VERIFY_DETAILS;
done

gcloud container clusters create webfrontend --zone $ZONE --num-nodes 2

kubectl version

completed "Task 1"

kubectl create deploy nginx --image=nginx:1.17.10
kubectl get pods
kubectl expose deployment nginx --port 80 --type LoadBalancer
kubectl get services
kubectl scale deployment nginx --replicas 3
kubectl get pods
kubectl get services


completed "Task 2"

completed "Lab"

remove_files