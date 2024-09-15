#!/Users/aman/miniconda3/bin/python

import socket
import concurrent.futures
import subprocess


def check_ip(ip):
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        print(f"Checking {ip}...")
        sock.settimeout(2)  # Set a timeout of 1 second
        result = sock.connect_ex((ip, 8999))
        sock.close()
        if result == 0:
            return ip
    except Exception:
        pass
    return None


def scan_network():
    base_ip = "192.168.1."
    valid_ip = None

    with concurrent.futures.ThreadPoolExecutor(max_workers=50) as executor:
        future_to_ip = {
            executor.submit(check_ip, f"{base_ip}{i}"): i for i in range(1, 255)
        }
        for future in concurrent.futures.as_completed(future_to_ip):
            ip = future.result()
            if ip:
                valid_ip = ip
                break  # Stop checking once a valid IP is found

        # Cancel all remaining futures
        for future in future_to_ip:
            future.cancel()

    return [valid_ip] if valid_ip else []


def update_dnsmasq_config(ip):
    domain = "docker.home.server"
    config_file = "/opt/homebrew/etc/dnsmasq.conf"

    updated_line = f"address=/{domain}/{ip}\n"

    try:
        # Read the current config
        with open(config_file, "r") as f:
            lines = f.readlines()

        # Check if the domain already exists in the config
        for i, line in enumerate(lines):
            if line.startswith(f"address=/{domain}/"):
                lines[i] = updated_line
                break
        else:
            # If the domain doesn't exist, append the new line
            lines.append(updated_line)

        # Write the updated config back to the file
        with open(config_file, "w") as f:
            f.writelines(lines)

        print(f"Updated dnsmasq config for {domain} with IP {ip}")

        # Restart dnsmasq service
        subprocess.run(["sudo", "brew", "services", "restart", "dnsmasq"], check=True)
        print("Restarted dnsmasq service")

    except Exception as e:
        print(f"Error updating dnsmasq config: {e}")


if __name__ == "__main__":
    print("Scanning network. This may take a minute...")
    results = scan_network()

    if results:
        print(f"Found IP address responding on port 8999: {results[0]}")
        update_dnsmasq_config(results[0])
    else:
        print("No IP addresses responded on port 8999.")
        user_input = input(
            "Do you want to add the local IP (127.0.0.1) instead? (y/n): "
        ).lower()
        if user_input == "y":
            update_dnsmasq_config("127.0.0.1")
        else:
            print("No changes made to the DNS configuration.")
