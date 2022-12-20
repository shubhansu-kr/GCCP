curl -o default.sh https://raw.githubusercontent.com/gcp-q/GCCP/main/files/default.sh
source default.sh

export my_zone=us-central1-a
export my_cluster=standard-cluster-1
source <(kubectl completion bash)
gcloud container clusters get-credentials $my_cluster --zone $my_zone
git clone https://github.com/GoogleCloudPlatform/training-data-analyst
ln -s ~/training-data-analyst/courses/ak8s/v1.1 ~/ak8s
cd ~/ak8s/Storage/
kubectl get persistentvolumeclaim
kubectl apply -f pvc-demo.yaml
kubectl get persistentvolumeclaim

completed "Task 1"

kubectl apply -f pod-volume-demo.yaml
kubectl get pods
kubectl exec -it pvc-demo-pod -- sh
echo Test webpage in a persistent volume!>/var/www/html/index.html
chmod +x /var/www/html/index.html
cat /var/www/html/index.html


kubectl delete pod pvc-demo-pod
kubectl get pods
kubectl get persistentvolumeclaim
kubectl apply -f pod-volume-demo.yaml
kubectl get pods 
cat /var/www/html/index.html


completed "Task 2"

kubectl delete pod pvc-demo-pod
kubectl get pods
kubectl apply -f statefulset-demo.yaml
kubectl describe statefulset statefulset-demo
kubectl get pods
kubectl get pvc
kubectl describe pvc hello-web-disk-statefulset-demo-0

completed "Task 3"

completed "Lab"

remove_files