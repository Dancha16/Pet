Nginx Log Parser Script
This repository contains a Bash script designed to parse an nginx.log file and generate a report of IP addresses along with the number of requests made from each IP. The script includes multiple ways to achieve this and provides additional functionality such as sorting, displaying the request count per IP, and fetching the country of origin for each IP address using the ipinfo.io API.

Features:
Parses the Nginx log file to extract IP addresses.
Generates a sorted list of IPs and the number of requests associated with each.
Includes a third column for country information (hard level).
Supports multiple methods of log parsing for flexibility.
Command-line flags for file input and help options.
How to Run:
Use the -f or --file flag to specify the path to the Nginx log file.
Use the -h or --help flag for usage information.
Practice:
This project is also designed for AWS practice, allowing users to deploy the solution on an Amazon EC2 instance and save the generated reports to an S3 bucket.
Feel free to review the code and suggest improvements via pull requests!
