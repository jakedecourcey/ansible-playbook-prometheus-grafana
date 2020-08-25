#! /bin/bash

# Define configs to check
RULES="../roles/prometheus/files/rules/*.yml"

# Check dependencies (promtool)
if command -v promtool >/dev/null 2>&1 ; then
    :
else
    echo "Please install Prometheus locally"
fi

for rule in $RULES
do
    ansible localhost -c local -m template -a "src=../roles/prometheus/templates/$rule dest=./$rule.yml" --extra-vars=@../roles/prometheus/defaults/main.yml &> /dev/null

    promtool check rules $rule
done

rm -rf *.yml
