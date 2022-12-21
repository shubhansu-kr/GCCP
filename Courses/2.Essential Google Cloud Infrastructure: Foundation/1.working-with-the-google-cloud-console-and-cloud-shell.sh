curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

export BUCKET_NAME=$(gcloud info --format='value(config.project)')

warning "visit ${CYAN}https://console.cloud.google.com/storage/create-bucket?project=$GOOGLE_CLOUD_PROJECT ${YELLOW} and create buckets manually

- Provide some unique name (like:${BLUE}$BUCKET_NAME-2)
- Click Create"

gsutil mb gs://$BUCKET_NAME 
completed "Task 2"

touch sample.txt
gsutil cp sample.txt gs://$BUCKET_NAME
completed "Task 3"

warning "Perform Task 1 manually"

completed "Lab"

remove_files