curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

warning "visit ${CYAN}https://console.cloud.google.com/marketplace/vm/config/bitnami-launchpad/jenkins?project=$GOOGLE_CLOUD_PROJECT ${YELLOW} and deploy jenkins manually


- Aceept Terms
- Click Deploy"

completed "Lab"

remove_files