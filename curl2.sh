#!/bin/bash

start_year=$1
end_year=$2

# Validate command line arguments
if [ -z "$start_year" ] || [ -z "$end_year" ]; then
  echo "Please provide start year and end year as command line arguments."
  echo "Usage: ./script.sh <start_year> <end_year>"
  exit 1
fi

# Calculate the number of years between start year and end year
num_years=$((end_year - start_year + 1))

# Create the date array dynamically
for ((i = 0; i < num_years; i++)); do
  start_date=$((start_year + i))"-01-01"
  end_date=$((start_year + i))"-06-30"
  DATE[$i]="$start_date..$end_date"
done

# Loop over the date array and make the API requests
for d in "${DATE[@]}"; do
  for i in {0..10}; do
    curl "https://api.github.com/search/repositories?q=embedded+language:C+created:${d}&per_page=100&page=$i" |
      jq -r '.items[].ssh_url' >>embedded_repos.txt
    sleep 5
  done
  sleep 10
done
