#!/bin/bash


log_file=""
method=1
country_flag=false

# Help 
show_help() {
  echo "Usage: $0 [-f <file>] [-m <method>] [-c] [-h]"
  echo ""
  echo "Options:"
  echo "  -f, --file     Path to the Nginx log file"
  echo "  -m, --method   Parsing method (1: awk, 2: grep)"
  echo "  -c, --country  Fetch country information for each IP"
  echo "  -h, --help     Show help information"
  echo ""
  echo "Examples:"
  echo "  $0 -f nginx.log -m 1"
  echo "  $0 -f nginx.log -m 2 -c"
}

# Перший метод через awk
parse_with_awk() {
  echo "Using awk to parse the log file..."
  awk '{print $1}' "$log_file" | sort | uniq -c | sort -nr | awk '{print $2, $1}'
}

# Другий метод через grep
parse_with_grep_cut() {
  echo "Using grep to parse the log file..."
  grep -oP '^\d+\.\d+\.\d+\.\d+' "$log_file" | sort | uniq -c | sort -nr | awk '{print $2, $1}'
}

# Функція визначення країни
get_country() {
  ip=$1
  country=$(curl -s https://ipinfo.io/$ip | jq -r '.country')
  echo "$country"
}

#Додавання столбця країни до видачі 
add_country_info() {
  while read -r line; do
    ip=$(echo "$line" | awk '{print $1}')
    requests=$(echo "$line" | awk '{print $2}')
    country=$(get_country "$ip")
    echo "$ip $requests $country"
  done
}

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

# Перевірка лог файлу
if [ -z "$log_file" ]; then
  echo "Error: Log file not provided."
  show_help
  exit 1
fi

if [ ! -f "$log_file" ]; then
  echo "Error: Log file not found: $log_file"
  exit 1
fi

# Вибор методу
if [ "$method" -eq 1 ]; then
  result=$(parse_with_awk)
elif [ "$method" -eq 2 ]; then
  result=$(parse_with_grep_cut)
else
  echo "Error: Invalid method selected. Choose 1 or 2."
  exit 1
fi

# Додання флагу визначення країни
if [ "$country_flag" = true ]; then
  echo "$result" | add_country_info
else
  echo "$result"
fi
