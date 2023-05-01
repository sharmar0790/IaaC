#!/bin/sh

echo '##########################################'
echo 'Cleaning up terragrunt/terraform local generated/cache files'
echo '##########################################'
terraform fmt -recursive
find . -name ".terraform.lock.hcl" -type f -delete
ret=$?
if [ $ret -ne 0 ]; then
exit $ret
fi

find . -name ".terragrunt-cache" -type d -exec  rm -rf {} +
ret=$?
if [ $ret -ne 0 ]; then
exit $ret
fi
