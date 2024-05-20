# V RISING SERVER 

this is a simple v rising server running on Google Cloud

## Prerequesites

- [docker](https://docs.docker.com/get-docker/)
- [envcontainer](https://github.com/erickmaria/envcontainer)

this project use envcontainer to provide all that you will need to run this project
> [!TIP]
> if you dont want use `envcontainer` if can install all tools on your machine. Look `.envcontainer.yaml` and see what you need.

## QUICK START

To continue, you must have a [google cloud account](https://cloud.google.com/), you can try beginning with tier free if you 
want.

### Setup
```bash
git clone https://github.com/erickmaria/r-rising-server.git
cd r-rising-server
# if you using envcontainer
envcontainer build
envcontainer start
```
> [!IMPORTANT]
> if using `envcontainer` make sure docker is running.

### Login on GCP

Make login on your google cloud account
```bash
gcloud auth login
```

Get project that you use
```bash
gcloud projects list --sort-by=projectId
```

export a environment variable with your project id that you catch on previous step
```bash
export PROJECT_ID=<YOUR_PROJECT_ID>
export PROJECT_REGION=us-east1
```

now set the gcp project to use
```bash 
gcloud config set project $PROJECT_ID
```

Make login again but now with *application-default*
```bash 
gcloud auth application-default login 
```

### Infrastructure Provision

To provide infrastructure follow the terraform commands

export variables
```bash
export TF_VAR_gcp_project_id=$PROJECT_ID
export TF_VAR_gcp_project_region=$PROJECT_REGION
```
> we will use them in the future

on root folder
```bash 
cd infraeasturure
terraform init
terraform plan
terraform apply

cd ../
```

### Setup Server Configuration

Generate inventory file with project and region variables
```bash 
cat configuration/misc/gcp.yml.hpl | \
sed "s/{{ gcp_project_id }}/$PROJECT_ID/g" | \
sed "s/{{ gcp_project_region }}/$PROJECT_REGION/g" \
> configuration/inventory/gcp.yml
```

Generate a ssh key to connect on v rising server
```bash 
gcloud compute config-ssh
```
on root folder
```bash 
cd configuration
ansible-playbook playbooks/install_server_dependencies.yaml
```

> [!IMPORTANT]
> - this playbook is optional, if you have a local save or any other save you can import on the server.
>   to make this copy your local *save files* inside folder `configuration/misc/vrising-local-saves/v3/`.
>   ```bash
>   ansible-playbook playbooks/copy_your_local_save_to_server.yaml
>   ```

```bash
ansible-playbook playbooks/create_backup_routine.yaml
ansible-playbook playbooks/start_server.yaml
```

you can remove ssh key using follow command. `OPTIONAL` 
```bash
gcloud compute config-ssh -- remove
```

### IMPORTANT

make sure to backup these files `terraform.tfstate` and  `serviceaccount.json`
