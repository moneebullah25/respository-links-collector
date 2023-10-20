#!/bin/bash

# Set up variables
base_url="https://api.github.com/search/repositories"
search_query="embedded+language:C"
per_page=100
output_file="embedded_c_urls_curl.txt"

# Calculate date range for the last 6 months
current_date=$(date +%Y-%m-%d)
start_date=$(date -d "$current_date -6 months" +%Y-%m-%d)

# Loop over date segments
while [[ "$current_date" > "$start_date" ]]
do
  # Calculate end date as 7 days before the current date
  end_date=$(date -d "$current_date -1 week" +%Y-%m-%d)

  # Format the date range for the search query
  date_range="created:$end_date..$current_date"

  # Construct the search API URL
  api_url="${base_url}?q=${search_query}+${date_range}&per_page=${per_page}"

  # Make the API call and extract SSH URLs using jq
  curl -s "$api_url" | jq -r '.items[].ssh_url' >> "$output_file"

  # Update current date for the next iteration
  current_date=$end_date
done
