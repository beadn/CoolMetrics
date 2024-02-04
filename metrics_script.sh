#!/bin/bash

# Define an array of allowed metrics
allowed_metrics=("cpu-usage" "memory-usage" "disk-usage" "network-traffic" "database-load")

while true; do
    # Generate a random sleep duration between 1 and 15 seconds
    sleep_duration=$((RANDOM % 15 + 1))
    sleep $sleep_duration

    # Generate a random value between 1 and 100
    random_value=$((RANDOM % 100 + 1))

    # Get the current timestamp
    current_time=$(date +"%Y-%m-%dT%H:%M:%S")

    # Randomly select a metric from the allowed list
    metric=${allowed_metrics[$RANDOM % ${#allowed_metrics[@]}]}

    # Make the curl request
    curl --location 'http://localhost:3000/api/v1/metrics' \
    --header 'Content-Type: application/json' \
    --request POST \
    --data "{
        \"metric\": {
            \"name\": \"$metric\",
            \"value\": $random_value
        }
    }" > /dev/null 2>&1

    # Output a dot
    echo -n '.'
done
