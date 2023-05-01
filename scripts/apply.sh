#!/bin/sh

echo '##########################################'
echo 'terragrunt apply'
echo '##########################################'
terraform fmt -recursive
terragrunt apply --auto-approve
ret=$?
if [ $ret -ne 0 ]; then
exit $ret
fi
