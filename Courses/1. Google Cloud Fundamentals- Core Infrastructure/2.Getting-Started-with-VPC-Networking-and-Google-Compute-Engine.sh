curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

export PROJECT_ID=$(gcloud info --format='value(config.project)')

#!/bin/bash
for name in  $(gcloud compute firewall-rules list --format="value(NAME)")
do
  echo "Firewall-rules:  $name"
  gcloud compute firewall-rules delete $name --quiet
  echo "    -> Deleted $name"
done

export PROJECT_ID=$(gcloud info --format='value(config.project)')

gcloud compute networks create mynetwork --subnet-mode=auto --mtu=1460 --bgp-routing-mode=regional

gcloud compute firewall-rules create mynetwork-allow-custom --network=projects/$PROJECT_ID/global/networks/mynetwork --description=Allows\ connection\ from\ any\ source\ to\ any\ instance\ on\ the\ network\ using\ custom\ protocols. --direction=INGRESS --priority=65534 --source-ranges=10.128.0.0/9 --action=ALLOW --rules=all

gcloud compute firewall-rules create mynetwork-allow-icmp --network=projects/$PROJECT_ID/global/networks/mynetwork --description=Allows\ ICMP\ connections\ from\ any\ source\ to\ any\ instance\ on\ the\ network. --direction=INGRESS --priority=65534 --source-ranges=0.0.0.0/0 --action=ALLOW --rules=icmp


gcloud compute firewall-rules create mynetwork-allow-rdp --network=projects/$PROJECT_ID/global/networks/mynetwork --description=Allows\ RDP\ connections\ from\ any\ source\ to\ any\ instance\ on\ the\ network\ using\ port\ 3389. --direction=INGRESS --priority=65534 --source-ranges=0.0.0.0/0 --action=ALLOW --rules=tcp:3389

gcloud compute firewall-rules create mynetwork-allow-ssh --network=projects/$PROJECT_ID/global/networks/mynetwork --description=Allows\ TCP\ connections\ from\ any\ source\ to\ any\ instance\ on\ the\ network\ using\ port\ 22. --direction=INGRESS --priority=65534 --source-ranges=0.0.0.0/0 --action=ALLOW --rules=tcp:22


while [[ $VERIFY_DETAILS != 'y' ]];
do echo " " && 
read -p "${BOLD}${YELLOW}Enter zone : ${RESET}" ZONE && 
echo "${BOLD} " && 
echo "${YELLOW}zone : ${CYAN}$ZONE  " && 
echo " " && 
read -p "${BOLD}${YELLOW}Verify all details are correct? [ y/n ] : ${RESET}" VERIFY_DETAILS;
done

gcloud compute instances create	mynet-us-vm --machine-type e2-micro --zone $ZONE --network-interface=network-tier=PREMIUM,subnet=mynetwork
gcloud compute instances create	mynet-eu-vm --machine-type e2-micro --zone europe-central2-a --network-interface=network-tier=PREMIUM,subnet=mynetwork

completed "Lab"

remove_files