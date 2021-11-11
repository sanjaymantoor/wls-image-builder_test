echo "Starting test wls setup"
pwd
cd /var/lib/waagent
mkdir wlssetup
cd wlssetup
pwd
export WEBLOGIC_DEPLOY_TOOL=https://github.com/oracle/weblogic-deploy-tooling/releases/download/weblogic-deploy-tooling-1.8.1/weblogic-deploy.zip

wget $WEBLOGIC_DEPLOY_TOOL

echo "Ending test wls setup"