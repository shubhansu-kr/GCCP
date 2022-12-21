curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

export PROJECT_ID=$(gcloud info --format='value(config.project)')
echo "${YELLOW}${BOLD}

visit ${CYAN}https://console.cloud.google.com/sql/instances/create?project=$PROJECT_ID ${YELLOW} and perform manually"

sleep 100

while [[ $STATE != 'RUNNABLE' ]];
do  echo "State -> $STATE" && sleep 10 && STATE=`gcloud sql instances list --filter="NAME: wordpress-db" --format="value(STATUS)"` ;
done

echo "${YELLOW}${BOLD} visit ${CYAN}https://console.cloud.google.com/sql/instances/wordpress-db/databases?project=$PROJECT_ID ${YELLOW} and create database ${RED}wordpress"

PROJECT_NUMBER=`gcloud projects describe $PROJECT_ID --format="value(projectNumber)"`

INSTANCE_NAME=`gcloud sql instances describe wordpress-db --format="value(connectionName)"`

echo "${YELLOW}${BOLD}

visit ${BLUE}https://ssh.cloud.google.com/v2/ssh/projects/$PROJECT_ID/zones/us-central1-f/instances/wordpress-proxy?authuser=0&hl=en_US&projectNumber=$PROJECT_NUMBER&useAdminProxy=true&troubleshoot4005Enabled=true&troubleshoot255Enabled=true ${YELLOW} and run below code


${MAGENTA}
wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy && chmod +x cloud_sql_proxy
./cloud_sql_proxy -instances=$INSTANCE_NAME=tcp:3306 &
"

completed "Lab"

remove_files 