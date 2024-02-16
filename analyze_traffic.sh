#!/bin/bash

# Bash Script to Analyze Network Traffic

# Input: Path to the Wireshark pcap file
# capture input from terminal.
if [ $# -ne 1 ]; then
    echo "$0 <your_capture_file.pcap>" 
    exit 1   
fi

if [ ! -f "$1" ]; then
    echo "Error: your_capture_file.pcap path is not found"
    exit 1
fi

pcap_file="$1"

# Storing commands outputs to variabls
your_total_packets=$(tshark -r "$pcap_file" | wc -l)
your_http_packets=$(tshark -r "$pcap_file" -Y http | wc -l)
your_https_packets=$(tshark -r "$pcap_file" -Y ssl | wc -l)      # -Y ssl or -Y tls to filter for https

# Function to extract information from the pcap file
analyze_traffic() {
    # Use tshark or similar commands for packet analysis.
    # Hint: Consider commands to count total packets, filter by protocols (HTTP, HTTPS/TLS),
    # extract IP addresses, and generate summary statistics.

    # Output analysis summary
    echo "----- Network Traffic Analysis Report -----"
    # Provide summary information based on your analysis
    # Hints: Total packets, protocols, top source, and destination IP addresses.
    echo "1. Total Packets: $your_total_packets "
    echo ""

    echo "2. Protocols:"
    echo "   - HTTP: $your_http_packets packets"
    echo "   - HTTPS/TLS: $your_https_packets packets"
    echo ""
    
    echo "3. Top 5 Source IP Addresses:"
    # Provide the top source IP addresses
    # TOP5_SRC_IPS =
    #      tshark -r network_traffic.pcap -T fields -e ip.src | sort | uniq -c | sort -nr | awk '{print $2}' | head -5
    #      this command will print the top 5 source ip then sorting and counting number of occurrences and print only first column(IP)
    # TOP5_SRC_IPS_PACKETS =
    #   tshark -r network_traffic.pcap -T fields -e ip.src | sort | uniq -c | sort -nr | awk '{print $1}' | head -5
    #      this command will print the top 5 source ip then sorting and counting number of occurrences and print only second column(counter)

    # to make the output match the desired form "-   IP: N packets" 
    paste <(tshark -r network_traffic.pcap -T fields -e ip.src | sort | uniq -c | sort -nr | awk '{print $2}' | head -5) <(tshark -r network_traffic.pcap -T fields -e ip.src | sort | uniq -c | sort -nr | awk '{print $1}' | head -5) | awk '{printf "      - "; for (i=1; i<=NF; i++) {printf "%s", $i; if(i<NF) printf ": "} print " packets"}'
    echo ""

    echo "4. Top 5 Destination IP Addresses:"
    # Provide the top destination IP addresses
    # TOP5_DST_IPS =
    #    tshark -r network_traffic.pcap -T fields -e ip.dst | sort | uniq -c | sort -nr | awk '{print $2}' | head -5
    # TOP5_DST_IPS_PACKETS =
    #    tshark -r network_traffic.pcap -T fields -e ip.dst | sort | uniq -c | sort -nr | awk '{print $1}' | head -5

    paste <(tshark -r network_traffic.pcap -T fields -e ip.dst | sort | uniq -c | sort -nr | awk '{print $2}' | head -5) <(tshark -r network_traffic.pcap -T fields -e ip.src | sort | uniq -c | sort -nr | awk '{print $1}' | head -5) | awk '{printf "      - "; for (i=1; i<=NF; i++) {printf "%s", $i; if(i<NF) printf ": "} print " packets"}'

    echo ""
    echo "----- End of Report -----"
}

# Run the analysis function
analyze_traffic