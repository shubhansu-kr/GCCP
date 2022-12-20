curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

export PROJECT_ID=$(gcloud info --format='value(config.project)')

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

gcloud compute instances create bloghost --project=$PROJECT_ID --zone=$ZONE --machine-type=e2-medium --network-interface=network-tier=PREMIUM,subnet=default --metadata=startup-script=apt-get\ update$'\n'apt-get\ install\ apache2\ php\ php-mysql\ -y$'\n'service\ apache2\ restart,enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD  --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=http-server --create-disk=auto-delete=yes,boot=yes,device-name=bloghost,image=projects/debian-cloud/global/images/debian-11-bullseye-v20221206,mode=rw,size=10,type=projects/$PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any


completed "Task 1"

export LOCATION=US
gsutil mb -l $LOCATION gs://$DEVSHELL_PROJECT_ID
gsutil cp gs://cloud-training/gcpfci/my-excellent-blog.png my-excellent-blog.png
gsutil cp my-excellent-blog.png gs://$DEVSHELL_PROJECT_ID/my-excellent-blog.png
gsutil acl ch -u allUsers:R gs://$DEVSHELL_PROJECT_ID/my-excellent-blog.png

completed "Task 2"

gcloud sql instances create blog-db --database-version=MYSQL_5_7 --region=$REGION --root-password=password

gcloud sql users create blogdbuser \
--host=`gcloud sql instances list --format="value(PRIMARY_ADDRESS)"` \
--instance=blog-db \
--password=PASSWORD

EXTERNAL_IP=`gcloud compute instances list --format="value(EXTERNAL_IP)"`

gcloud sql instances patch blog-db \
--authorized-networks=$EXTERNAL_IP/32
completed "Task 3"

completed "Lab"

remove_files