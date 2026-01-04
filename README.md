# 🛡️ Project Titan: The Unkillable Cloud Infrastructure

> **"I didn't just build a server. I engineered an autonomous digital fortress."**

### 🔗 Live System: [https://titanalfapro.org](https://titanalfapro.org)

---

## 📖 Executive Summary
**Project Titan** is a combat-tested cloud infrastructure built on **Microsoft Azure**. Unlike standard static portfolios, Titan is an **active, self-healing system** protected by a custom AI security daemon.

The goal was to demonstrate **Senior-Level DevOps & Engineering** capabilities by decoupling software from hardware. This system operates autonomously, defends itself against network attacks, and heals itself if critical services fail.

---

## 🏗️ Architecture Diagram
This system utilizes a "Hybrid-Host" architecture to bypass Docker network isolation, allowing the C# Backend to communicate with the Llama 3.2 AI over raw TCP sockets. The diagram below illustrates the full logic flow, including the Kernel Supervision (Ring 0) and the Active Defense Loop.

```mermaid
graph TD
    %% EXTERNAL ACTORS
    User["💀 User / Attacker"] -->|"HTTP Traffic (Port 80) & AI (Port 9090)"| Firewall["🔥 Azure NSG Firewall"]
    Firewall -->|"Filtered Traffic"| VM["☁️ Azure Linux VM (Host)"]

    %% THE HOST MACHINE
    subgraph "The Unkillable Node (Project Titan)"
        direction TB

        %% RING 0 - KERNEL & SECURITY
        subgraph "Kernel Space (Ring 0)"
            SystemD["⚙️ Systemd Supervisor"]
            Netstat["🔎 Kernel Network Stack"]
            Iptables["🛡️ IP Tables (Firewall Rules)"]
            TitanDaemon["🐍 Titan Security Daemon"]
        end

        %% USER SPACE - INFRASTRUCTURE
        subgraph "Application Layer"
            Nginx["🌐 Nginx Reverse Proxy"]
            App["💻 C# .NET Backend"]
            SQL[("🗄️ SQL Database")]
        end

        %% CONTAINER SPACE
        subgraph "Docker Isolation"
            Docker["🐳 Docker Engine"]
            subgraph "Container"
                Llama["🤖 Llama 3.2 Vision AI"]
            end
        end
    end

    %% 1. TRAFFIC FLOW (The Happy Path)
    VM --> Nginx
    Nginx -->|"Reverse Proxy (Internal Loopback)"| App
    App -->|"Read/Write Telemetry"| SQL
    App -->|"Raw TCP Socket (Host Network)"| Llama

    %% 2. HOSTING LOGIC
    Docker --"Runs & Manages"--> Llama

    %% 3. SELF-HEALING LOOPS (SystemD Supervision)
    SystemD --"Watchdog (PID Monitor)"--> Nginx
    SystemD --"Watchdog (PID Monitor)"--> App
    SystemD --"Watchdog (PID Monitor)"--> SQL
    SystemD --"Watchdog (PID Monitor)"--> TitanDaemon

    %% 4. ACTIVE DEFENSE LOOPS (The Titan Logic)
    TitanDaemon --"1. Scans Active Connections"--> Netstat
    Netstat --"Returns Threat Data"--> TitanDaemon
    TitanDaemon --"2. Threat Analysis"--> Llama
    Llama --"3. Kill Decision"--> TitanDaemon
    TitanDaemon --"4. Updates Rules"--> Iptables
    Iptables --"5. BLOCKS IP"--> User
