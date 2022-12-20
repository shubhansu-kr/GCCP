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

echo "${BOLD}${YELLOW}type ${RED}password${YELLOW} as password when asked and run this inside SQL instance:
${BG_RED}
CREATE DATABASE bike;
exit
${RESET}" 

gcloud sql connect  qwiklabs-demo --user=root

completed "Task 4"

completed "Lab"

remove_files