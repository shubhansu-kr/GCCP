curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

export PROJECT_ID=$(gcloud info --format='value(config.project)')

gcloud compute addresses create mc-server-ip --region=us-central1
gcloud compute addresses list
IP=`gcloud compute addresses describe mc-server-ip --region=us-central1 --format="value(address)"`
echo $IP
gcloud compute instances create mc-server --zone=us-central1-a --machine-type=e2-medium --network-interface=address=$IP,network-tier=PREMIUM,subnet=default --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --scopes=https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/trace.append,https://www.googleapis.com/auth/devstorage.read_write --tags=minecraft-server --create-disk=auto-delete=yes,boot=yes,device-name=mc-server,image=projects/debian-cloud/global/images/debian-11-bullseye-v20221206,mode=rw,size=10,type=projects/$PROJECT_ID/zones/us-central1-a/diskTypes/pd-balanced --create-disk=device-name=minecraft-disk,mode=rw,name=minecraft-disk,size=50,type=projects/$PROJECT_ID/zones/us-central1-a/diskTypes/pd-ssd --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any

PROJECT_NUMBER=`gcloud projects describe $PROJECT_ID --format="value(projectNumber)"`

echo "${YELLOW}${BOLD}visit ${BLUE}
https://ssh.cloud.google.com/v2/ssh/projects/$PROJECT_ID/zones/us-central1-a/instances/mc-server?authuser=0&hl=en_US&projectNumber=$PROJECT_NUMBER&nonAdminProxySessionReason=1&troubleshoot4005Enabled=true&troubleshoot255Enabled=true ${YELLOW} and run below code

${MAGENTA}

sudo mkdir -p /home/minecraft
sudo mkfs.ext4 -F -E lazy_itable_init=0,\
lazy_journal_init=0,discard \
/dev/disk/by-id/google-minecraft-disk
sudo mount -o discard,defaults /dev/disk/by-id/google-minecraft-disk /home/minecraft
sudo apt-get update
sudo apt-get install -y default-jre-headless
cd /home/minecraft
sudo apt-get install -y wget
sudo wget https://launcher.mojang.com/v1/objects/d0d0fe2b1dc6ab4c65554cb734270872b72dadd6/server.jar
sudo java -Xmx1024M -Xms1024M -jar server.jar nogui
sudo ls -l
sudo sed -i s/false/true/g eula.txt

sudo apt-get install -y screen
sudo screen -S mcs java -Xmx1024M -Xms1024M -jar server.jar nogui
sudo screen -r mcs

"

gcloud compute firewall-rules create minecraft-rule --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:25565 --source-ranges=0.0.0.0/0 --target-tags=minecraft-server


completed "Task 3"

export YOUR_BUCKET_NAME=$PROJECT_ID
echo "${YELLOW}${BOLD}
Run this in ssh
${MAGENTA}

export YOUR_BUCKET_NAME=$PROJECT_ID
gsutil mb gs://$YOUR_BUCKET_NAME-minecraft-backup

cd /home/minecraft

${YELLOW}
Now run manually from lab page
 - create backup.sh file and further process

"

completed "Lab"

remove_files