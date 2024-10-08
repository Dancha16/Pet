Here’s a detailed `README.md` for your repository:

---

# **Nginx Log Parser Script**

This repository contains a Bash script that parses an Nginx log file (`nginx.log`) and generates a report of IP addresses, the number of requests from each IP, and optionally, the country associated with each IP address.

## **Features**
- Parses Nginx log files to extract and count IP addresses.
- Outputs a sorted list of IPs with the corresponding request counts.
- Option to add country information for each IP address (hard level).
- Implements two different methods for parsing the log.
- Supports command-line flags for ease of use.

## **Usage**

### **Flags**
- `-f` or `--file`: Specifies the Nginx log file to parse.
- `-h` or `--help`: Displays usage information.

### **Running the Script**

1. **Basic Parsing (Method 1 - Using `awk`):**
   ```bash
   ./script.sh -f /path/to/nginx.log
   ```

2. **Basic Parsing (Method 2 - Using `grep` and `cut`):**
   You can switch the method used within the script by modifying the implementation.

3. **Adding Country Information (Hard Level):**
   The script fetches the country code for each IP address using the `ipinfo.io` API:
   ```bash
   ./script.sh -f /path/to/nginx.log
   ```

### **Example Output**
```
IP Address    Request Count    Country
1.1.1.1       12               US
43.12.65.11   8                UA
```

## **Requirements**
- Bash
- `curl` (for country lookup)
- `jq` (optional, for additional JSON parsing)
  
## **Installation**

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/reponame.git
   cd reponame
   ```

2. Run the script with the desired flags.

## **AWS S3 Integration**
You can practice saving the report file to an AWS S3 bucket:
1. Install AWS CLI and configure it:
   ```bash
   sudo yum install aws-cli -y
   aws configure
   ```
2. Save the output to a file and upload it to S3:
   ```bash
   ./script.sh -f /path/to/nginx.log > report.txt
   aws s3 cp report.txt s3://your-s3-bucket-name/
   ```

## **Contributing**
Feel free to fork this repository, make changes, and submit pull requests. Suggestions and improvements are welcome!

## **License**
This project is licensed under the MIT License.

---
