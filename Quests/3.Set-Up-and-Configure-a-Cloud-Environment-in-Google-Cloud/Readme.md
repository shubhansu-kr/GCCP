# Quests

## 3.Set-Up-and-Configure-a-Cloud-Environment-in-Google-Cloud

#### [3.2.Introduction-to-SQL-for-BigQuery-and-Cloud-SQL]
```
curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

export BUCKET_NAME=$(gcloud info --format='value(config.project)')
gsutil mb gs://$BUCKET_NAME/
completed "Task 1"

wget --output-document start_station_data.csv https://storage.googleapis.com/cloud-training/gsp315/map.jpg
wget --output-document end_station_data.csv https://storage.googleapis.com/cloud-training/gsp315/map.jpg
gsutil cp start_station_data.csv gs://$BUCKET_NAME
gsutil cp end_station_data.csv gs://$BUCKET_NAME
completed "Task 2"
gcloud sql instances create qwiklabs-demo --database-version=MYSQL_5_7 --region=us-central1 --root-password=password
completed "Task 3"

echo "${BOLD}${YELLOW}type ${CYAN}password${YELLOW} as password when asked and run this inside SQL instance:
${BG_RED}
CREATE DATABASE bike;
exit
${RESET}" 

gcloud sql connect  qwiklabs-demo --user=root

completed "Task 4"

completed "Lab"

remove_files
```
#### [3.3.Multiple-VPC-Networks]
```
curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

export PROJECT=$(gcloud info --format='value(config.project)')

warning "${RESET}${YELLOW}Enter below details carefully from the lab page "

read -p "${BOLD}${YELLOW}Enter Region${RESET}${YELLOW}(managementsubnet-us) : ${RESET}" REGION1
read -p "${BOLD}${YELLOW}Enter Region${RESET}${YELLOW}(privatesubnet-us)    : ${RESET}" REGION2
read -p "${BOLD}${YELLOW}Enter Region${RESET}${YELLOW}(privatesubnet-eu)    : ${RESET}" REGION3
read -p "${BOLD}${YELLOW}Enter Zone${RESET}${YELLOW}(managementnet-us-vm)   : ${RESET}" ZONE1
read -p "${BOLD}${YELLOW}Enter Zone${RESET}${YELLOW}(privatenet-us-vm)      : ${RESET}" ZONE2
read -p "${BOLD}${YELLOW}Enter Zone${RESET}${YELLOW}(vm-appliance)          : ${RESET}" ZONE3
echo " "
echo "${BOLD}${YELLOW}Region${RESET}${YELLOW}(managementsubnet-us) :${BOLD}${CYAN} $REGION1"
echo "${BOLD}${YELLOW}Region${RESET}${YELLOW}(privatesubnet-us)    :${BOLD}${CYAN} $REGION2"
echo "${BOLD}${YELLOW}Region${RESET}${YELLOW}(privatesubnet-eu)    :${BOLD}${CYAN} $REGION3"
echo "${BOLD}${YELLOW}Zone${RESET}${YELLOW}(managementnet-us-vm)   :${BOLD}${CYAN} $ZONE1"
echo "${BOLD}${YELLOW}Zone${RESET}${YELLOW}(privatenet-us-vm)      :${BOLD}${CYAN} $ZONE2"
echo "${BOLD}${YELLOW}Zone${RESET}${YELLOW}(vm-appliance)          :${BOLD}${CYAN} $ZONE3"
echo " "
read -p "${BOLD}${YELLOW}Verify all details are correct? [ y/n ] : ${RESET}" VERIFY_DETAILS

while [ $VERIFY_DETAILS != 'y' ];
do echo " " && 
read -p "${BOLD}${YELLOW}Enter Region${RESET}${YELLOW}(managementsubnet-us) : ${RESET}" REGION1 && 
read -p "${BOLD}${YELLOW}Enter Region${RESET}${YELLOW}(privatesubnet-us)    : ${RESET}" REGION2 && 
read -p "${BOLD}${YELLOW}Enter Region${RESET}${YELLOW}(privatesubnet-eu)    : ${RESET}" REGION3 && 
read -p "${BOLD}${YELLOW}Enter Zone${RESET}${YELLOW}(managementnet-us-vm)   : ${RESET}" ZONE1 && 
read -p "${BOLD}${YELLOW}Enter Zone${RESET}${YELLOW}(privatenet-us-vm)      : ${RESET}" ZONE2 && 
read -p "${BOLD}${YELLOW}Enter Zone${RESET}${YELLOW}(vm-appliance)          : ${RESET}" ZONE3 && 
echo " " &&
echo "${BOLD}${YELLOW}Region${RESET}${YELLOW}(managementsubnet-us) :${BOLD}${CYAN} $REGION1" && 
echo "${BOLD}${YELLOW}Region${RESET}${YELLOW}(privatesubnet-us)    :${BOLD}${CYAN} $REGION2" && 
echo "${BOLD}${YELLOW}Region${RESET}${YELLOW}(privatesubnet-eu)    :${BOLD}${CYAN} $REGION3" && 
echo "${BOLD}${YELLOW}Zone${RESET}${YELLOW}(managementnet-us-vm)   :${BOLD}${CYAN} $ZONE1" && 
echo "${BOLD}${YELLOW}Zone${RESET}${YELLOW}(privatenet-us-vm)      :${BOLD}${CYAN} $ZONE2" && 
echo "${BOLD}${YELLOW}Zone${RESET}${YELLOW}(vm-appliance)          :${BOLD}${CYAN} $ZONE3" &&
echo " " &&
read -p "${BOLD}${YELLOW}Verify all details are correct? [ y/n ] : ${RESET}" VERIFY_DETAILS;
done


gcloud compute networks create managementnet  --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional 
gcloud compute networks subnets create managementsubnet-us --network=managementnet --region=$REGION1 --range=10.130.0.0/20 

completed "Task 1"

gcloud compute networks create privatenet --subnet-mode=custom
gcloud compute networks subnets create privatesubnet-us --network=privatenet --region=$REGION2 --range=172.16.0.0/24
gcloud compute networks subnets create privatesubnet-eu --network=privatenet --region=$REGION3 --range=172.20.0.0/20

completed "Task 2"
gcloud compute firewall-rules create managementnet-allow-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=managementnet --action=ALLOW --rules=icmp,tcp:22,tcp:3389 --source-ranges=0.0.0.0/0

completed "Task 3"
gcloud compute firewall-rules create privatenet-allow-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=privatenet --action=ALLOW --rules=icmp,tcp:22,tcp:3389 --source-ranges=0.0.0.0/0

completed "Task 4"

gcloud compute instances create managementnet-us-vm --zone=$ZONE1 --machine-type=e2-micro --subnet=managementsubnet-us

completed "Task 5"
gcloud compute instances create privatenet-us-vm --zone=$ZONE2 --machine-type=e2-micro --subnet=privatesubnet-us

completed "Task 6"

gcloud compute instances create vm-appliance --zone=$ZONE3 --machine-type=e2-standard-4 --network-interface=network-tier=PREMIUM,subnet=managementsubnet-us --network-interface=network-tier=PREMIUM,subnet=privatesubnet-us --network-interface=network-tier=PREMIUM,subnet=mynetwork --maintenance-policy=MIGRATE --create-disk=auto-delete=yes,boot=yes,device-name=vm-appliance,image=projects/debian-cloud/global/images/debian-10-buster-v20210916,mode=rw,size=10,type=projects/$PROJECT/zones/us-central1-f/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any

completed "Task 7"

completed "Lab"

remove_files 
```

