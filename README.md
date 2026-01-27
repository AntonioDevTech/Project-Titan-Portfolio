# 🛡️ Project Titan: Autonomous Cloud Infrastructure

> **"I didn't just build a server. I engineered an autonomous digital fortress."**

### 🔗 Live System: [alfanotechport.org](https://alfanotechport.org)

---

## 👨‍💻 About Me
**Antonio Alfano** | **Site Reliability Engineer & Cloud Architect**

I bridge the gap between physical microchip diagnostics (Layer 1) and enterprise cloud architecture. **Dual US 🇺🇸 / Canadian 🇨🇦 Citizen** and **Former CFL Professional Athlete** (Edmonton Elks) turned Systems Engineer. I bring elite discipline to building "Unkillable" self-healing infrastructure.

---

## 📖 Executive Summary
**Project Titan** is a combat-tested cloud infrastructure built on **Microsoft Azure**. Unlike standard static portfolios, Titan is an **active, self-healing system** protected by a custom AI security daemon.

The goal was to architect a system that prioritizes **resilience and autonomy**, decoupling software from hardware using **Terraform (IaC)** to eliminate single points of failure. This system operates autonomously, defends itself against network attacks, and heals itself if critical services fail.

---

## 🏗️ Architecture Diagram
This system utilizes a "Hybrid-Host" architecture to bypass Docker network isolation, allowing the C# Backend to communicate with the Security Daemon over raw TCP sockets. The diagram below illustrates the full logic flow, utilizing color-coded zones to distinguish between Kernel Space, User Space, and Active Defense layers.

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
    end

    %% --- TRAFFIC & LOGIC FLOWS ---
    %% 1. Happy Path
    VM --> Nginx
    Nginx -->|"Reverse Proxy (Internal Loopback)"| App
    App -->|"Read/Write Telemetry"| SQL

    %% 2. Self-Healing Loops
    SystemD --"Watchdog (PID Monitor)"--> Nginx
    SystemD --"Watchdog (PID Monitor)"--> App
    SystemD --"Watchdog (PID Monitor)"--> SQL
    SystemD --"Watchdog (PID Monitor)"--> TitanDaemon

    %% 3. Active Defense Loops
    TitanDaemon --"1. Scans Active Connections"--> Netstat
    Netstat --"Returns Threat Data"--> TitanDaemon
    TitanDaemon --"2. Threat Analysis"--> TitanDaemon
    TitanDaemon --"3. Updates Rules"--> Iptables
    Iptables --"4. BLOCKS IP"--> User

    %% --- APPLY STYLES ---
    class User,Firewall,VM external;
