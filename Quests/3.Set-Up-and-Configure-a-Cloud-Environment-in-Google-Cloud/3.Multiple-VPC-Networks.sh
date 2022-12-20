curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

export PROJECT=$(gcloud info --format='value(config.project)')

warning "${RESET}${YELLOW}Enter below details carefully from the lab page "

read -p "${BOLD}${YELLOW}Enter Region${RESET}${YELLOW}(managementsubnet-us) : ${RESET}" REGION1
read -p "${BOLD}${YELLOW}Enter Region${RESET}${YELLOW}(privatesubnet-us)    : ${RESET}" REGION2
read -p "${BOLD}${YELLOW}Enter Region${RESET}${YELLOW}(privatesubnet-eu)    : ${RESET}" REGION3
read -p "${BOLD}${YELLOW}Enter Zone${RESET}${YELLOW}(managementnet-us-vm)   : ${RESET}" ZONE1
read -p "${BOLD}${YELLOW}Enter Zone${RESET}${YELLOW}(privatenet-us-vm)      : ${RESET}" ZONE2
read -p "${BOLD}${YELLOW}Enter Zone${RESET}${YELLOW}(vm-appliance)          : ${RESET}" ZONE3
echo " "
echo "${BOLD}${YELLOW}Region${RESET}${YELLOW}(managementsubnet-us) :${BOLD}${CYAN} $REGION1"
echo "${BOLD}${YELLOW}Region${RESET}${YELLOW}(privatesubnet-us)    :${BOLD}${CYAN} $REGION2"
echo "${BOLD}${YELLOW}Region${RESET}${YELLOW}(privatesubnet-eu)    :${BOLD}${CYAN} $REGION3"
echo "${BOLD}${YELLOW}Zone${RESET}${YELLOW}(managementnet-us-vm)   :${BOLD}${CYAN} $ZONE1"
echo "${BOLD}${YELLOW}Zone${RESET}${YELLOW}(privatenet-us-vm)      :${BOLD}${CYAN} $ZONE2"
echo "${BOLD}${YELLOW}Zone${RESET}${YELLOW}(vm-appliance)          :${BOLD}${CYAN} $ZONE3"
echo " "
read -p "${BOLD}${YELLOW}Verify all details are correct? [ y/n ] : ${RESET}" VERIFY_DETAILS

while [ $VERIFY_DETAILS != 'y' ];
do echo " " && 
read -p "${BOLD}${YELLOW}Enter Region${RESET}${YELLOW}(managementsubnet-us) : ${RESET}" REGION1 && 
read -p "${BOLD}${YELLOW}Enter Region${RESET}${YELLOW}(privatesubnet-us)    : ${RESET}" REGION2 && 
read -p "${BOLD}${YELLOW}Enter Region${RESET}${YELLOW}(privatesubnet-eu)    : ${RESET}" REGION3 && 
read -p "${BOLD}${YELLOW}Enter Zone${RESET}${YELLOW}(managementnet-us-vm)   : ${RESET}" ZONE1 && 
read -p "${BOLD}${YELLOW}Enter Zone${RESET}${YELLOW}(privatenet-us-vm)      : ${RESET}" ZONE2 && 
read -p "${BOLD}${YELLOW}Enter Zone${RESET}${YELLOW}(vm-appliance)          : ${RESET}" ZONE3 && 
echo " " &&
echo "${BOLD}${YELLOW}Region${RESET}${YELLOW}(managementsubnet-us) :${BOLD}${CYAN} $REGION1" && 
echo "${BOLD}${YELLOW}Region${RESET}${YELLOW}(privatesubnet-us)    :${BOLD}${CYAN} $REGION2" && 
echo "${BOLD}${YELLOW}Region${RESET}${YELLOW}(privatesubnet-eu)    :${BOLD}${CYAN} $REGION3" && 
echo "${BOLD}${YELLOW}Zone${RESET}${YELLOW}(managementnet-us-vm)   :${BOLD}${CYAN} $ZONE1" && 
echo "${BOLD}${YELLOW}Zone${RESET}${YELLOW}(privatenet-us-vm)      :${BOLD}${CYAN} $ZONE2" && 
echo "${BOLD}${YELLOW}Zone${RESET}${YELLOW}(vm-appliance)          :${BOLD}${CYAN} $ZONE3" &&
echo " " &&
read -p "${BOLD}${YELLOW}Verify all details are correct? [ y/n ] : ${RESET}" VERIFY_DETAILS;
done


gcloud compute networks create managementnet  --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional 
gcloud compute networks subnets create managementsubnet-us --network=managementnet --region=$REGION1 --range=10.130.0.0/20 

completed "Task 1"

gcloud compute networks create privatenet --subnet-mode=custom
gcloud compute networks subnets create privatesubnet-us --network=privatenet --region=$REGION2 --range=172.16.0.0/24
gcloud compute networks subnets create privatesubnet-eu --network=privatenet --region=$REGION3 --range=172.20.0.0/20

completed "Task 2"
gcloud compute firewall-rules create managementnet-allow-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=managementnet --action=ALLOW --rules=icmp,tcp:22,tcp:3389 --source-ranges=0.0.0.0/0

completed "Task 3"
gcloud compute firewall-rules create privatenet-allow-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=privatenet --action=ALLOW --rules=icmp,tcp:22,tcp:3389 --source-ranges=0.0.0.0/0

completed "Task 4"

gcloud compute instances create managementnet-us-vm --zone=$ZONE1 --machine-type=e2-micro --subnet=managementsubnet-us

completed "Task 5"
gcloud compute instances create privatenet-us-vm --zone=$ZONE2 --machine-type=e2-micro --subnet=privatesubnet-us

completed "Task 6"

gcloud compute instances create vm-appliance --zone=$ZONE3 --machine-type=e2-standard-4 --network-interface=network-tier=PREMIUM,subnet=managementsubnet-us --network-interface=network-tier=PREMIUM,subnet=privatesubnet-us --network-interface=network-tier=PREMIUM,subnet=mynetwork --maintenance-policy=MIGRATE --create-disk=auto-delete=yes,boot=yes,device-name=vm-appliance,image=projects/debian-cloud/global/images/debian-10-buster-v20210916,mode=rw,size=10,type=projects/$PROJECT/zones/us-central1-f/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any

completed "Task 7"

completed "Lab"

remove_files 