#### [3.4.Cloud-Monitoring-Qwik-Start]
```
curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh


gcloud config set compute/zone us-central1-a
export PROJECT_ID=$(gcloud info --format='value(config.project)')

gsutil mb gs://$PROJECT_ID/

echo '#!/bin/bash
sudo apt update
sudo apt install apache2 php7.0 -y
sudo service apache2 restart
curl -sSO https://dl.google.com/cloudagents/add-monitoring-agent-repo.sh
sudo bash add-monitoring-agent-repo.sh
sudo apt update
sudo apt install stackdriver-agent -y
curl -sSO https://dl.google.com/cloudagents/add-logging-agent-repo.sh
sudo bash add-logging-agent-repo.sh
sudo apt update
sudo apt install google-fluentd' > startup_script.sh

gsutil  cp startup_script.sh gs://$PROJECT_ID

gcloud compute instances create lamp-1-vm \
    --machine-type=n1-standard-2 \
	--zone=us-central1-a \
	--metadata=startup-script-url=gs://$PROJECT_ID/startup_script.sh \
	--create-disk=auto-delete=yes,boot=yes,device-name=lamp-1-vm,image=projects/debian-cloud/global/images/debian-10-buster-v20220621,mode=rw,size=10,type=projects/$PROJECT_ID/zones/us-central1-a/diskTypes/pd-balanced --no-shielded-secure-boot

completed "Task 1"

warning "Wait for Apache2 HTTP server to install"


echo "${BOLD}${YELLOW}

Now, stop gcelab instance and edit the instance to allow http traffic.
Then, Allow http trafic in lamp-1-vm and click save -${CYAN} https://console.cloud.google.com/compute/instancesEdit/zones/us-central1-a/instances/lamp-1-vm?project=$PROJECT_ID 

Restart the instance.

${YELLOW}
Now create Uptime check -${CYAN} https://console.cloud.google.com/monitoring/uptime?project=$PROJECT_ID
 ${RESET}"
 
 echo "${BOLD}${CYAN}
   Title: Lamp Uptime Check
 
   Protocol: HTTP
 
   Resource Type: Instance
 
   Applies to: Single, lamp-1-vm
   
   Path: leave at default
   
   Check Frequency: 1 min
   
   Click on Next.click Test .Click Create.
${RESET}"

echo "${BOLD}${YELLOW}
Now create alerting policy -${CYAN} https://console.cloud.google.com/monitoring/alerting/policies/create?project=$PROJECT_ID
${RESET}"

 echo "${BOLD}${CYAN}
 
 - Click on Select a metric dropdown
 - Type Network traffic 
 - Select Network traffic (agent.googleapis.com/interface/traffic) and click Apply
 - Click Next.
 - Set the Threshold position to Above threshold, 
           Threshold value to 500 and 
		   Advanced Options > Retest window to 1 min
 - Click Next.
 - Configure Notification channels
 - Mention the Alert name as Inbound Traffic Alert.
 - Click Next.
 - Review the alert and click Create Policy
 
 
${RESET}"
  

completed "Lab"

remove_files

```

