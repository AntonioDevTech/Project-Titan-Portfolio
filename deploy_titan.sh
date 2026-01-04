# TITAN DEPLOYMENT SCRIPT
# -----------------------
# Automated Deployment for titanalfapro.org

# 1. FAIL-SAFE FILE COPY
find / -type f -name "MCC_App.zip" -not -path "/var/www/html/*" -exec cp -f {} /var/www/html/MCC_App.zip \;
chmod 644 /var/www/html/MCC_App.zip

# 2. OVERWRITE INDEX.HTML (DOMAIN EDITION)
cat > /var/www/html/index.html <<'HTML_END'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Project Titan | Antonio Alfano</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        /* TITAN THEME */
        :root {
            --bg-body: #020202;
            --bg-surface: #0a0a0a;
            --brand-primary: #00ff41; 
            --brand-glow: rgba(0, 255, 65, 0.45); 
            --text-heading: #ffffff;
            --text-body: #cccccc;
        }
        body {
            font-family: 'Segoe UI', Roboto, sans-serif;
            background-color: var(--bg-body);
            color: var(--text-heading);
            margin: 0; padding: 0;
            overflow-x: hidden;
        }
        .glow-text { text-shadow: 0 0 15px var(--brand-glow); }
        .tech-section {
            padding: 5rem 1rem;
            max-width: 1400px;
            margin: 0 auto;
            border-bottom: 1px solid #1a1a1a;
        }
        .section-header {
            text-align: center;
            margin-bottom: 3rem;
            font-size: 2.5rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 2px;
            color: var(--brand-primary);
            text-shadow: 0 0 15px var(--brand-glow);
        }
        .card-custom {
            background: var(--bg-surface);
            border: 1px solid #333;
            border-left: 4px solid var(--brand-primary);
            padding: 2rem;
            border-radius: 4px;
            transition: all 0.3s ease;
            box-shadow: 0 0 0 rgba(0,0,0,0);
            height: 100%;
        }
        .card-custom:hover {
            transform: translateY(-5px);
            box-shadow: 0 0 25px var(--brand-glow);
            border-color: var(--brand-primary);
        }
        .btn-cyber {
            background: transparent;
            border: 1px solid var(--brand-primary);
            color: var(--brand-primary);
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            padding: 10px 20px;
            transition: 0.3s;
            text-decoration: none;
            display: inline-block;
            margin-top: 10px;
            cursor: pointer;
        }
        .btn-cyber:hover {
            background: var(--brand-primary);
            color: black;
            box-shadow: 0 0 20px var(--brand-glow);
        }
        .social-icon { font-size: 2rem; transition: transform 0.3s, text-shadow 0.3s; }
        .social-icon:hover { transform: translateY(-5px); }
        .icon-github { color: #ffffff; }
        .icon-github:hover { text-shadow: 0 0 20px white; color: #fff; }
        .icon-linkedin { color: #0077b5; }
        .icon-linkedin:hover { text-shadow: 0 0 20px #0077b5; color: #0077b5; }
        .icon-insta { color: #e1306c; }
        .icon-insta:hover { text-shadow: 0 0 20px #e1306c; color: #e1306c; }
        .grid-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 2rem;
        }
        .detail-box {
            display: none;
            background: #0f1110;
            padding: 2rem;
            margin-top: 2rem;
            border: 1px solid var(--brand-primary);
            box-shadow: 0 0 15px var(--brand-glow);
        }
        .detail-box.active { display: block; animation: fadeUp 0.5s; }
        @keyframes fadeUp { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        /* --- HYPER-TERMINAL STYLES --- */
        .terminal-window {
            background-color: #050505;
            border: 1px solid #333;
            border-top: 3px solid var(--brand-primary);
            border-radius: 5px;
            padding: 15px;
            font-family: 'Courier New', monospace;
            height: 450px;
            overflow: hidden;
            box-shadow: 0 0 40px rgba(0, 255, 65, 0.15);
            position: relative;
        }
        .terminal-window::before {
            content: " ";
            display: block;
            position: absolute;
            top: 0; left: 0; bottom: 0; right: 0;
            background: linear-gradient(rgba(18, 16, 16, 0) 50%, rgba(0, 0, 0, 0.25) 50%), linear-gradient(90deg, rgba(255, 0, 0, 0.06), rgba(0, 255, 0, 0.02), rgba(0, 0, 255, 0.06));
            z-index: 2;
            background-size: 100% 2px, 3px 100%;
            pointer-events: none;
        }
        .terminal-text {
            color: var(--brand-primary);
            font-size: 0.85rem;
            line-height: 1.2;
            white-space: pre-wrap;
            word-break: break-all;
            text-shadow: 0 0 5px var(--brand-glow);
        }
        .cursor {
            display: inline-block;
            width: 8px;
            height: 15px;
            background: var(--brand-primary);
            animation: blink 1s infinite;
        }
        @keyframes blink { 0% { opacity: 0; } 50% { opacity: 1; } 100% { opacity: 0; } }
        ul.custom-list { list-style: none; padding-left: 0; }
        ul.custom-list li { margin-bottom: 10px; padding-left: 20px; position: relative; }
        ul.custom-list li::before { content: "►"; color: var(--brand-primary); position: absolute; left: 0; font-size: 0.8em; top: 4px; }
    </style>
</head>
<body>
    <div class="tech-section" style="padding-top: 6rem; padding-bottom: 6rem;">
        <div class="row align-items-center">
            <div class="col-lg-7">
                <h6 style="color: var(--brand-primary); letter-spacing: 3px;">SYSTEM ONLINE // v21.0.0 (TITAN ACTIVE)</h6>
                <h1 class="display-2 fw-bold mb-2 glow-text" style="font-weight: 900; letter-spacing: -2px;">PROJECT TITAN</h1>
                <h4 class="mb-4" style="color: #888;">Edge-to-Cloud Infrastructure | Engineered by Antonio Alfano</h4>
                <p style="border-left: 4px solid var(--brand-primary); padding-left: 20px; color: #ddd; font-size: 1.25rem; margin-top: 2rem;">
                    <strong>Hello! My name is Antonio Alfano and welcome to my tech portfolio.</strong>
                    <br><br>
                    I didn't just want to tell you I can code, I wanted to <strong>show</strong> you.
                    <br><br>
                    I architected this entire ecosystem using <strong>Terraform, Azure Cloud, Ubuntu Linux, Bash, PowerShell, C#, and SQL</strong>.
                    <br><br>
                    You are currently interacting with a live, combat-tested environment at <strong>titanalfapro.org</strong>. This isn’t a static template. This system is unkillable. It is protected by 'Titan', a custom AI security daemon I engineered and coded myself. It fights off attackers and hackers by monitoring the network layer and adapting in real-time generating live defense code to neutralize threats instantly.
                    <br><br>
                    <strong>Check out my technical projects below.</strong>
                </p>
                <div class="mt-5 d-flex gap-3 flex-wrap">
                    <button class="btn-cyber" onclick="document.getElementById('war-stories').scrollIntoView({behavior: 'smooth'})">
                        <i class="bi bi-terminal-fill"></i> Engineering Deep Dive
                    </button>
                    <a href="http://titanalfapro.org:9090" target="_blank" class="btn-cyber">
                        <i class="bi bi-robot"></i> Access Titan AI
                    </a>
                </div>
                <div class="mt-5">
                    <h5 class="text-uppercase mb-3" style="letter-spacing: 2px; color: #666; font-size: 0.9rem;">Let's Connect</h5>
                    <div class="d-flex gap-4">
                        <a href="https://github.com/AntonioDevTech" target="_blank" class="social-icon icon-github"><i class="bi bi-github"></i></a>
                        <a href="http://www.linkedin.com/in/antonio-alfano-273162358" target="_blank" class="social-icon icon-linkedin"><i class="bi bi-linkedin"></i></a>
                        <a href="https://instagram.com/officialtone_" target="_blank" class="social-icon icon-insta"><i class="bi bi-instagram"></i></a>
                    </div>
                </div>
            </div>
            <div class="col-lg-5 d-none d-lg-block">
                <div class="terminal-window">
                    <div id="terminal-content" class="terminal-text"></div>
                    <div class="cursor"></div>
                </div>
            </div>
        </div>
    </div>
    <div id="war-stories" class="tech-section">
        <h2 class="section-header">Roadblocks & Solutions</h2>
        <p class="text-center" style="color: #aaa; max-width: 800px; margin: 0 auto 3rem auto;">
            Building this took 2 days of intense troubleshooting. I faced networking blocks, resource limits, and kernel crashes. Here is how I solved them using Cloud Engineering principles.
        </p>
        <div class="grid-container">
            <div class="card-custom" style="cursor: pointer;" onclick="openDetail('panic')">
                <i class="bi bi-exclamation-triangle-fill" style="font-size: 2rem; color: var(--brand-primary);"></i>
                <h4 class="mt-3">The "Panic" Environment</h4>
                <p class="small text-secondary">Azure RunCommand Failure.</p>
            </div>
            <div class="card-custom" style="cursor: pointer;" onclick="openDetail('oom')">
                <i class="bi bi-memory" style="font-size: 2rem; color: var(--brand-primary);"></i>
                <h4 class="mt-3">The 1GB Memory Wall</h4>
                <p class="small text-secondary">Kernel OOM Killer.</p>
            </div>
            <div class="card-custom" style="cursor: pointer;" onclick="openDetail('docker')">
                <i class="bi bi-box-seam" style="font-size: 2rem; color: var(--brand-primary);"></i>
                <h4 class="mt-3">Docker Network Isolation</h4>
                <p class="small text-secondary">Bridge vs Host Mode.</p>
            </div>
            <div class="card-custom" style="cursor: pointer;" onclick="openDetail('security')">
                <i class="bi bi-shield-lock-fill" style="font-size: 2rem; color: var(--brand-primary);"></i>
                <h4 class="mt-3">Titan Security Protocol</h4>
                <p class="small text-secondary">Active Defense & Self-Healing.</p>
            </div>
            <div class="card-custom" style="cursor: pointer;" onclick="openDetail('cloud')">
                <i class="bi bi-cloud-check-fill" style="font-size: 2rem; color: var(--brand-primary);"></i>
                <h4 class="mt-3">Enterprise Cloud Architecture</h4>
                <p class="small text-secondary">High Availability & Scaling.</p>
            </div>
        </div>
        <div id="detail-panic" class="detail-box">
            <h3 style="color: var(--brand-primary);">Problem: "Panic: $HOME is not defined"</h3>
            <p><strong>The Issue:</strong> When attempting to automate the AI deployment via Azure's RunCommand agent, the script crashed instantly with a Go panic error.<br><br><strong>The Engineering Fix:</strong> I diagnosed that the Azure non-interactive shell environment does not load standard user profiles. I utilized <strong>Bash Scripting</strong> and <strong>PowerShell</strong> logic to manually inject the environment variable (<code>export HOME=/root</code>) before execution, creating a custom startup pipeline.</p>
        </div>
        <div id="detail-oom" class="detail-box">
            <h3 style="color: var(--brand-primary);">Problem: The Linux OOM Killer</h3>
            <p><strong>The Issue:</strong> The initial deployment on a B1s (1GB RAM) VM resulted in immediate service termination. The <strong>Ubuntu Linux</strong> Kernel's Out-Of-Memory (OOM) watchdog was killing the <strong>SQL Server</strong> process.<br><br><strong>The Engineering Fix:</strong> I analyzed the memory footprint using <strong>Linux</strong> tools like <code>dmesg</code>. The Llama 3.2 AI model required ~5GB of overhead. I executed a vertical scaling operation to a B4ms instance (16GB RAM) and optimized the <strong>SQL</strong> database configuration to coexist with the AI.</p>
        </div>
        <div id="detail-docker" class="detail-box">
            <h3 style="color: var(--brand-primary);">Problem: Container Isolation</h3>
            <p><strong>The Issue:</strong> The "Brain" of the application (built in <strong>C# .NET</strong>) could not communicate with the AI Engine (Ollama) running inside <strong>Docker</strong> due to network isolation.<br><br><strong>The Engineering Fix:</strong> I identified that Docker's default "Bridge" network created a subnet barrier. I re-wrote the <strong>Bash</strong> deployment script to use <code>--network host</code>. This allowed the <strong>C#</strong> backend to communicate directly with the AI engine via raw TCP on localhost.</p>
        </div>
        <div id="detail-security" class="detail-box">
            <h3 style="color: var(--brand-primary);">How "Unkillable" Works</h3>
            <p><strong>Self-Healing Logic:</strong> I wrote a custom <code>systemd</code> unit file that utilizes the Linux kernel's process supervision capabilities. By setting <code>Restart=always</code>, the kernel watches the Process ID (PID) and instantly intercepts any crash or termination signal to respawn the application before the connection times out.<br><br><strong>Active Counter-Measures:</strong> It's not just about staying alive; it's about fighting back. If a hacker attempts to breach the system, the AI detects the intrusion pattern in real-time. It actively "kicks them out" by dynamically adapting the firewall rules to neutralize the threat while the self-healing protocol keeps the core services online.</p>
        </div>
        <div id="detail-cloud" class="detail-box">
            <h3 style="color: var(--brand-primary);">Problem: Compute Capacity & Persistence</h3>
            <p><strong>The Issue:</strong> The massive footprint of the AI neural network and the requirement for 24/7 security monitoring exceeded entry-level cloud limitations. The basic infrastructure could not support the continuous "Always-On" state required by the Titan Daemon.<br><br><strong>The Engineering Fix:</strong> I architected a production-ready environment on <strong>Microsoft Azure</strong> using <strong>Terraform</strong>. I provisioned enterprise-grade, high-performance compute resources to house the entire stack. This guarantees that the AI Security Layer has the raw power to remain active and vigilant at all times, maintaining 100% uptime without performance degradation.</p>
        </div>
    </div>
    <div class="tech-section">
        <h2 class="section-header">Project Portfolio</h2>
        <div class="card-custom mb-5">
            <div class="row align-items-center">
                <div class="col-lg-12">
                    <h3 class="glow-text">Azure Cloud Infrastructure Automation</h3>
                    <div class="mb-3">
                         <span class="badge bg-warning text-dark">Terraform</span>
                         <span class="badge bg-primary">Azure Cloud</span>
                         <span class="badge bg-secondary">Ubuntu Linux</span>
                    </div>
                    <ul class="custom-list">
                        <li><strong>Infrastructure as Code (IaC):</strong> Architected and deployed a cloud environment on Microsoft Azure using <strong>Terraform</strong>.</li>
                        <li><strong>Network Engineering:</strong> Designed a segmented Virtual Network (VNet) topology with dedicated subnets.</li>
                        <li><strong>Security Hardening:</strong> Implemented a Zero-Trust perimeter using Network Security Groups (NSGs).</li>
                        <li><strong>Automated Configuration:</strong> Scripted the automated deployment of an Nginx web server and SQL backend.</li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="card-custom mb-5">
            <div class="row align-items-center">
                <div class="col-lg-3 text-center">
                    <div style="font-size: 5rem; color: var(--brand-primary);">🛡️</div>
                </div>
                <div class="col-lg-9">
                    <h3 class="glow-text">Titan AI: Hosted LLM</h3>
                    <div class="mb-3">
                        <span class="badge bg-primary">Docker</span>
                        <span class="badge bg-success">Llama 3.2 Vision</span>
                        <span class="badge bg-secondary">Ollama</span>
                    </div>
                    <p>This is a locally hosted Large Language Model running in a Docker container. It does not rely on external APIs. I bypassed Docker's bridge network using "Host Networking" mode to allow local inference.</p>
                    <a href="http://titanalfapro.org:9090" target="_blank" class="btn-cyber"><i class="bi bi-lightning-charge-fill"></i> Click Here to Use Titan Alfano</a>
                </div>
            </div>
        </div>
        <div class="card-custom mb-5">
            <div class="row align-items-center">
                <div class="col-lg-8">
                    <h3 class="glow-text">Miner Control Center (MCC)</h3>
                    <div class="mb-3">
                        <span class="badge bg-success text-dark">C# .NET</span>
                        <span class="badge bg-light text-dark">SQL Database</span>
                        <span class="badge bg-secondary">Real-Time Telemetry</span>
                    </div>
                    <p>I built this tool to manage crypto mining hardware. I reverse-engineered the manufacturers' JSON-RPC protocol to inject configuration payloads directly via raw TCP sockets.<br><br><strong>Key Engineering Feature: Real-Time Telemetry</strong><br>The application establishes a continuous data stream, polling chip temperatures, fan RPMs, and hashrate data every 500ms. This data is serialized and stored in a local SQL database for historical thermal analysis.</p>
                    <a href="MCC_App.zip" class="btn-cyber" download><i class="bi bi-download"></i> Download App</a>
                    <button class="btn-cyber" data-bs-toggle="modal" data-bs-target="#minerModal">Technical Specs</button>
                </div>
            </div>
        </div>
        <div class="card-custom">
            <h3 class="glow-text mb-4">Hardware Repair: ASIC Microchip Surgery</h3>
            <div class="row">
                <div class="col-lg-6">
                    <div class="ratio ratio-16x9" style="border: 1px solid var(--brand-primary); box-shadow: 0 0 15px var(--brand-glow);">
                        <iframe src="https://www.youtube.com/embed/6k99gKbVLG4" title="Microchip Repair" allowfullscreen></iframe>
                    </div>
                </div>
                <div class="col-lg-6 mt-3 mt-lg-0">
                    <p>My day job is diagnosing and repairing critical failures on Whatsminers and Antminers. In this case, I diagnosed a hashboard where the CLK (Clock) line was reading a static 1.8V due to an internal short. I performed a precision BGA rework to replace the silicon and restore signal integrity.</p>
                    <a href="https://youtube.com/shorts/6k99gKbVLG4" target="_blank" class="btn-cyber"><i class="bi bi-youtube"></i> Watch on YouTube</a>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="minerModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content" style="background: #111; border: 1px solid var(--brand-primary);">
                <div class="modal-header">
                    <h5 class="modal-title text-white">MCC Internal Logic</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-secondary">
                    <p>The core loop uses <code>System.Net.Sockets.TcpClient</code> inside an Async/Await pattern to prevent UI freezing. The hardest part was normalizing the data. Antminers and Whatsminers format their JSON responses differently. I had to write an adapter pattern to standardize the telemetry before binding it to the SQL backend.</p>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openDetail(id) {
            document.querySelectorAll('.detail-box').forEach(el => el.classList.remove('active'));
            document.getElementById('detail-' + id).classList.add('active');
        }
        (function() {
            const container = document.getElementById('terminal-content');
            const lines = [
                "[BOOT] Kernel initialized",
                "[TITAN] Loading security daemon...",
                "[TITAN] Integrity Check: PASS",
                "[NET] eth0 up, IP: titanalfapro.org",
                "[TITAN] Monitoring ports 80, 443, 9090",
                "[SCAN] Inbound packet analysis: OK",
                "0x45F2A Memory Allocation [OK]",
                "[TITAN] AI Model: Llama 3.2 Vision [READY]",
                "[TITAN] Neural Net active",
                "Downloading weights... 100%",
                "[LOG] User connected from remote IP",
                "[TITAN] Threat Level: ZERO",
                "[SQL] Database handshake verified",
                "[TITAN] Watchdog timer reset",
                "Processing telemetry stream...",
                "Hashing: 125 TH/s",
                "Temp: 65C / Fan: 4500 RPM",
                "[TITAN] System is UNKILLABLE",
                "[TITAN] Standing by..."
            ];
            function addRandomLine() {
                const randomHex = "0x" + Math.floor(Math.random()*16777215).toString(16).toUpperCase();
                const randomLine = lines[Math.floor(Math.random() * lines.length)];
                const text = (Math.random() > 0.7) ? `[MEM] ${randomHex} allocation verified` : randomLine;
                const p = document.createElement('div');
                p.textContent = "> " + text;
                container.appendChild(p);
                container.parentElement.scrollTop = container.parentElement.scrollHeight;
                if(container.children.length > 20) {
                    container.removeChild(container.firstChild);
                }
            }
            setInterval(addRandomLine, 80);
        })();
    </script>
</body>
</html>
HTML_END

systemctl restart nginx
