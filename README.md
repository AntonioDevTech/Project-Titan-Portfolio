# 🛡️ Project Titan: The Unkillable Cloud Infrastructure

> **"I didn't just build a server. I engineered an autonomous digital fortress."**

### 🔗 Live System: [https://titanalfapro.org](https://titanalfapro.org)

---

## 📖 Executive Summary
**Project Titan** is a combat-tested cloud infrastructure built on **Microsoft Azure**. Unlike standard static portfolios, Titan is an **active, self-healing system** protected by a custom AI security daemon.

The goal was to demonstrate **Senior-Level DevOps & Engineering** capabilities by decoupling software from hardware. This system operates autonomously, defends itself against network attacks, and heals itself if critical services fail.

---

## 🏗️ Architecture Diagram
This system utilizes a "Hybrid-Host" architecture to bypass Docker network isolation, allowing the C# Backend to communicate with the Llama 3.2 AI over raw TCP sockets.

```mermaid
graph TD
    User["🌍 User / Attacker"] -->|HTTP Request| Firewall["🔥 Azure NSG Firewall"]
    Firewall -->|Allowed Traffic| VM["☁️ Azure Linux VM"]
    
    subgraph "The Unkillable Node (Project Titan)"
        direction TB
        
        subgraph "Kernel Layer (Ring 0)"
            SystemD["⚙️ Systemd Supervisor"]
            TitanDaemon["🐍 Titan Security Daemon (Python)"]
        end
        
        subgraph "Application Layer"
            Nginx["🌐 Nginx Web Server"]
            App["💻 C# .NET Backend"]
            SQL[("🗄️ SQL Database")]
        end
        
        subgraph "AI Inference Layer"
            Docker["🐳 Docker Container"]
            Llama["🤖 Llama 3.2 Vision AI"]
        end
    end

    %% Logic Flows
    SystemD --"Auto-Restarts (500ms)"--> Nginx
    SystemD --"Auto-Restarts"--> TitanDaemon
    
    TitanDaemon --"Monitors PIDs"--> App
    TitanDaemon --"Scans Network (Netstat)"--> Firewall
    TitanDaemon --"Kicks Attacker"--> User
    
    App --"Raw TCP Socket"--> Llama
    Docker --"Hosts Environment"--> Llama
    Llama --"Threat Analysis"--> TitanDaemon
