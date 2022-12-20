curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh


bq --location=us mk --default_table_expiration=86400 imported_billing_data

bq --location=us load --autodetect --source_format=CSV  imported_billing_data.sampleinfotable gs://cloud-training/archinfra/export-billing-example.csv

completed "Task 1"


bq query --use_legacy_sql=false \
'SELECT * FROM `imported_billing_data.sampleinfotable`
WHERE Cost > 0'

completed "Task 2"

completed "Lab"

remove_files