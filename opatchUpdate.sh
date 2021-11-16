#!/bin/bash
# This script updates the opatch 

#Function to output message to StdErr
function echo_stderr ()
{
    echo "$@" >&2
}

#Function to display usage message
function usage()
{
  echo_stderr "./opatchUpdate.sh <<< <parameters>"
}

#Function to cleanup all temporary files
function cleanup()
{
    echo "Cleaning up temporary files..."
    sudo rm -rf ${opatchWork}
}

function downloadUsingWget()
{
	sudo mkdir -p ${opatchWork}
	filename=${downloadURL##*/}
	for in in {1..5}
	do
		cd ${opatchWork}
		wget $downloadURL
		if [ $? != 0 ];
     	then
        	echo "opatch patch download failed with $downloadURL. Trying again..."
			sudo rm -f $filename
     	else 
        	echo "$opatch patch Downloaded successfully"
        break
     fi
   done
   sudo chown -R $username:$groupname ${opatchWork}
}

function updatePatch()
{
	cd ${opatchWork}
	echo "Opatch version before updating patch"
	runuser -l oracle -c "$oracleHome/OPatch/opatch version"
   	runuser -l oracle -c "unzip $filename"
   	opatchFileName=`find . -name opatch_generic.jar`
	runuser -l oracle -c "cd $oracleHome/wlserver/server/bin ; . ./setWLSEnv.sh"
	command="java -jar ${opatchFileName} -silent oracle_home=$oracleHome"
	echo "Executing optach update command:"${command}
	runuser -l oracle -c "${command}"
	echo "Opatch version after updating patch"
	runuser -l oracle -c "$oracleHome/OPatch/opatch version"
}

#main script starts here

read downloadURL

if [ $downloadURL != "none" ];
then
	CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	BASE_DIR="$(readlink -f ${CURR_DIR})"
	oracleHome="/u01/app/wls/install/oracle/middleware/oracle_home"
	opatchWork="/u01/app/opatch"

	downloadUsingWget
	updatePatch
	cleanup
fi	
  
