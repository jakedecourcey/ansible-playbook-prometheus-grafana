#! /bin/bash

# Define configs to check
CONFIGS=( prometheus )

# Check dependencies (promtool)
if command -v promtool >/dev/null 2>&1 ; then
    :
else
    echo "Please install Prometheus locally"
fi

for config in "${CONFIGS[@]}"
do
    ansible localhost -c local -m template -a "src=../roles/prometheus/templates/$config.yml.j2 dest=./$config.yml" --extra-vars=@../roles/prometheus/defaults/main.yml &> /dev/null

    promtool check config $config.yml
done
