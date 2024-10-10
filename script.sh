#!/bin/bash

# Variables
log_file="./nginx.log"
method=1
country_flag=false

# Help function
show_help() {
  echo "Usage: $0 [-f <file>] [-m <method>] [-c] [-h]"
  echo ""
  echo "Options:"
  echo "  -f, --file     Path to the Nginx log file (default: $log_file)"
  echo "  -m, --method   Parsing method (1: awk, 2: grep+cut, 3: IPinfo grepip)"
  echo "  -c, --country  Fetch country information for each IP"
  echo "  -h, --help     Show help information"
  echo ""
  echo "Examples:"
  echo "  $0 -f /path/to/nginx.log -m 1"
  echo "  $0 -m 2 -c"  # Allows running without -f
  echo "  $0 -m 3"
}

# Function to parse log and count requests per IP (Method 1: using awk)
parse_with_awk() {
  awk '{print $1}' "$log_file" | sort | uniq -c | sort -nr | awk '{print $2, $1}'
}

# Function to parse log and count requests per IP (Method 2: using grep + cut)
parse_with_grep_cut() {
  grep -o '^[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' "$log_file" | sort | uniq -c | sort -nr | awk '{print $2, $1}'
}

# Function to parse log and cound requests per IP (Method 3: using IPinfo grep)
parse_with_ipinfo() {
  ipinfo grepip --only-matching "$log_file" | sort | uniq -c | sort -nr | awk '{print $2, $1}'
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
    # Validate that the line starts with a valid IP address
    if [[ "$line" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}\ [0-9]+$ ]]; then
      ip=$(echo "$line" | awk '{print $1}')
      requests=$(echo "$line" | awk '{print $2}')
      
      # Skip private IPs without printing anything
      if [[ "$ip" =~ ^10\.|^172\.1[6-9]|2[0-9]|3[0-1]\.|^192\.168\.|^127\.0\.0\.1$ ]]; then
        continue
      fi

      country=$(get_country "$ip")
      
      # Check if country information is available
      if [ -z "$country" ] || [ "$country" == "null" ]; then
        country="unknown"
      fi
      echo "$ip $requests $country"
    fi
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
case $method in
  1)
    echo "Using awk to parse the log file..."
    result=$(parse_with_awk)
    ;;
  2)
    echo "Using grep and cut to parse the log file..."
    result=$(parse_with_grep_cut)
    ;;
  3)
    echo "Using IPinfo grepip to parse the log file..."
    result=$(parse_with_ipinfo)
    ;;
  *)
    echo "Error: Invalid method selected. Choose 1, 2, or 3."
    exit 1
    ;;
esac

# Add country info if flag is set
if [ "$country_flag" = true ]; then
  echo "$result" | add_country_info
else
  echo "$result"
fi
