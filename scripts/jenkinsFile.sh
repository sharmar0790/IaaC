#!/bin/sh

echo '##########################################'
echo 'terragrunt init --upgrade'
echo '##########################################'
terraform fmt -recursive
terragrunt init --upgrade
ret=$?
if [ $ret -ne 0 ]; then
exit $ret
fi

echo '##########################################'
echo 'terragrunt validate'
echo '##########################################'
terragrunt validate
ret=$?
if [ $ret -ne 0 ]; then
exit $ret
fi

echo '##########################################'
echo 'terragrunt plan'
echo '##########################################'
terragrunt plan
ret=$?
if [ $ret -ne 0 ]; then
exit $ret
fi

echo '##########################################'
echo 'terragrunt apply'
echo '##########################################'
terragrunt apply
ret=$?
if [ $ret -ne 0 ]; then
exit $ret
fi
