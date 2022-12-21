curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

export PROJECT_ID=$(gcloud info --format='value(config.project)')

gcloud compute instances create utility-vm  --zone=us-central1-c --machine-type=n1-standard-1 --network-interface=subnet=default,no-address --metadata=enable-oslogin=true --maintenance-policy=MIGRATE --provisioning-model=STANDARD --create-disk=auto-delete=yes,boot=yes,device-name=utility-vm,image=projects/debian-cloud/global/images/debian-10-buster-v20221206,mode=rw,size=10,type=projects/$PROJECT_ID/zones/us-central1-c/diskTypes/pd-balanced 


#gcloud compute instances create vm-internal --zone=us-central1-c --machine-type=n1-standard-1 --image-family=debian-10 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=vm-internal

completed "Task 1"


gcloud compute instances create window-vm --zone=europe-west1-c --machine-type=n1-standard-2 --metadata=enable-oslogin=true --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=http-server,https-server --create-disk=auto-delete=yes,boot=yes,device-name=window-vm,image=projects/windows-cloud/global/images/windows-server-2016-dc-core-v20221214,mode=rw,size=100,type=projects/$PROJECT_ID/zones/europe-west1-c/diskTypes/pd-ssd --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any
completed "Task 2"

gcloud compute instances create custom-vm --zone=us-central1-a --machine-type=e2-custom-2-4096  --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --create-disk=auto-delete=yes,boot=yes,device-name=instance-1,image=projects/debian-cloud/global/images/debian-10-buster-v20221206,mode=rw,size=10,type=projects/$PROJECT_ID/zones/us-central1-a/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any

gcloud beta compute reset-windows-password "window-vm" --zone "europe-west1-c" --quiet

completed "Task 3"

completed "Lab"

remove_files