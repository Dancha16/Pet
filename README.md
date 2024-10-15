---

# **Nginx Log Parser Script**

This pet-project repository contains a Bash script that parses an Nginx log file (`nginx.log`) and generates a report of IP addresses, the number of requests from each IP, and optionally, the country associated with each IP address.

## **Features**
- Parses Nginx log files to extract and count IP addresses.
- Outputs a sorted list of IPs with the corresponding request counts.
- Option to add country information for each IP address (hard level).
- Implements two different methods for parsing the log.
- Supports command-line flags for ease of use.

## **Usage**

### **Flags**
- `-f` or `--file`: Specifies the log file path.
- `-m` or `--method`: Chooses the parsing method (1 for awk, 2 for grep + cut, 3 for IPinfo grepip).
- `-c` or `--country`: Adds a country lookup feature using ipinfo.io.
- `-h` or `--help`: Displays usage instructions.

### **Running the Script**

1. **Basic Parsing (Method 1 - Using `awk`):**
   ```bash
   ./script.sh -f nginx.log -m 1
   ```

2. **Basic Parsing (Method 2 - Using `grep`):**
    ```bash
   ./script.sh -m 2
   ```

3. **Basic Parsing (Method 3 - Using `IPinfo grepip`):**
   ```bash
   ./script.sh -m 3
   ```
4. **Parsing with country fetch**
   The script fetches the country code for each IP address using the ipinfo.io API:
   ```bash 
   ./script.sh -m 1 -c 
   ```
   or 

   ```bash
   ./script.sh -f nginx.log -m 2 -c
   ```
   or 

   ```bash
   ./script.sh -f /your_path/nginx.log -m 3 -c
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
- `IPinfo CLI` (optional, for additional IPinfo parsing, [GitHub](https://github.com/ipinfo/cli))

## **Installation**

1. Clone the repository:
   ```bash
   git clone https://github.com/Dancha16/nginx-log-parser-script.git
   cd nginx-log-parser-script
   ```

2. Run the script with the desired flags.

## **Download Files**

You can download the `script.sh` and `nginx.log` files directly from my S3 bucket:

- [Download `script.sh`](https://nginx-log-parser-script.s3.eu-north-1.amazonaws.com/script.sh)
- [Download `nginx.log`](https://nginx-log-parser-script.s3.eu-north-1.amazonaws.com/nginx.log)

To run the script, download the files and use the instructions above.

## **Contributing**
Feel free to fork this repository, make changes, and submit pull requests. Suggestions and improvements are welcome!

## **License**
This project is licensed under the MIT License.

---
