#!/bin/bash
#-----------------------
# Script to check for deprecated api's, see https://access.redhat.com/articles/6329921
#-----------------------


#-----------------------
# Functions
#-----------------------

check_login() {
    get_user=$(oc whoami 2>/dev/null)

    if [ -z ${get_user} ]; then
        echo "Not logged in to the cluster"
    else
        echo "User ${get_user} is logged in"
    fi
}


get_dep_api() {

    get_api=$1
    result=$(oc api-resources --api-group=${get_api} --no-headers)

    # Check result
    if [ -z "${result}" ]; then
        echo -e "No api resources found, nothing to be done\n"
    else
        echo "${result}\n"
    fi
}

#-----------------------
# Main
#-----------------------

# Check if we can loging
check_login

# Read the dep api list
DEP_LIST=$(<dep-api-list)

# Loop through the list deprecated api's
for DEP in ${DEP_LIST}; do
    # Assign name to the resource and api path
    RESOURCE=$(echo "${DEP}" | cut -d ',' -f1)
    API=$(echo "${DEP}" | cut -d ',' -f2)

    echo "Checking resource: ${RESOURCE} and api: ${API}"
   
    # Check if there are any depcrecated api's
    get_dep_api ${API}
done
