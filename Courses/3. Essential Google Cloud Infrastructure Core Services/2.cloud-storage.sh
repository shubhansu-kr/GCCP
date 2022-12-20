curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

export BUCKET_NAME=$(gcloud info --format='value(config.project)')
gsutil mb gs://$BUCKET_NAME 
touch sample.txt
gsutil cp sample.txt gs://$BUCKET_NAME

completed "Task 1"

export BUCKET_NAME_1=$BUCKET_NAME
echo $BUCKET_NAME_1
curl \
https://hadoop.apache.org/docs/current/\
hadoop-project-dist/hadoop-common/\
ClusterSetup.html > setup.html
cp setup.html setup2.html
cp setup.html setup3.html

gsutil cp setup.html gs://$BUCKET_NAME_1/
gsutil acl get gs://$BUCKET_NAME_1/setup.html  > acl.txt
cat acl.txt
gsutil acl set private gs://$BUCKET_NAME_1/setup.html
gsutil acl get gs://$BUCKET_NAME_1/setup.html  > acl2.txt
cat acl2.txt
gsutil acl ch -u AllUsers:R gs://$BUCKET_NAME_1/setup.html
gsutil acl get gs://$BUCKET_NAME_1/setup.html  > acl3.txt
cat acl3.txt

completed "Task 2"

rm setup.html
ls -al
gsutil cp gs://$BUCKET_NAME_1/setup.html setup.html
gsutil config -n
ls -al
KEY1=`python3 -c 'import base64; import os; print(base64.encodebytes(os.urandom(32)))'`
echo $KEY1
KEY1=`echo $KEY1 | cut -c3- | rev | cut -c4- | rev`
echo $KEY1
sed -i "s/#encryption_key=/encryption_key=$KEY1/g" .boto
gsutil cp setup2.html gs://$BUCKET_NAME_1/
gsutil cp setup3.html gs://$BUCKET_NAME_1/
completed "Task 3"

rm setup*
gsutil cp gs://$BUCKET_NAME_1/setup* ./

sed -i "s/#decryption_key1=/decryption_key1=$KEY1/g" .boto


KEY2=`python3 -c 'import base64; import os; print(base64.encodebytes(os.urandom(32)))'`
echo $KEY2
KEY2=`echo $KEY2 | cut -c3- | rev | cut -c4- | rev`
echo $KEY2
ls -al
sed -i "s/encryption_key=$KEY1/encryption_key=$KEY2/g" .boto
gsutil rewrite -k gs://$BUCKET_NAME_1/setup2.html

sed -i "s/decryption_key1=$KEY1/#decryption_key1=$KEY1/g" .boto
gsutil cp  gs://$BUCKET_NAME_1/setup2.html recover2.html
gsutil cp  gs://$BUCKET_NAME_1/setup3.html recover3.html
gsutil lifecycle get gs://$BUCKET_NAME_1
cat > life.json <<EOF
{
  "rule":
  [
    {
      "action": {"type": "Delete"},
      "condition": {"age": 31}
    }
  ]
}
EOF
gsutil lifecycle set life.json gs://$BUCKET_NAME_1
gsutil lifecycle get gs://$BUCKET_NAME_1
completed "Task 4"

gsutil versioning get gs://$BUCKET_NAME_1
gsutil versioning set on gs://$BUCKET_NAME_1
gsutil versioning get gs://$BUCKET_NAME_1
completed "Task 5"

ls -al setup.html
sed -i '1,5d' setup.html
gsutil cp -v setup.html gs://$BUCKET_NAME_1
sed -i '1,5d' setup.html
gsutil cp -v setup.html gs://$BUCKET_NAME_1
gsutil ls -a gs://$BUCKET_NAME_1/setup.html

export VERSION_NAME=`gsutil ls -a gs://$BUCKET_NAME_1/setup.html | head -1`
echo $VERSION_NAME
gsutil cp $VERSION_NAME recovered.txt
ls -al setup.html
ls -al recovered.txt
mkdir firstlevel
mkdir ./firstlevel/secondlevel
cp setup.html firstlevel
cp setup.html firstlevel/secondlevel
gsutil rsync -r ./firstlevel gs://$BUCKET_NAME_1/firstlevel
gsutil ls -r gs://$BUCKET_NAME_1/firstlevel



FIRSTPROJECT=`gcloud info --format='value(config.project)'`
SECONDPROJECT=`gcloud projects list  --format='value(project_id)'| grep qwiklabs-gcp | head -1`

if [ $FIRSTPROJECT = $SECONDPROJECT ]
then
SECONDPROJECT=`gcloud projects list  --format='value(project_id)'| grep qwiklabs-gcp | head -2 | tail -1`
fi

if [ $FIRSTPROJECT = $SECONDPROJECT ]
then
read -p "${YELLOW}${BOLD}Enter second Project  : ${RESET}" SECONDPROJECT
echo $SECONDPROJECT
fi

warning "Your second Project =${CYAN} $SECONDPROJECT"
gcloud config set project $SECONDPROJECT
export PROJECT_ID=$(gcloud info --format='value(config.project)')

export BUCKET_NAME_2=$(gcloud info --format='value(config.project)')
gsutil mb gs://$BUCKET_NAME_2
touch sample.txt
gsutil cp sample.txt gs://$BUCKET_NAME_2


SA_NAME=cross-project-storage
echo $SA_NAME
gcloud iam service-accounts create $SA_NAME 

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/storage.objectAdmin"

gcloud iam service-accounts keys create sa-$SA_NAME.json \
    --iam-account=$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com

cp sa-$SA_NAME.json credentials.json

completed "Task 6"


gcloud config set project $FIRSTPROJECT
export PROJECT_ID=$(gcloud info --format='value(config.project)')

gcloud compute instances create crossproject --machine-type=n1-standard-1  --zone=europe-west1-d --create-disk=auto-delete=yes,boot=yes,device-name=crossproject,image=projects/debian-cloud/global/images/debian-10-buster-v20221206,mode=rw,size=10,type=projects/$PROJECT_ID/zones/europe-west1-d/diskTypes/pd-balanced 


echo $BUCKET_NAME_2
export FILE_NAME=sample.txt
echo $FILE_NAME

gsutil ls gs://$BUCKET_NAME_2/

ls
gcloud auth activate-service-account --key-file credentials.json
gsutil ls gs://$BUCKET_NAME_2/
gsutil cat gs://$BUCKET_NAME_2/$FILE_NAME
gsutil cp credentials.json gs://$BUCKET_NAME_2/


gcloud config set project $SECONDPROJECT
export PROJECT_ID=$(gcloud info --format='value(config.project)')

gcloud iam service-accounts add-iam-policy-binding $SA_NAME@$PROJECT_ID.iam.gserviceaccount.com --member="serviceAccount:$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com" --role="roles/storage.objectAdmin"

#gcloud projects add-iam-policy-binding $PROJECT_ID  --member="serviceAccount:$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com"  --role="roles/compute.admin"


#gcloud iam service-accounts add-iam-policy-binding read-bucket-objects@$PROJECT_ID.iam.gserviceaccount.com  --member="serviceAccount:$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com" --role="roles/storage.objectAdmin"

completed "Task 7"

completed "Lab"

remove_files
