curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

gcloud services enable compute.googleapis.com

echo "${BOLD}Visit ${CYAN}https://console.cloud.google.com/marketplace/vm/config/bitnami-launchpad/lampstack?project=$GOOGLE_CLOUD_PROJECT
 ${YELLOW}and perform manually:-

 - select Zone as instructed on lab page
 - accept Terms
 - click deploy


${RESET}"

completed "Lab"

remove_files