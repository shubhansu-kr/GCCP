export PROJECT=$GOOGLE_CLOUD_PROJECT

curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

echo " "
read -p "${BOLD}${YELLOW}Enter Zone : ${RESET}" ZONE
echo "${BOLD} "
echo "${YELLOW}zone : ${CYAN}$ZONE  "
echo " "

read -p "${BOLD}${YELLOW}Verify all details are correct? [ y/n ] : ${RESET}" VERIFY_DETAILS

while [ $VERIFY_DETAILS != 'y' ];
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