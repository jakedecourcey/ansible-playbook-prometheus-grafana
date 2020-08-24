#!/bin/bash

# Check dependencies (curl)
if command -v curl >/dev/null 2>&1 ; then
    :
else
    echo "Please install cURL"
fi

# Choose to reference vagrant or production
echo "Do you want to create and alert in the Vagrant environment or from production (10.2.110.250)?"
select env in "Vagrant" "Production"; do
    case $env in
        Vagrant ) ENV=localhost; break;;
        Production ) ENV=10.2.110.250; break;;
    esac
done

#Create an alert using the Alertmanager API
echo "What type of alert do you want to generate?"
select sev in "Critical" "Warn"; do
    case $sev in
        Critical ) SEV=critical; break;;
        Warn ) SEV=warn; break;;
    esac
done

curl -H "Content-Type: application/json" -d '[{"status": "firing", "labels":{"alertname":"'$SEV'TestAlert", "severity":"'$SEV'"}}]' $ENV:9093/api/v1/alerts
