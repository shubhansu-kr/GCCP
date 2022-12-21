curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

export PROJECT_ID=$(gcloud info --format='value(config.project)')

gcloud compute networks create privatenet --subnet-mode=custom
gcloud compute networks subnets create privatenet-us --network=privatenet --region=us-central1 --range=10.130.0.0/20

gcloud compute firewall-rules create privatenet-allow-ssh --direction=INGRESS --priority=1000 --network=privatenet --action=ALLOW --rules=tcp:22 --source-ranges=35.235.240.0/20

gcloud compute instances create vm-internal --zone=us-central1-c --machine-type=n1-standard-1 --network-interface=subnet=privatenet-us,no-address --image-family=debian-11 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard --boot-disk-device-name=vm-internal

completed "Task 1"

export BUCKET_NAME=$(gcloud info --format='value(config.project)')
gsutil mb gs://$BUCKET_NAME 
touch sample.txt
gsutil cp sample.txt gs://$BUCKET_NAME
export MY_BUCKET=$BUCKET_NAME 
echo $MY_BUCKET
gsutil cp gs://cloud-training/gcpnet/private/access.svg gs://$MY_BUCKET
gsutil cp gs://$MY_BUCKET/*.svg .

gcloud compute networks subnets update privatenet-us --enable-private-ip-google-access --region=us-central1

completed "Task 2"

gcloud compute routers create nat-router \
    --network=privatenet \
    --region=us-central1

gcloud compute routers nats create nat-config \
   --router=nat-router \
   --region=us-central1 \
   --auto-allocate-nat-external-ips \
   --nat-all-subnet-ip-ranges

completed "Task 3"

completed "Lab"

remove_files