#### [3.5.Managing-Deployments-Using-Kubernetes-Engine]
```
curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

echo " "
read -p "${BOLD}${YELLOW}Enter Zone : ${RESET}" ZONE1
echo " "
echo "${BOLD}${YELLOW}Zone :${CYAN} $ZONE1"
echo " "
read -p "${BOLD}${YELLOW}Verify all details are correct? [ y/n ] : ${RESET}" VERIFY_DETAILS

while [ $VERIFY_DETAILS != 'y' ];
do echo " " && 
read -p "${BOLD}${YELLOW}Enter Zone : ${RESET}" ZONE1 && 
echo " " &&
echo "${BOLD}${YELLOW}Zone :${CYAN} $ZONE1" &&
echo " " &&
read -p "${BOLD}${YELLOW}Verify all details are correct? [ y/n ] : ${RESET}" VERIFY_DETAILS;
done

gcloud config set compute/zone $ZONE1
gsutil -m cp -r gs://spls/gsp053/orchestrate-with-kubernetes .
cd orchestrate-with-kubernetes/kubernetes
gcloud container clusters create bootcamp  --machine-type e2-small --num-nodes 3 --scopes "https://www.googleapis.com/auth/projecthosting,storage-rw"
cat deployments/auth.yaml
sed -i "s/auth:2.0.0/auth:1.0.0/g" deployments/auth.yaml
cat deployments/auth.yaml
kubectl create -f deployments/auth.yaml
kubectl get deployments
kubectl get replicasets
sleep 40
kubectl get pods
kubectl create -f services/auth.yaml
kubectl create -f deployments/hello.yaml
kubectl create -f services/hello.yaml
kubectl create secret generic tls-certs --from-file tls/
kubectl create configmap nginx-frontend-conf --from-file=nginx/frontend.conf
kubectl create -f deployments/frontend.yaml
kubectl create -f services/frontend.yaml
kubectl get services frontend
FRONTEND_EXTERNAL_IP=`kubectl get services frontend-o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`
while [ $FRONTEND_EXTERNAL_IP = '<pending>' ];
do sleep 4 && export FRONTEND_EXTERNAL_IP=`kubectl get services frontend-o=jsonpath="{.status.loadBalancer.ingress[0].ip}"` && echo $FRONTEND_EXTERNAL_IP ;
done
kubectl get services frontend
curl -ks https://`kubectl get svc frontend -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`


completed "Task 1"


kubectl explain deployment.spec.replicas
kubectl scale deployment hello --replicas=5
kubectl get pods | grep hello- | wc -l
kubectl scale deployment hello --replicas=3
kubectl get pods | grep hello- | wc -l

sed -i "s/hello:1.0.0/hello:2.0.0/g" deployments/hello.yaml
cat deployments/hello.yaml
kubectl get replicaset
kubectl rollout history deployment/hello
kubectl rollout pause deployment/hello
kubectl rollout status deployment/hello
kubectl get pods -o jsonpath --template='{range .items[*]}{.metadata.name}{"\t"}{"\t"}{.spec.containers[0].image}{"\n"}{end}'
kubectl rollout resume deployment/hello
kubectl rollout status deployment/hello
kubectl rollout undo deployment/hello
kubectl rollout history deployment/hello
kubectl get pods -o jsonpath --template='{range .items[*]}{.metadata.name}{"\t"}{"\t"}{.spec.containers[0].image}{"\n"}{end}'

cat deployments/hello-canary.yaml
kubectl create -f deployments/hello-canary.yaml
kubectl get deployments

curl -ks https://`kubectl get svc frontend -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version
kubectl apply -f services/hello-blue.yaml
kubectl create -f deployments/hello-green.yaml
curl -ks https://`kubectl get svc frontend -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version
kubectl apply -f services/hello-green.yaml
curl -ks https://`kubectl get svc frontend -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version
kubectl apply -f services/hello-blue.yaml
curl -ks https://`kubectl get svc frontend -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version

