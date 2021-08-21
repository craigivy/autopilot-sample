# autopilot-sample

## Prerequisites
* GCP project
* User with the proper permissions
* 

WARNING: This is designed to be a proof of concept and is not security hardened

## Create the infrastructure (GKE autopilot)
```
cd terraform
export TF_VAR_project=[your_gcp_project]
terraform init
terraform apply
```
