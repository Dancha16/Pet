#!/bin/bash

# Variables
log_file="./Pet/nginx.log"
method=1
country_flag=false

# Help function
show_help() {
  echo "Usage: $0 [-f <file>] [-m <method>] [-c] [-h]"
  echo ""
  echo "Options:"
  echo "  -f, --file     Path to the Nginx log file (default: $log_file)"
  echo "  -m, --method   Parsing method (1: awk, 2: grep+cut)"
  echo "  -c, --country  Fetch country information for each IP"
  echo "  -h, --help     Show help information"
  echo ""
  echo "Examples:"
  echo "  $0 -f /path/to/nginx.log -m 1"
  echo "  $0 -m 2 -c"  # Allows running without -f
}

# Function to parse log and count requests per IP (Method 1: using awk)
parse_with_awk() {
  echo "Using awk to parse the log file..."
  awk '{print $1}' "$log_file" | sort | uniq -c | sort -nr | awk '{print $2, $1}'
}

# Function to parse log and count requests per IP (Method 2: using grep + cut)
parse_with_grep_cut() {
  echo "Using grep and cut to parse the log file..."
  grep -o '^[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' "$log_file" | sort | uniq -c | sort -nr | awk '{print $2, $1}'
}

# Function to fetch country info for an IP
get_country() {
  ip=$1
  country=$(curl -s https://ipinfo.io/$ip | jq -r '.country')
  echo "$country"
}

# Function to parse log and add country info
add_country_info() {
  while read -r line; do
    ip=$(echo "$line" | awk '{print $1}')
    requests=$(echo "$line" | awk '{print $2}')
    # Skip private IPs
    if [[ "$ip" =~ ^10\.|^172\.16\.|^192\.168\. ]]; then
      echo "$ip $requests null"
      continue
    fi
    country=$(get_country "$ip")
    echo "$ip $requests $country"
  done
}

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -f|--file)
      log_file="$2"
      shift
      ;;
    -m|--method)
      method="$2"
      shift
      ;;
    -c|--country)
      country_flag=true
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      echo "Unknown parameter passed: $1"
      show_help
      exit 1
      ;;
  esac
  shift
done

# Check if log file exists
if [ ! -f "$log_file" ]; then
  echo "Error: Log file not found: $log_file"
  exit 1
fi

# Choose parsing method and process log file
if [ "$method" -eq 1 ]; then
  result=$(parse_with_awk)
elif [ "$method" -eq 2 ]; then
  result=$(parse_with_grep_cut)
else
  echo "Error: Invalid method selected. Choose 1 or 2."
  exit 1
fi

# Add country info if flag is set
if [ "$country_flag" = true ]; then
  echo "$result" | add_country_info
else
  echo "$result"
fi