completed "Task 2"

completed "Lab"

remove_files


```
#### [3.6.Set-Up-and-Configure-a-Cloud-Environment-in-Google-Cloud-Challenge-Lab]
```
curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

echo " "
read -p "${BOLD}${YELLOW}Enter Region : ${RESET}" REGION1
read -p "${BOLD}${YELLOW}Enter Zone   : ${RESET}" ZONE1
echo " "
echo "${BOLD}${YELLOW}Region :${BOLD}${CYAN} $REGION1"
echo "${BOLD}${YELLOW}Zone   :${CYAN} $ZONE1"
echo " "
read -p "${BOLD}${YELLOW}Verify all details are correct? [ y/n ] : ${RESET}" VERIFY_DETAILS

while [ $VERIFY_DETAILS != 'y' ];
do echo " " && 
read -p "${BOLD}${YELLOW}Enter Region : ${RESET}" REGION1 && 
read -p "${BOLD}${YELLOW}Enter Zone   : ${RESET}" ZONE1 && 
echo " " && 
echo "${BOLD}${YELLOW}Region :${BOLD}${CYAN} $REGION1" && 
echo "${BOLD}${YELLOW}Zone   :${CYAN} $ZONE1" && 
echo " " && 
read -p "${BOLD}${YELLOW}Verify all details are correct? [ y/n ] : ${RESET}" VERIFY_DETAILS ;
done


gcloud config set compute/region $REGION1
gcloud config set compute/zone $ZONE1

gcloud compute networks create griffin-dev-vpc --subnet-mode custom

gcloud compute networks subnets create griffin-dev-wp --network=griffin-dev-vpc --region $REGION1 --range=192.168.16.0/20

gcloud compute networks subnets create griffin-dev-mgmt --network=griffin-dev-vpc --region $REGION1 --range=192.168.32.0/20

completed "Task 1"

gsutil cp -r gs://cloud-training/gsp321/dm .

cd dm

sed -i s/SET_REGION/$REGION1/g prod-network.yaml

gcloud deployment-manager deployments create prod-network \
    --config=prod-network.yaml

cd ..

completed "Task 2"

