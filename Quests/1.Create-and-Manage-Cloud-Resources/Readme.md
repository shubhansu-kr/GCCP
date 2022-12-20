# Quests

## 1. Create and Manage Cloud Resources

#### [1.1. A Tour of Google Cloud Hands-on Labs]
```
gcloud services enable dialogflow.googleapis.com

```

#### [1.2.Creating a Virtual Machine]
```
export PROJECT=$GOOGLE_CLOUD_PROJECT

curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

while [[ $VERIFY_DETAILS != 'y' ]];
do echo " " && 
read -p "${BOLD}${YELLOW}Enter Instance name   : ${RESET}" REGION_NAME && 
read -p "${BOLD}${YELLOW}Enter zone : ${RESET}" ZONE && 
echo "${BOLD} " && 
echo "${YELLOW}zone : ${CYAN}$ZONE  " && 
echo " " && 
read -p "${BOLD}${YELLOW}Verify all details are correct? [ y/n ] : ${RESET}" VERIFY_DETAILS;
done

gcloud compute instances create gcelab --project=$PROJECT --zone=$ZONE --machine-type=e2-medium  --maintenance-policy=MIGRATE --create-disk=auto-delete=yes,boot=yes,device-name=gcelab,image=projects/debian-cloud/global/images/debian-10-buster-v20210916,mode=rw,size=10,type=projects/$PROJECT/zones/$ZONE/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any
gcloud compute instances create gcelab2 --machine-type e2-medium --zone $ZONE 
cat > laststep.sh <<EOF

# in ssh 
sudo apt-get install nginx -y
exit

# go to instance console. Click on gcelab
# if not allowed http traffic . click edit and check allow http traffic.
# browse external ip of gcelab and verify nginx is installed.
EOF
cat laststep.sh
gcloud compute ssh gcelab --zone=$ZONE 

```

#### [1.3.Getting Started with Cloud Shell and gcloud]
```
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

gcloud config set compute/region $REGION_NAME
gcloud config get-value compute/region
gcloud config set compute/zone $ZONE
gcloud config get-value compute/zone
gcloud config get-value project
gcloud compute project-info describe --project $(gcloud config get-value project)

export PROJECT_ID=$(gcloud config get-value project)
export ZONE=$(gcloud config get-value compute/zone)
echo -e "PROJECT ID: $PROJECT_ID\nZONE: $ZONE"

gcloud compute instances create gcelab2 --machine-type e2-medium --zone $ZONE

```

#### [1.4.Kubernetes Engine: Qwik Start]
```
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

gcloud config set compute/region $REGION_NAME
gcloud config get-value compute/region
gcloud config set compute/zone $ZONE
gcloud config get-value compute/zone
gcloud config get-value project
gcloud compute project-info describe --project $(gcloud config get-value project)

export PROJECT_ID=$(gcloud config get-value project)
export ZONE=$(gcloud config get-value compute/zone)
echo -e "PROJECT ID: $PROJECT_ID\nZONE: $ZONE"

gcloud compute instances create gcelab2 --machine-type e2-medium --zone $ZONE
```

#### [1.5.Set Up Network and HTTP Load Balancers]
```
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

gcloud config set compute/region $ZONE
gcloud config set compute/region $REGION_NAME
  gcloud compute instances create www1 \
    --zone=$ZONE \
    --tags=network-lb-tag \
    --machine-type=e2-small \
    --image-family=debian-11 \
    --image-project=debian-cloud \
    --metadata=startup-script='#!/bin/bash
      apt-get update
      apt-get install apache2 -y
      service apache2 restart
      echo "
<h3>Web Server: www1</h3>" | tee /var/www/html/index.html'

  gcloud compute instances create www2 \
    --zone=$ZONE \
    --tags=network-lb-tag \
    --machine-type=e2-small \
    --image-family=debian-11 \
    --image-project=debian-cloud \
    --metadata=startup-script='#!/bin/bash
      apt-get update
      apt-get install apache2 -y
      service apache2 restart
      echo "
<h3>Web Server: www2</h3>" | tee /var/www/html/index.html'

  gcloud compute instances create www3 \
    --zone=$ZONE \
    --tags=network-lb-tag \
    --machine-type=e2-small \
    --image-family=debian-11 \
    --image-project=debian-cloud \
    --metadata=startup-script='#!/bin/bash
      apt-get update
      apt-get install apache2 -y
      service apache2 restart
      echo "
<h3>Web Server: www3</h3>" | tee /var/www/html/index.html'

gcloud compute firewall-rules create www-firewall-network-lb \
    --target-tags network-lb-tag --allow tcp:80

gcloud compute instances list

gcloud compute addresses create network-lb-ip-1 \
    --region $REGION_NAME

gcloud compute http-health-checks create basic-check

gcloud compute target-pools create www-pool \
    --region $REGION_NAME --http-health-check basic-check

gcloud compute target-pools add-instances www-pool \
    --instances www1,www2,www3 --region $REGION_NAME 

gcloud compute forwarding-rules create www-rule \
    --region  $REGION_NAME \
    --ports 80 \
    --address network-lb-ip-1 \
    --target-pool www-pool

gcloud compute forwarding-rules describe www-rule --region $REGION_NAME

IPADDRESS=$(gcloud compute forwarding-rules describe www-rule --region $REGION_NAME --format="json" | jq -r .IPAddress)

echo $IPADDRESS

gcloud compute instance-templates create lb-backend-template \
   --region=$REGION_NAME \
   --network=default \
   --subnet=default \
   --tags=allow-health-check \
   --machine-type=e2-medium \
   --image-family=debian-11 \
   --image-project=debian-cloud \
   --metadata=startup-script='#!/bin/bash
     apt-get update
     apt-get install apache2 -y
     a2ensite default-ssl
     a2enmod ssl
     vm_hostname="$(curl -H "Metadata-Flavor:Google" \
     http://169.254.169.254/computeMetadata/v1/instance/name)"
     echo "Page served from: $vm_hostname" | \
     tee /var/www/html/index.html
     systemctl restart apache2'

gcloud compute instance-groups managed create lb-backend-group \
   --template=lb-backend-template --size=2 --zone=$ZONE 

gcloud compute firewall-rules create fw-allow-health-check \
  --network=default \
  --action=allow \
  --direction=ingress \
  --source-ranges=130.211.0.0/22,35.191.0.0/16 \
  --target-tags=allow-health-check \
  --rules=tcp:80

gcloud compute addresses create lb-ipv4-1 \
  --ip-version=IPV4 \
  --global

gcloud compute addresses describe lb-ipv4-1 \
  --format="get(address)" \
  --global

gcloud compute health-checks create http http-basic-check \
  --port 80

gcloud compute backend-services create web-backend-service \
  --protocol=HTTP \
  --port-name=http \
  --health-checks=http-basic-check \
  --global

gcloud compute backend-services add-backend web-backend-service \
  --instance-group=lb-backend-group \
  --instance-group-zone=$ZONE \
  --global

gcloud compute url-maps create web-map-http \
    --default-service web-backend-service

gcloud compute target-http-proxies create http-lb-proxy \
    --url-map web-map-http   

gcloud compute forwarding-rules create http-content-rule \
    --address=lb-ipv4-1\
    --global \
    --target-http-proxy=http-lb-proxy \
    --ports=80


```

#### [1.6.Create and Manage Cloud Resources: Challenge Lab]
```
export PROJECT=$GOOGLE_CLOUD_PROJECT

curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

while [[ $VERIFY_DETAILS != 'y' ]];
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

```
