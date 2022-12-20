curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

BUCKET_NAME=$(gcloud info --format='value(config.project)')
gsutil mb  gs://$BUCKET_NAME

PROJECT_ID=$(gcloud info --format='value(config.project)')
cat > index.html <<EOF
<html><head><title>Cat</title></head>
<body>
<h1>Cat</h1>
<img src="https://storage.googleapis.com/$PROJECT_ID/cat.jpg">
</body></html>
EOF

cat > startup_script.sh <<EOF
#!/bin/bash
apt-get remove -y --purge man-db
touch /var/lib/man-db/auto-update
apt-get update
apt-get install -y nginx
sleep 40
gsutil cp gs://$PROJECT_ID/index.html index.nginx-debian.html
cp index.nginx-debian.html /var/www/html
EOF
gsutil  cp startup_script.sh gs://$PROJECT_ID
gsutil cp index.html gs://$BUCKET_NAME

sleep 4

gcloud compute instances create first-vm \
--project=$PROJECT_ID \
--zone=us-central1-c \
--machine-type=e2-micro \
--tags=http-server \
--metadata=startup-script-url=gs://$PROJECT_ID/startup_script.sh 

EXTERNAL_IP=`gcloud compute instances list --format="value(EXTERNAL_IP)"`

warning "Visit http://$EXTERNAL_IP"

gcloud iam service-accounts create test-service-account 
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:test-service-account@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/editor"

gcloud iam service-accounts keys create sa-test-service-account.json \
    --iam-account=test-service-account@$PROJECT_ID.iam.gserviceaccount.com

completed "Task 1"

MY_BUCKET_NAME_1=$BUCKET_NAME
MY_BUCKET_NAME_2=`echo $BUCKET_NAME`_2
MY_REGION=us-central1

gsutil mb gs://$MY_BUCKET_NAME_2
gcloud compute zones list | grep $MY_REGION
MY_ZONE=us-central1-b
gcloud config set compute/zone $MY_ZONE

gcloud compute instances list
MY_VMNAME=second-vm
gcloud compute instances create $MY_VMNAME \
--machine-type "e2-standard-2" \
--image-project "debian-cloud" \
--image-family "debian-11" \
--subnet "default"
gcloud compute instances list
gcloud iam service-accounts create test-service-account2 --display-name "test-service-account2"
completed "Task 2"


cp sa-test-service-account.json credentials.json
gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT --member serviceAccount:test-service-account2@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com --role roles/viewer
gsutil cp gs://cloud-training/ak8s/cat.jpg cat.jpg
gsutil cp cat.jpg gs://$MY_BUCKET_NAME_1
gsutil cp gs://$MY_BUCKET_NAME_1/cat.jpg gs://$MY_BUCKET_NAME_2/cat.jpg
gsutil acl get gs://$MY_BUCKET_NAME_1/cat.jpg  > acl.txt
cat acl.txt
gsutil acl set private gs://$MY_BUCKET_NAME_1/cat.jpg
gsutil acl get gs://$MY_BUCKET_NAME_1/cat.jpg  > acl-2.txt
cat acl-2.txt
gcloud config list
gcloud auth activate-service-account --key-file credentials.json
gcloud config list
gcloud auth list
gsutil cp gs://$MY_BUCKET_NAME_1/cat.jpg ./cat-copy.jpg
gsutil cp gs://$MY_BUCKET_NAME_2/cat.jpg ./cat-copy.jpg
gsutil cp gs://$MY_BUCKET_NAME_1/cat.jpg ./copy2-of-cat.jpg
gsutil iam ch allUsers:objectViewer gs://$MY_BUCKET_NAME_1

completed "Task 3"

git clone https://github.com/googlecodelabs/orchestrate-with-kubernetes.git
mkdir test
cd orchestrate-with-kubernetes
cat cleanup.sh

warning "Visit http://$EXTERNAL_IP"

completed "Task 4"

completed "Lab"
remove_files