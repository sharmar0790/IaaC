## Requirements

| Name       | Version |
| ---------- | ------- |
| Terragrunt | 0.37.1  |
| Terraform  | 1.2.2   |

## Install Terraform

- Links - https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
- brew tap hashicorp/tap
- brew install hashicorp/tap/terraform
- brew update

## Install Terragrunt

- Links https://terragrunt.gruntwork.io/docs/getting-started/install/
- brew install terragrunt

## Feature of Terragrunt over Terraform

- Allow us to pass variable in s3_backend like storage bucket

######      ##########################

**Terragrunt & Terraform Version Managers**

- [tfenv](https://github.com/tfutils/tfenv)
- [tgenv](https://github.com/cunymatthieu/tgenv)

**Documentation**

- [Terraform](https://www.terraform.io/docs/index.html)
- [Terragrunt](https://terragrunt.gruntwork.io/docs/)

# Usage

RECOMMENDED: Run separately from each config directory containing `terragrunt.hcl` file

```
terragrunt plan
terragrunt apply
[Optional] terragrunt apply -auto-approve  # if you want to apply the changes with approval.
terragrunt destroy
```

OPTIONAL: Run everything at once from a specific directory

```
terragrunt run-all plan
terragrunt run-all apply
terragrunt run-all destroy --terragrunt-ignore-external-dependencies
```

# Connect with the cluster

- Configure `aws cli`
- Check `aws --version`
- Create or update the kubeconfig file for your cluster:
  `aws eks --region eu-west-2 update-kubeconfig --name Local-Dev-Eks-Cluster`

aws ecr get-login-password --region region | docker login --username AWS --password-stdin
aws_account_id.dkr.ecr.region.amazonaws.com

kubectl config use-context minikube minikube dahsboard

terragrunt run-all apply terragrunt run-all destroy terragrunt run-all output terragrunt run-all plan

# TODO

- try to see an option to manage/configure security groups for eks node groups.
- 