gcloud compute instances create bastion --network-interface=network=griffin-dev-vpc,subnet=griffin-dev-mgmt  --network-interface=network=griffin-prod-vpc,subnet=griffin-prod-mgmt --tags=ssh --zone=$ZONE1

gcloud compute firewall-rules create fw-ssh-dev --source-ranges=0.0.0.0/0 --target-tags ssh --allow=tcp:22 --network=griffin-dev-vpc

gcloud compute firewall-rules create fw-ssh-prod --source-ranges=0.0.0.0/0 --target-tags ssh --allow=tcp:22 --network=griffin-prod-vpc

completed "Task 3"

gcloud sql instances create griffin-dev-db --root-password password --region=$REGION1

warning "use 'password' as password to connect SQL"
tput bold; tput setab 1 ;echo '
CREATE DATABASE wordpress;
CREATE USER "wp_user"@"%" IDENTIFIED BY "stormwind_rules";
GRANT ALL PRIVILEGES ON wordpress.* TO "wp_user"@"%";
FLUSH PRIVILEGES;
exit
'; tput sgr0;
gcloud sql connect griffin-dev-db

completed "Task 4"

gcloud container clusters create griffin-dev \
  --network griffin-dev-vpc \
  --subnetwork griffin-dev-wp \
  --machine-type n1-standard-4 \
  --num-nodes 2  \
  --zone $ZONE1


gcloud container clusters get-credentials griffin-dev --zone $ZONE1

cd ~/

gsutil cp -r gs://cloud-training/gsp321/wp-k8s .
completed "Task 5"


sed -i s/username_goes_here/wp_user/g wp-k8s/wp-env.yaml
sed -i s/password_goes_here/stormwind_rules/g wp-k8s/wp-env.yaml
cd wp-k8s
kubectl create -f wp-env.yaml
gcloud iam service-accounts keys create key.json --iam-account=cloud-sql-proxy@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com
kubectl create secret generic cloudsql-instance-credentials --from-file key.json
completed "Task 6"

sed -i s/YOUR_SQL_INSTANCE/griffin-dev-db/g wp-deployment.yaml
kubectl create -f wp-deployment.yaml
kubectl create -f wp-service.yaml
completed "Task 7"


WORDPRESS_EXTERNAL_IP=$(kubectl get services | grep wordpress | awk '{print $4}')

while [ $WORDPRESS_EXTERNAL_IP = '<pending>' ];
do sleep 4 && WORDPRESS_EXTERNAL_IP=$(kubectl get services | grep wordpress | awk '{print $4}') && echo $WORDPRESS_EXTERNAL_IP ;
done

echo "${BOLD}${BLUE}$WORDPRESS_EXTERNAL_IP${RESET}"

warning "${BOLD}${YELLOW} Create uptime check manually -${MAGENTA} https://console.cloud.google.com/monitoring/uptime?project=$PROJECT_ID 
${YELLOW}
	Title    :${MAGENTA} Wordpress-Uptime${YELLOW}
	Hostname :${MAGENTA} $WORDPRESS_EXTERNAL_IP${YELLOW}
	Path     :${MAGENTA} /${YELLOW}
	Click Next. Click Next. Click Create"
completed "Task 8"


PROJECT_ID=$(gcloud info --format='value(config.project)')
FIRSTUSER=$(gcloud config get-value core/account)
LASTUSER=$(gcloud projects get-iam-policy $PROJECT_ID | grep student | awk '{print $2}' | tail -1 | sed -e 's/user://gm;t;d')

if [ $FIRSTUSER = $LASTUSER ]
then
LASTUSER=$(gcloud projects get-iam-policy $PROJECT_ID | grep student | awk '{print $2}' | tail -2  | head -1 | sed -e 's/user://gm;t;d')
fi

if [ $FIRSTUSER = $LASTUSER ]
then
read -p "${YELLOW}${BOLD}Enter second Email Address : ${RESET}" LASTUSER
echo $LASTUSER
fi

echo "${BOLD}${YELLOW}
Your second Email ID =${CYAN} $LASTUSER 
${RESET}"

gcloud projects add-iam-policy-binding $PROJECT_ID --role='roles/editor' --member user:$LASTUSER
completed "Task 9"

completed "Lab"

remove_files 
```
