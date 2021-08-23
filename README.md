# autopilot-sample

## Prerequisites
* GCP project
* User with the proper permissions
* 

WARNING: This is designed to be a proof of concept and is not security hardened

## Create the infrastructure 
This will create the following infrastructure
* Cloud Pubsub
* GKE autopilot

```
cd terraform
export TF_VAR_project=[your_gcp_project]
export TF_VAR_region=us-central1
terraform init
terraform apply
```

# Install PGAdmin 
These commands configure and deploy PGAdmin
```
cd ..
gcloud container clusters get-credentials devcluster --region ${TF_VAR_region} --project ${TF_VAR_project}

kubectl create namespace app

kubectl config set-context --current --namespace=app

kubectl create configmap connectionname \
--from-literal=connectionname="${TF_VAR_project}:${TF_VAR_region}:my-instance"

kubectl apply -f k8s/service-account.yaml

gcloud iam service-accounts add-iam-policy-binding \
--role="roles/iam.workloadIdentityUser" \
--member="serviceAccount:${TF_VAR_project}.svc.id.goog[app/gke]" \
sqlproxy-kube@${TF_VAR_project}.iam.gserviceaccount.com

kubectl annotate serviceaccount \
gke \
iam.gke.io/gcp-service-account=sqlproxy-kube@${TF_VAR_project}.iam.gserviceaccount.com

kubectl --namespace default create configmap connectionname \
--from-literal=connectionname="${TF_VAR_project}:${TF_VAR_region}:my-instance"

kubectl create secret generic pgadmin-console \
--from-literal=user="me@email.com" \
--from-literal=password="changeme"

kubectl apply -f k8s/pgadmin.yaml
```

## Connect to PGAdmin using port-forwarding
Setup port-forwarding to you localhost.
```
POD_ID=$(kubectl get pods -o name | cut -d '/' -f 2)
kubectl port-forward "$POD_ID" 8080:80
```

In a browser go to http://localhost:8080 and connect to the `my-database` using the user `dbuser` and the password `changeme`
