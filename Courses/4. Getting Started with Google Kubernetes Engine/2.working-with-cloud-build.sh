curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

gcloud services enable cloudbuild.googleapis.com
gcloud services enable containerregistry.googleapis.com

cat > quickstart.sh <<EOF
#!/bin/sh
echo "Hello, world! The time is $(date)."
EOF

cat > Dockerfile <<EOF
FROM alpine
COPY quickstart.sh /
CMD ["/quickstart.sh"]
EOF

chmod +x quickstart.sh
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/quickstart-image .

git clone https://github.com/GoogleCloudPlatform/training-data-analyst
ln -s ~/training-data-analyst/courses/ak8s/v1.1 ~/ak8s
cd ~/ak8s/Cloud_Build/a


gcloud builds submit --config cloudbuild.yaml .

completed "Task 1"

cd ~/ak8s/Cloud_Build/b
gcloud builds submit --config cloudbuild.yaml .
echo $?

completed "Task 2"

completed "Lab"

remove_files