## Requirements

| Name       | Version |
| ---------- |---------|
| Terragrunt | 0.45.0  |
| Terraform  | 1.4.4   |

## Install Terraform

- Link
  - https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

- MacOs
  - `brew tap hashicorp/tap`
  - `brew install hashicorp/tap/terraform`
  - `brew update`

## Install Terragrunt

- Link https://terragrunt.gruntwork.io/docs/getting-started/install/

- MacOs  
  - `brew install terragrunt`

## Feature of Terragrunt over Terraform
- Allow us to pass variable in s3_backend like storage bucket.

**Terragrunt & Terraform Version Managers**

- [tfenv](https://github.com/tfutils/tfenv)
- [tgenv](https://github.com/cunymatthieu/tgenv)

**Documentation**

- [Terraform](https://www.terraform.io/docs/index.html)
- [Terragrunt](https://terragrunt.gruntwork.io/docs/)

## Usage

RECOMMENDED: Run separately from each config directory containing `terragrunt.hcl` file.
```
terragrunt plan
terragrunt apply
[Optional] terragrunt apply -auto-approve  # if you want to apply the changes with approval.
terragrunt destroy
```

OPTIONAL: Run everything at once from a specific directory.  
```
terragrunt run-all plan
terragrunt run-all apply
terragrunt run-all destroy --terragrunt-ignore-external-dependencies
```

### Connect with the cluster

- Configure `aws cli` 
- Check `aws --version`
- Create or update the kubeconfig file for your cluster:
`aws eks --region eu-west-2 update-kubeconfig --name local-practice-dev-EKS-Cluster`

aws ecr get-login-password --region region | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.region.amazonaws.com

kubectl config use-context minikube 
minikube dahsboard

### AWS Load Balancer annotations and docs link

- https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.3/guide/service/annotations/


### Find and Delete files or directories recursively

- find . -name ".terraform.lock.hcl" -type f -delete
- find . -name ".terragrunt-cache" -type d -exec rm -rf {} +

export KUBECONFIG=$(pwd) /managing-eks-terraform-cluster_config


