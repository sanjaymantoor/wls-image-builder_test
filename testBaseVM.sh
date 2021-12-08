# This script test the base VM with provided inputs

read testPropertyFile

yum install -y git jq
mkdir -p /root/scripts
cd /root/scripts
git clone https://github.com/gnsuryan/azure-wls-test

cd /root/scripts/azure-wls-test

chmod +x ./basic/basic_test.sh

./basic/basic_test.sh -i /root/scripts/azure-wls-test/test_input/${testPropertyFile}
