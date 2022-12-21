curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

export PROJECT_ID=$(gcloud info --format='value(config.project)')

for name in  $(gcloud compute firewall-rules list --format="value(NAME)")
do
  echo "${BOLD}${BLUE} Firewall-rules:  $name"
  gcloud compute firewall-rules delete $name --quiet
  echo "   ${RED} -> Deleted $name${RESET}"
done
gcloud compute networks delete default --quiet

gcloud compute networks create mynetwork --subnet-mode=auto --mtu=1460 --bgp-routing-mode=regional

gcloud compute firewall-rules create mynetwork-allow-custom --network=projects/$PROJECT_ID/global/networks/mynetwork --description=Allows\ connection\ from\ any\ source\ to\ any\ instance\ on\ the\ network\ using\ custom\ protocols. --direction=INGRESS --priority=65534 --source-ranges=10.128.0.0/9 --action=ALLOW --rules=all

gcloud compute firewall-rules create mynetwork-allow-icmp --network=projects/$PROJECT_ID/global/networks/mynetwork --description=Allows\ ICMP\ connections\ from\ any\ source\ to\ any\ instance\ on\ the\ network. --direction=INGRESS --priority=65534 --source-ranges=0.0.0.0/0 --action=ALLOW --rules=icmp


gcloud compute firewall-rules create mynetwork-allow-rdp --network=projects/$PROJECT_ID/global/networks/mynetwork --description=Allows\ RDP\ connections\ from\ any\ source\ to\ any\ instance\ on\ the\ network\ using\ port\ 3389. --direction=INGRESS --priority=65534 --source-ranges=0.0.0.0/0 --action=ALLOW --rules=tcp:3389

gcloud compute firewall-rules create mynetwork-allow-ssh --network=projects/$PROJECT_ID/global/networks/mynetwork --description=Allows\ TCP\ connections\ from\ any\ source\ to\ any\ instance\ on\ the\ network\ using\ port\ 22. --direction=INGRESS --priority=65534 --source-ranges=0.0.0.0/0 --action=ALLOW --rules=tcp:22



while [[ $VERIFY_DETAILS != 'y' ]];
do echo " " && 
read -p "${BOLD}${YELLOW}Enter Zone   : ${RESET}" ZONE && 
read -p "${BOLD}${YELLOW}Enter Region : ${RESET}" REGION && 
echo "${BOLD} " && 
echo "${YELLOW}Zone   : ${CYAN}$ZONE  " && 
echo "${YELLOW}Region : ${CYAN}$REGION  " && 
echo " " && 
read -p "${BOLD}${YELLOW}Verify all details are correct? [ y/n ] : ${RESET}" VERIFY_DETAILS;
done

gcloud compute instances create	mynet-us-vm --machine-type e2-micro --zone $ZONE --network-interface=network-tier=PREMIUM,subnet=mynetwork
gcloud compute instances create	mynet-eu-vm --machine-type e2-micro --zone europe-west1-c --network-interface=network-tier=PREMIUM,subnet=mynetwork

gcloud compute networks update mynetwork --switch-to-custom-subnet-mode --quiet

completed "Task 1"

export PROJECT_ID=$(gcloud info --format='value(config.project)')
REGION1=`echo $ZONE | rev | cut -c  3- | rev`
gcloud compute networks create managementnet --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional 
gcloud compute networks subnets create managementsubnet-us --network=managementnet --region=$REGION --range=10.240.0.0/20

gcloud compute networks create privatenet --subnet-mode=custom
gcloud compute networks subnets create privatesubnet-us --network=privatenet --region=$REGION --range=172.16.0.0/24
gcloud compute networks subnets create privatesubnet-eu --network=privatenet --region=europe-west1 --range=172.20.0.0/20
gcloud compute networks list
gcloud compute networks subnets list --sort-by=NETWORK

gcloud compute firewall-rules create managementnet-allow-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=managementnet --action=ALLOW --rules=tcp:22,tcp:3389,icmp --source-ranges=0.0.0.0/0

gcloud compute firewall-rules create privatenet-allow-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=privatenet --action=ALLOW --rules=icmp,tcp:22,tcp:3389 --source-ranges=0.0.0.0/0

gcloud compute firewall-rules list --sort-by=NETWORK


completed "Task 2"

gcloud compute instances create managementnet-us-vm --zone=$ZONE --machine-type=e2-micro --subnet=managementsubnet-us --image-family=debian-11 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=managementnet-us-vm

gcloud compute instances create privatenet-us-vm --zone=$ZONE --machine-type=e2-micro --subnet=privatesubnet-us --image-family=debian-11 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=privatenet-us-vm

gcloud compute instances list --sort-by=ZONE


completed "Task 3"

completed "Lab"

remove_files