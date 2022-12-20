curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

mkdir appengine-hello
cd appengine-hello
gsutil cp gs://cloud-training/archinfra/gae-hello/* .
gcloud app deploy app.yaml --quiet
gcloud app browse
completed "Task 1"


sed -i -e 's/webapp2/webapp22/' main.py
gcloud app deploy app.yaml --quiet
gcloud app browse


completed "Task 2"

completed "Lab"

remove_files