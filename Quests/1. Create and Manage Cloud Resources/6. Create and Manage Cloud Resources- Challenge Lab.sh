export PROJECT=$GOOGLE_CLOUD_PROJECT

curl -o default.sh https://raw.githubusercontent.com/user9-21/GCRF/main/files/default.sh
source default.sh

echo " "
read -p "${BOLD}${YELLOW}Enter Instance Name : ${RESET}" INSTANCE_NAME
read -p "${BOLD}${YELLOW}Enter Region : ${RESET}" REGION_NAME
read -p "${BOLD}${YELLOW}Enter Zone : ${RESET}" ZONE
read -p "${BOLD}${YELLOW}Enter Port : ${RESET}" PORT
read -p "${BOLD}${YELLOW}Enter Firewall : ${RESET}" FIREWALL
echo "${BOLD} "
echo "${YELLOW}Instance Name : ${CYAN}$INSTANCE_NAME  "
echo "${YELLOW}Region : ${CYAN}$REGION_NAME  "
echo "${YELLOW}zone : ${CYAN}$ZONE  "
echo "${YELLOW}Port : ${CYAN}$PORT  "
echo "${YELLOW}Firewall : ${CYAN}$FIREWALL  "
echo " "

read -p "${BOLD}${YELLOW}Verify all details are correct? [ y/n ] : ${RESET}" VERIFY_DETAILS

while [ $VERIFY_DETAILS != 'y' ];
do echo " " && 
read -p "${BOLD}${YELLOW}Enter Instance Name   : ${RESET}" INSTANCE_NAME && 
read -p "${BOLD}${YELLOW}Enter Region name   : ${RESET}" REGION_NAME && 
read -p "${BOLD}${YELLOW}Enter zone : ${RESET}" ZONE && 
read -p "${BOLD}${YELLOW}Enter Port   : ${RESET}" PORT && 
read -p "${BOLD}${YELLOW}Enter Firewall   : ${RESET}" FIREWALL && 
echo "${BOLD} " && 
echo "${YELLOW}Instance Name : ${CYAN}$INSTANCE_NAME  " && 
echo "${YELLOW}Region : ${CYAN}$REGION_NAME  " && 
echo "${YELLOW}zone : ${CYAN}$ZONE  " && 
echo "${YELLOW}Port : ${CYAN}$PORT  " && 
echo "${YELLOW}Firewall : ${CYAN}$FIREWALL  " && 
echo " " && 
read -p "${BOLD}${YELLOW}Verify all details are correct? [ y/n ] : ${RESET}" VERIFY_DETAILS;
done


gcloud config set compute/region $REGION_NAME
gcloud config set compute/zone $ZONE

gcloud compute instances create $INSTANCE_NAME \
          --network nucleus-vpc \
          --zone $ZONE  \
          --machine-type f1-micro  \
          --image-family debian-11  \
          --image-project debian-cloud 

gcloud container clusters create --machine-type=n1-standard-1 --zone=$ZONE lab-cluster 
gcloud container clusters get-credentials lab-cluster 
kubectl create deployment hello-server --image=gcr.io/google-samples/hello-app:2.0
kubectl expose deployment hello-server --type=LoadBalancer --port $PORT



gcloud container clusters create nucleus-backend \
          --num-nodes 1 \
          --network nucleus-vpc \
          --region $REGION_NAME
gcloud container clusters get-credentials nucleus-backend \
          --region $REGION_NAME
kubectl create deployment hello-server \
          --image=gcr.io/google-samples/hello-app:2.0
kubectl expose deployment hello-server \
          --type=LoadBalancer \
          --port $PORT

cat << EOF > startup.sh
#! /bin/bash
apt-get update
apt-get install -y nginx
service nginx start
sed -i -- 's/nginx/Google Cloud Platform - '"\$HOSTNAME"'/' /var/www/html/index.nginx-debian.html
EOF

gcloud compute instance-templates create web-server-template \
          --metadata-from-file startup-script=startup.sh \
          --network nucleus-vpc \
          --machine-type g1-small \
          --region $REGION_NAME
gcloud compute instance-groups managed create web-server-group \
          --base-instance-name web-server \
          --size 2 \
          --template web-server-template \
          --region $REGION_NAME
gcloud compute firewall-rules create $FIREWALL \
          --allow tcp:80 \
          --network nucleus-vpc
gcloud compute http-health-checks create http-basic-check
gcloud compute instance-groups managed \
          set-named-ports web-server-group \
          --named-ports http:80 \
          --region $REGION_NAME
gcloud compute backend-services create web-server-backend \
          --protocol HTTP \
          --http-health-checks http-basic-check \
          --global
gcloud compute backend-services add-backend web-server-backend \
          --instance-group web-server-group \
          --instance-group-region $REGION_NAME \
          --global
gcloud compute url-maps create web-server-map \
          --default-service web-server-backend
gcloud compute target-http-proxies create http-lb-proxy \
          --url-map web-server-map
gcloud compute forwarding-rules create http-content-rule \
        --global \
        --target-http-proxy http-lb-proxy \
        --ports 80
gcloud compute forwarding-rules list
gcloud compute forwarding-rules describe http-content-rule  --global
gcloud compute forwarding-rules describe http-content-rule --global --format='get(IPAddress)'
export IP_ADDRESS=$(gcloud compute forwarding-rules describe http-content-rule --global --format='value(IPAddress)')
echo $IP_ADDRESS
while true; do curl -m1 $IP_ADDRESS; done

