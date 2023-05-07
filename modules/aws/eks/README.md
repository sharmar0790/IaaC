The User Data script above does the following:  Starts the CloudWatch Logs Agent so that logs from the EC2 instance ( especially syslog) are sent to CloudWatch Logs.  Starts fail2ban to protect the instance against malicious SSH attempts.  
Runs the EKS bootstrap script to register the instance in the cluster.  
Run ip-lockdown to lock down the EC2 metadata endpoint so only the root and ec2-user users can access it.  

Note that at the bottom of user-data.sh, there are some variables that are supposed to be filled in by Terraform interpolation. How does that work? When you configured the worker nodes earlier in this guide, you set the cluster_instance_user_data parameter to a template_file data source that didn’t yet exist; well, this is what’s going to provide the variables via interpolation! Add the template_file data source as follows: 
