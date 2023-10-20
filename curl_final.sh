#!/bin/bash

# Default values
name="embedded"
language="language:C"
division=6
output_file=""
page=10
start_year=$(date +%Y)
end_year=$start_year

# Process command line arguments
while getopts ":n:l:d:o:p:s:e:" opt; do
  case $opt in
    n)
      name=$OPTARG
      ;;
    l)
      language="language:$OPTARG"
      ;;
    d)
      division=$OPTARG
      ;;
    o)
      output_file=$OPTARG
      ;;
    p)
      page=$OPTARG
      ;;
    s)
      start_year=$OPTARG
      ;;
    e)
      end_year=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Validate output file argument
if [ -z "$output_file" ]; then
  echo "Please provide an output file path using the -o option."
  echo "Usage: ./script.sh -o <output_file> [optional_arguments]"
  exit 1
fi

# Calculate the number of years between start year and end year
num_years=$((end_year - start_year + 1))

# Create the date array dynamically
for ((i = 0; i < num_years; i++)); do
  start_date=$(date -d "$i year ago" +%Y-%m-01)
  end_date=$(date -d "$((i - division + 1)) year ago" +%Y-%m-30)
  DATE[$i]="$start_date..$end_date"
done

# Loop over the date array and make the API requests
for d in "${DATE[@]}"; do
  for ((i = 1; i <= page; i++)); do
    curl "https://api.github.com/search/repositories?q=$name+$language+created:${d}&per_page=100&page=$i" |
      jq -r '.items[].ssh_url' >>"$output_file"
    sleep 5
  done
  sleep 10
done
