#!/bin/bash

export UTILS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo "UTILS_DIR: ${UTILS_DIR}"

export BASE_DIR="$(readlink -f $UTILS_DIR/..)"
echo "BASE_DIR: ${BASE_DIR}"

usage()
{
cat << USAGE >&2
Usage:
    -i            INPUT_FILE        Path to Command input File
    -h|?|--help   HELP              Help/Usage info
USAGE

exit 1
}

function run_as_oracle_user()
{
    command="$1"
    runuser -l oracle -c "$command"
}


get_param()
{
    while [ "$1" ]
    do
        case $1 in
         -i         )  INPUT_FILE=$2 ;;
                   *)  echo 'invalid arguments specified'
                       usage;;
        esac
        shift 2
    done
}

validate_input()
{
    if [ -z "$INPUT_FILE" ];
    then
        echo "command input file not provided"
        usage;
    fi

    if [[ ! -f "$INPUT_FILE" ]];
    then
        echo "Provided input file ${INPUT_FILE} not found"
        exit 1
    fi
   
    echo "Using input file $INPUT_FILE"
    source $INPUT_FILE
}

function notifyPass()
{
    passcount=$((passcount+1))
}

function notifyFail()
{
    failcount=$((failcount+1))
}

function printTestSummary()
{
    exitOnFailure="$1"

    if [ -z "$exitOnFailure" ];
    then
       exitOnFailure="true"
    fi

  
    printf "\n++++++++++++++++++++++++++++++++++++++++++\n"
    printf "\n     TEST EXECUTION SUMMARY"
    printf "\n     ++++++++++++++++++++++   \n"
    printf "       NO OF TEST PASSED:  ${passcount} \n"
    printf "       NO OF TEST FAILED:  ${failcount} \n"
    printf "\n++++++++++++++++++++++++++++++++++++++++++\n"

    if [ "$exitOnFailure" == "true" ];
    then
      if [ $failcount -gt 0 ];
      then
        exit 1
      fi
    fi
}

function startTest()
{
    TEST_INFO="${FUNCNAME[1]}"
    printf "\n\n"
    echo " -----------------------------------------------------------------------------------------"
    echo " TEST EXECUTION START:  >>>>>>     ${TEST_INFO}      <<<<<<<<<<<<<<<<<<<"
}

function endTest()
{
    TEST_INFO="${FUNCNAME[1]}"
    echo " TEST EXECUTION  END :   >>>>>>     ${TEST_INFO}      <<<<<<<<<<<<<<<<<<<"
    echo " -----------------------------------------------------------------------------------------"
    printf "\n\n"

    printTestSummary "false"
}

function print_heading()
{
  text="$1"
  echo -e "\n################ $text #############\n"
  echo -e "-----------------------------------------------------\n"
}

function isUtilityInstalled()
{
    startTest

    utilityName="$1"    
    
    yum list installed | grep "$utilityName"

    if [ "$?" != "0" ];
    then
       echo "FAILURE - Utility $utilityName not found. "
       notifyFail
    else
       echo "SUCCESS - Utility $utilityName found."
       notifyPass
    fi

    endTest
}


function testWDTInstallation()
{

    if [ ! -d "$WDT_HOME" ];
    then
        echo "FAILURE: Weblogic Deploy Tool not found"
        notifyFail
        endTest
        return
    else
        echo "SUCCESS: Weblogic Deploy Tool found"
        notifyPass
        
        $WDT_HOME/bin/createDomain.sh

        if [ "$?" != "0" ];
        then
            echo "FAILURE: Failed to verify Deploy Tool"
            notifyFail
        else
            echo "SUCCESS: Deploy tool verified successfully"
            notifyPass
        fi
    fi

    endTest    
}

source ${UTILS_DIR}/test_config.properties

export passcount=0
export failcount=0
