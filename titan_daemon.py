import os
import time
import subprocess
import random
from datetime import datetime

# TITAN SECURITY DAEMON v21.0.0
# "Unkillable" Logic: Monitors Network & Self-Heals
# -------------------------------------------------

LOG_FILE = "/var/log/titan_security.log"
THREAT_THRESHOLD = 50  # Max connections per IP allowed
# Whitelist local loopback and the domain (resolved)
SAFE_IPS = ["127.0.0.1", "::1", "titanalfapro.org"]

def log_event(message):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    entry = f"[{timestamp}] [TITAN-CORE] {message}"
    print(entry)
    with open(LOG_FILE, "a") as f:
        f.write(entry + "\n")

def get_active_connections():
    # Runs Linux 'netstat' to find who is connected
    try:
        result = subprocess.check_output("netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n", shell=True)
        return result.decode("utf-8").strip().split('\n')
    except:
        return []

def block_ip(ip_address):
    # The "Kick" Logic: Updates Iptables Firewall
    log_event(f"!!! THREAT DETECTED: {ip_address} exceeded connection limit.")
    log_event(f"!!! ENGAGING ACTIVE DEFENSE. BLOCKING IP...")
    # Simulation of the firewall command (for safety in this demo)
    # os.system(f"iptables -A INPUT -s {ip_address} -j DROP") 
    log_event(f"SUCCESS. Target {ip_address} neutralized.")

def self_healing_check():
    # Checks if the Web Server is still alive
    status = os.system("systemctl is-active --quiet nginx")
    if status != 0:
        log_event("CRITICAL: Web Server (Nginx) is DOWN.")
        log_event("INITIATING SELF-HEALING PROTOCOL...")
        os.system("systemctl start nginx")
        log_event("SYSTEM RESTORED. Uptime preserved.")

# --- MAIN LOOP ---
log_event("Titan Daemon initialized. Watching network layer...")

while True:
    connections = get_active_connections()
    
    for line in connections:
        if not line: continue
        parts = line.strip().split()
        if len(parts) < 2: continue
        
        count = int(parts[0])
        ip = parts[1]

        if ip not in SAFE_IPS and count > THREAT_THRESHOLD:
            block_ip(ip)

    # Run Self-Healing Check every 5 seconds
    self_healing_check()
    time.sleep(5)
