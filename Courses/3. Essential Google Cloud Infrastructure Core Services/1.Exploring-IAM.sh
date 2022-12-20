curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

export BUCKET_NAME=$(gcloud info --format='value(config.project)')
gsutil mb gs://$BUCKET_NAME/
touch sample.txt
gsutil cp sample.txt gs://$BUCKET_NAME

completed "Task 1"

export PROJECT_ID=$(gcloud info --format='value(config.project)')

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

warning "Your second Email ID =${CYAN} $LASTUSER"
gcloud projects remove-iam-policy-binding $PROJECT_ID --role='roles/viewer' --member user:$LASTUSER

completed "Task 2"

gcloud projects add-iam-policy-binding $PROJECT_ID --role='roles/storage.objectViewer' --member user:$LASTUSER


completed "Task 3"

gcloud iam service-accounts create read-bucket-objects 
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:read-bucket-objects@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/storage.objectViewer"


gcloud iam service-accounts add-iam-policy-binding \
    read-bucket-objects@$PROJECT_ID.iam.gserviceaccount.com \
    --member="domain:altostrat.com" \
    --role="roles/iam.serviceAccountUser"

gcloud iam service-accounts keys create sa-read-bucket-objects.json \
    --iam-account=read-bucket-objects@$PROJECT_ID.iam.gserviceaccount.com

gcloud projects add-iam-policy-binding $PROJECT_ID --role='roles/compute.instanceAdmin.v1' --member "domain:altostrat.com"

while [[ $VERIFY_DETAILS != 'y' ]];
do echo " " && 
read -p "${BOLD}${YELLOW}Enter Zone : ${RESET}" ZONE && 
echo "${BOLD} " && 
echo "${YELLOW}Zone : ${CYAN}$ZONE  " && 
echo " " && 
read -p "${BOLD}${YELLOW}Verify all details are correct? [ y/n ] : ${RESET}" VERIFY_DETAILS;
done

gcloud compute instances create demoiam --machine-type=e2-micro  --zone=$ZONE --service-account="read-bucket-objects@$PROJECT_ID.iam.gserviceaccount.com"

completed "Task 4"

completed "Lab"

remove_files