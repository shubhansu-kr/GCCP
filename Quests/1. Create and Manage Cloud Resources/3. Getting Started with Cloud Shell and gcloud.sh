export PROJECT=$GOOGLE_CLOUD_PROJECT

curl -o default.sh https://raw.githubusercontent.com/user9-21/GCRF/main/files/default.sh
source default.sh


echo " "
read -p "${BOLD}${YELLOW}Enter Region : ${RESET}" REGION_NAME
read -p "${BOLD}${YELLOW}Enter Zone : ${RESET}" ZONE
echo "${BOLD} "
echo "${YELLOW}Region : ${CYAN}$REGION_NAME  "
echo "${YELLOW}zone : ${CYAN}$ZONE  "
echo " "

read -p "${BOLD}${YELLOW}Verify all details are correct? [ y/n ] : ${RESET}" VERIFY_DETAILS


while [ $VERIFY_DETAILS != 'y' ];
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