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
UIDS=$(curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://$ENV:3000/api/search\?type\=dash-db | tail -n1 | jq '.[].uid' | sed s/\"//g)

# Backup old dashboards
for f in ./$FOLDER/*.json
do
    cp $f $f.$TIME.bk
done

# GET each dashboard and save JSON to file
for d in $UIDS
do
    JSON=$(curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://$ENV:3000/api/dashboards/uid/$d | tail -n1)
    TITLE=$(echo $JSON | jq '.dashboard.title' | sed s/\"//g)
    echo $JSON > ./$FOLDER/$TITLE-$d.json
done
