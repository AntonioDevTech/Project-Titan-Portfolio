# 🛡️ Project Titan: Autonomous Cloud Infrastructure

> **"I didn't just build a server. I engineered an autonomous digital fortress."**

### 🔗 Live System: [alfanotechport.org](https://alfanotechport.org)

---

## 📖 Executive Summary
**Project Titan** is a combat-tested cloud infrastructure built on **Microsoft Azure**. Unlike standard static portfolios, Titan is an **active, self-healing system** protected by a custom AI security daemon.

The goal was to architect a system that prioritizes **resilience and autonomy**, decoupling software from hardware using **Terraform (IaC)** to eliminate single points of failure. This system operates autonomously, defends itself against network attacks, and heals itself if critical services fail.

---

## 🏗️ Architecture & Logic Flow
The core of Titan is the **Security Daemon**, which acts as the central brain. It pulls raw network data, consults the AI for a threat verdict, and then enforces firewall rules at the kernel level.

```mermaid
graph TD
    %% --- COLOR DEFINITIONS ---
    classDef external fill:#e3f2fd,stroke:#1565c0,stroke-width:2px,color:#0d47a1;
    classDef kernel fill:#fff9c4,stroke:#fbc02d,stroke-width:2px,color:#e65100;
    classDef app fill:#e8f5e9,stroke:#2e7d32,stroke-width:2px,color:#1b5e20;
    classDef ai fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px,color:#4a148c;
    classDef storage fill:#efebe9,stroke:#5d4037,stroke-width:2px,color:#3e2723;

    %% --- EXTERNAL ACTORS ---
    User["💀 User / Attacker"] -->|"HTTP Traffic (Port 80)"| Firewall["🔥 Azure NSG Firewall"]
    Firewall -->|"Filtered Traffic"| VM["☁️ Azure Linux VM (Host)"]

    %% --- THE HOST MACHINE ---
    subgraph "The Unkillable Node (Project Titan)"
        direction TB

        %% RING 0 - KERNEL & SECURITY
        subgraph "Kernel Space (Ring 0)"
            SystemD["⚙️ Systemd Supervisor"]:::kernel
            Netstat["🔎 Kernel Network Stack"]:::kernel
            Iptables["🛡️ IP Tables (Firewall Rules)"]:::kernel
            TitanDaemon["🐍 Titan Security Daemon"]:::kernel
        end

        %% USER SPACE - INFRASTRUCTURE
        subgraph "Application Layer"
            Nginx["🌐 Nginx Reverse Proxy"]:::app
            App["💻 C# .NET Backend"]:::app
            SQL[("🗄️ SQL Database")]:::storage
        end
        
        %% AI LAYER
        subgraph "Docker Container"
            Llama["🤖 Llama 3.2 (Threat Analysis)"]:::ai
        end
    end

    %% --- TRAFFIC & LOGIC FLOWS ---
    %% 1. Happy Path
    VM --> Nginx
    Nginx -->|"Reverse Proxy"| App
    App -->|"Read/Write"| SQL

    %% 2. Active Defense Loop (THE LOGIC FLOW)
    TitanDaemon --"1. Scans Active Connections"--> Netstat
    Netstat --"2. Returns Threat Data"--> TitanDaemon
    TitanDaemon --"3. Sends Data for Analysis"--> Llama
    Llama --"4. Verdict: MALICIOUS"--> TitanDaemon
    TitanDaemon --"5. Updates Firewall Rules"--> Iptables
    Iptables --"6. DROP CONNECTION"--> User

    %% --- APPLY STYLES ---
    class User,Firewall,VM external;
