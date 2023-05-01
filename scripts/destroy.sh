#!/bin/sh

echo '##########################################'
echo 'terragrunt destroy'
echo '##########################################'
terraform fmt -recursive
terragrunt destroy --auto-approve
ret=$?
if [ $ret -ne 0 ]; then
exit $ret
fi
