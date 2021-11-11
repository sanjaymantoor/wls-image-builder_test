echo "Starting test wls setup"
read arg1
echo $arg1
pwd
cd /u01
mkdir wlssetup
cd wlssetup
pwd
echo $arg1 > out
export WEBLOGIC_DEPLOY_TOOL=https://github.com/oracle/weblogic-deploy-tooling/releases/download/weblogic-deploy-tooling-1.8.1/weblogic-deploy.zip

wget $WEBLOGIC_DEPLOY_TOOL

echo "Ending test wls setup"