#!/bin/bash

FOLDER="../roles/grafana/files/dashboards"
TIME=$(date "+%Y-%m-%d_%H%M")

# Check dependencies (curl & js)
if command -v curl >/dev/null 2>&1 ; then
    :
else
    echo "Please install cURL"
    exit
fi

if command -v jq >/dev/null 2>&1 ; then
    :
else
    echo "Please install jq"
    exit
fi

# Choose to reference vagrant or production
echo "Do you want to save dashboards from the Vagrant environment or from production (10.2.110.250)?"
select env in "Vagrant" "Production"; do
    case $env in
        Vagrant ) ENV=localhost; break;;
        Production ) ENV=192.168.1.5; break;;
    esac
done

# GET list of dashboard uids
echo "Downloading dashboard UIDS"
UIDS=$(curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://$ENV:3000/api/search\?type\=dash-db | tail -n1 | jq '.[].uid' | sed s/\"//g)
echo "-----------------------------------"

# Backup old dashboards
echo "Backing up old dashboards"
for f in $FOLDER/*.json
do
    cp $f $f.$TIME.bk
done
echo "----------------------------------"

# GET each dashboard and save JSON to file
echo "Saving dashboards"
for u in $UIDS
do
    JSON=$(curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://$ENV:3000/api/dashboards/uid/$u | tail -n1 | jq '.dashboard')
    TITLE=$(echo "$JSON" | jq '.title' | sed s/\"//g)
    touch $FOLDER'/'$TITLE'-'$u'.json'
    echo "$JSON" > $FOLDER'/'$TITLE'-'$u'.json'
done
